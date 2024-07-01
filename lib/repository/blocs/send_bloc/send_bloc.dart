import 'package:bloc/bloc.dart';
import 'package:corderos_app/!helpers/print_helper.dart';
import 'package:corderos_app/data/preferences/preferences.dart';
import 'package:corderos_app/repository/!repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite_simple_dao_backend/database/database/sql_builder.dart';
import '../../../data/!data.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

part 'send_event.dart';

part 'send_state.dart';

class SendBloc extends Bloc<SendEvent, SendState> {
  List<DeliveryTicket> tickets = [];
  Client client = Client();
  Map<String, double> totalWeightNotConsolidated = {};
  Map<String, int> totalAnimalsNotConsolidated = {};
  Map<String, int> totalLosses = {};
  Map<String, double> totalLossesWeight = {};

  SendBloc() : super(SendLoading()) {
    on<SendClientEmail>(_sendClientEmail);
    on<AddSelected>(_addSelectedTicket);
    on<SelectEmailClient>(_selectClient);
    on<Initialize>(_initialize);
  }

  Future<void> _initialize(Initialize event, Emitter<SendState> emit) async {
    tickets = event.tickets;
  }

  Future<void> _sendClientEmail(
      SendClientEmail event, Emitter<SendState> emit) async {
    emit(SendLoading());
    try {
      List<DeliveryTicketModel> ticketModels =
          await _convertTicketsToModels(tickets);
      List<ProductTicketModel> productTicketModels = [];

      // Obtener todos los ProductTicketModels asociados
      for (var ticket in ticketModels) {
        productTicketModels.addAll(await _getProductTickets(ticket.id!));
      }

      String emailBody =
          await _buildEmailBody(ticketModels, productTicketModels);

      PrintHelper printHelper = PrintHelper();
      final itemsMap = await printHelper.getBluetooth();
      printHelper.printExit(event.context, itemsMap.values.toList().first,
          ticketModels, productTicketModels, client);

      var email = Email(
        body: emailBody,
        subject: 'Ticket de entrega',
        recipients: [client.email ?? ''],
      );

      await FlutterEmailSender.send(email);

      ClientDeliveryNote clientDeliveryNote = ClientDeliveryNote();
      ProductDeliveryNote productDeliveryNote = ProductDeliveryNote();

      clientDeliveryNote.clientId = client.id;
      clientDeliveryNote.date = DateTime.now();
      List<ClientDeliveryNote> clients =
          await clientDeliveryNote.selectAll<ClientDeliveryNote>();

      if (clients.isNotEmpty) {
        var lastClient =
            await clientDeliveryNote.selectLast<ClientDeliveryNote>();
        clientDeliveryNote.number = lastClient.number! + 1;
      } else {
        clientDeliveryNote.number = 1;
      }

      int slaughterhouseId = await Preferences.getValue('slaughterhouse');
      String vehicleRegistrationPreferences =
          await Preferences.getValue('vehicle_registration');
      List<VehicleRegistration> listVehicleRegistration =
          await VehicleRegistration().getData<VehicleRegistration>(where: [
        'vehicleRegistrationNum',
        SqlBuilder.constOperators['equals']!,
        "'$vehicleRegistrationPreferences'"
      ]);
      VehicleRegistration vehicleRegistration = listVehicleRegistration.first;

      clientDeliveryNote.series = vehicleRegistration.deliveryTicket;
      clientDeliveryNote.slaughterhouseId = slaughterhouseId;
      clientDeliveryNote.isSend = false;

      await clientDeliveryNote.insert();

      // Consolidar datos antes de guardarlos en ProductDeliveryNote
      Map<String, Map<String, Map<String, Tuple2<double, int>>>> productsMap =
          _consolidateProductData(productTicketModels);

      // Guardar los datos consolidados
      for (var productEntry in productsMap.entries) {
        String product = productEntry.key;
        for (var classificationEntry in productEntry.value.entries) {
          String classification = classificationEntry.key;
          for (var performanceEntry in classificationEntry.value.entries) {
            String performance = performanceEntry.key;
            double totalWeight = performanceEntry.value.item1;
            int totalAnimals = performanceEntry.value.item2;

            totalWeight = ((totalWeightNotConsolidated[classification] ?? 0) /
                    (totalAnimalsNotConsolidated[classification] ?? 0)) +
                totalAnimals;

            productDeliveryNote.idDeliveryNote = clientDeliveryNote.id;
            productDeliveryNote.idProduct = productTicketModels
                .firstWhere((t) => t.product!.name == product)
                .product!
                .id;
            productDeliveryNote.idClassification = productTicketModels
                .firstWhere((t) => t.classification!.name == classification)
                .classification!
                .id;
            productDeliveryNote.nameClassification = classification;
            productDeliveryNote.units = totalAnimals;
            productDeliveryNote.kilograms = totalWeight;
            productDeliveryNote.color = productTicketModels
                .firstWhere(
                    (t) => t.performance!.performance.toString() == performance)
                .color;

            await productDeliveryNote.insert();
          }
        }
      }

      for (var x in tickets) {
        x.idOut = clientDeliveryNote.id;
        await x.update();
      }
      emit(SendSuccess('Correo enviado', [], 'SendEmail'));
    } catch (e) {
      emit(SendError('Error enviando correo'));
    }
  }

  Map<String, Map<String, Map<String, Tuple2<double, int>>>>
      _consolidateProductData(List<ProductTicketModel> productTicketModels) {
    Map<String, Map<String, Map<String, Tuple2<double, int>>>> productsMap = {};

    for (var e in productTicketModels) {
      if (e.product != null &&
          e.classification != null &&
          e.performance != null &&
          e.weight != null &&
          e.numAnimals != null) {
        totalWeightNotConsolidated.putIfAbsent(
            e.classification!.name!, () => 0);
        totalWeightNotConsolidated[e.classification!.name!] =
            totalWeightNotConsolidated[e.classification!.name!]! + e.weight!;

        totalAnimalsNotConsolidated.putIfAbsent(
            e.classification!.name!, () => 0);
        totalAnimalsNotConsolidated[e.classification!.name!] =
            totalAnimalsNotConsolidated[e.classification!.name!]! +
                e.numAnimals!;

        totalLosses.putIfAbsent(e.classification!.name!, () => 0);
        totalLosses[e.classification!.name!] =
            totalLosses[e.classification!.name!]! + (e.losses ?? 0);

        totalLossesWeight.putIfAbsent(e.classification!.name!, () => 0);
        totalLossesWeight[e.classification!.name!] =
            totalLossesWeight[e.classification!.name!]! + (e.weightLosses ?? 0);

        String productKey = e.product!.name!;
        String classificationKey = e.classification!.name!;
        String performanceKey = e.performance!.performance.toString();

        productsMap.putIfAbsent(productKey, () => {});
        productsMap[productKey]!.putIfAbsent(classificationKey, () => {});
        productsMap[productKey]![classificationKey]!
            .putIfAbsent(performanceKey, () => Tuple2(0.0, 0));

        productsMap[productKey]![classificationKey]![performanceKey] = Tuple2(
          productsMap[productKey]![classificationKey]![performanceKey]!.item1 +
              e.weight!,
          productsMap[productKey]![classificationKey]![performanceKey]!.item2 +
              (e.numAnimals! - (e.losses ?? 0)),
        );
      }
    }

    return productsMap;
  }

  Future<List<DeliveryTicketModel>> _convertTicketsToModels(
      List<DeliveryTicket> tickets) async {
    List<DeliveryTicketModel> ticketModels = [];
    for (var ticket in tickets) {
      ticketModels.add(await DeliveryTicketModel().fromEntity(ticket));
    }
    return ticketModels;
  }

  Future<String> _buildEmailBody(List<DeliveryTicketModel> ticketModels,
      List<ProductTicketModel> productTicketModels) async {
    String emailBody = '';

    emailBody += await _buildTicketString(ticketModels.first);
    emailBody += _buildProductTicketsString(productTicketModels);
    emailBody += '-----------------------------\n';
    return emailBody;
  }

  Future<List<ProductTicketModel>> _getProductTickets(int ticketId) async {
    List<ProductTicket> productTickets = await ProductTicket()
        .getData<ProductTicket>(where: ['idTicket = $ticketId']);
    List<ProductTicketModel> productTicketModels = [];
    for (var x in productTickets) {
      productTicketModels.add(await ProductTicketModel().fromEntity(x));
    }
    return productTicketModels;
  }

  Future<String> _buildTicketString(DeliveryTicketModel ticket) async {
    return '-----------------------------\n'
        '           Ticket\n'
        '-----------------------------\n'
        'Serie: ${ticket.deliveryTicket ?? 'N/A'}\n'
        'Numero: ${ticket.number ?? 'N/A'}\n'
        'Fecha: ${ticket.date?.toString() ?? 'N/A'}\n'
        'Conductor: ${ticket.driver?.name ?? 'N/A'}, NIF: ${ticket.driver?.nif ?? 'N/A'}\n'
        'Matricula: ${ticket.vehicleRegistration?.vehicleRegistrationNum ?? 'N/A'}\n'
        'Matadero: ${ticket.slaughterhouse?.name ?? 'N/A'}\n'
        'Cliente: ${client.name}, NIF: ${client.nif}\n'
        '- - - - - - - - - - - - - - - - - - -\n';
  }

  String _buildProductTicketsString(
      List<ProductTicketModel> productTicketModels) {
    String productTicketsString = '';

    Map<String, Map<String, Map<String, Tuple2<double, int>>>> productsMap =
        _consolidateProductData(productTicketModels);

    productsMap.forEach((product, classifications) {
      double totalWeightProduct = 0;
      int totalAnimalsProduct = 0;
      int totalLossesProduct = 0;
      double totalLossesWeightProduct = 0;

      productTicketsString += 'Producto: $product\n';
      productTicketsString += 'No\t||\tClase\t||\tKgs.\n';
      classifications.forEach((classification, performances) {
        double totalWeightClassification = 0;
        int totalAnimalsClassification = 0;

        performances.forEach((performance, data) {
          double totalWeight = data.item1;
          int totalAnimals = data.item2;
          totalWeightClassification += totalWeight;
          totalAnimalsClassification += totalAnimals;
        });

        totalWeightProduct += totalWeightClassification;
        totalAnimalsProduct += totalAnimalsClassification;
        totalLossesProduct += totalLosses[classification] ?? 0;
        totalLossesWeightProduct += totalLossesWeight[classification] ?? 0;
        productTicketsString +=
            '$totalAnimalsClassification\t||\t$classification\t||\t${totalLossesWeight[classification]}\n';
      });

      productTicketsString += 'Total Peso: $totalWeightProduct\n';
      productTicketsString += 'Total Animales: $totalAnimalsProduct\n';
      if (totalLossesProduct > 0) {
        productTicketsString +=
            'Total Bajas: $totalLossesProduct -> ${totalLossesWeightProduct.toStringAsFixed(2)} kgs.\n';
      }
      productTicketsString += '- - - - - - - - - - - - - - - - - - -\n';
    });

    return productTicketsString;
  }

  void _addSelectedTicket(AddSelected event, Emitter<SendState> emit) {
    emit(SendLoading());
    try {
      if (!tickets.contains(event.selected)) {
        tickets.add(event.selected);
      } else {
        tickets.remove(event.selected);
      }
      emit(SendSuccess('Ticket añadido', tickets, 'AddSelected'));
    } catch (e) {
      emit(SendError('Error añadiendo ticket'));
    }
  }

  void _selectClient(SelectEmailClient event, Emitter<SendState> emit) async {
    emit(SendLoading());
    try {
      var clientSelect = await client.getData<Client>(where: [
        'id',
        SqlBuilder.constOperators['equals']!,
        '${event.selectedClient}'
      ]);
      client = clientSelect.first;
      emit(SendSuccess('Cliente seleccionado', [], 'SelectClient'));
    } catch (e) {
      emit(SendError('Error seleccionando cliente'));
    }
  }
}

// Clase auxiliar para almacenar dos valores (peso y número de animales)
class Tuple2<T1, T2> {
  final T1 item1;
  final T2 item2;

  Tuple2(this.item1, this.item2);
}
