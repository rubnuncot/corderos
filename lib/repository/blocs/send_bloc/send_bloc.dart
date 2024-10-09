import 'package:bloc/bloc.dart';
import 'package:corderos_app/repository/!repository.dart';
import 'package:corderos_app/repository/data_conversion/!data_conversion.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite_simple_dao_backend/database/database/sql_builder.dart';
import '../../../!helpers/file_logger.dart';
import '../../../!helpers/print_helper.dart';
import '../../../data/!data.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import '../../../data/preferences/preferences.dart';

part 'send_event.dart';
part 'send_state.dart';

class SendBloc extends Bloc<SendEvent, SendState> {
  List<DeliveryTicket> tickets = [];
  Client client = Client();

  SendBloc() : super(SendLoading()) {
    on<SendClientEmail>(_sendClientEmail);
    on<AddSelected>(_addSelectedTicket);
    on<SelectEmailClient>(_selectClient);
    on<Initialize>(_initialize);
  }

  Future<void> _initialize(Initialize event, Emitter<SendState> emit) async {
    tickets = event.tickets;
  }

  Future<void> _sendClientEmail(SendClientEmail event, Emitter<SendState> emit) async {
    emit(SendLoading());
    String printExit = '';
    try {
      List<DeliveryTicketModel> ticketModels = await _convertTicketsToModels(tickets);
      List<ProductTicketModel> productTicketModels = [];

      // Obtener todos los ProductTicketModels asociados
      for (var ticket in ticketModels) {
        productTicketModels.addAll(await _getProductTickets(ticket.id!));
      }

      String emailBody = await _buildEmailBody(ticketModels, productTicketModels, client.id!);

      PrintHelper printHelper = PrintHelper();
      final itemsMap = await printHelper.getBluetooth();
      printExit = await printHelper.printExit(event.context, itemsMap.values.toList().first, ticketModels, productTicketModels, client);
      Client clientAsovino = await DatabaseRepository.getEntityByCode(Client(), '0000') as Client;

      var email = Email(
        body: emailBody,
        subject: 'Ticket de entrega',
        recipients: [client.email ?? '', clientAsovino.email ?? ''],
      );

      await FlutterEmailSender.send(email);

      // Guardar datos en la base de datos
      await _saveData(ticketModels, productTicketModels);

      emit(SendSuccess('Correo enviado y datos guardados', [], 'SendEmail'));
    } catch (e) {
      FileLogger fileLogger = FileLogger();

      fileLogger.handleError(e, message: printExit, file: 'send_bloc.dart');
      emit(SendError('Error enviando correo'));
    }
  }

  Future<void> _saveData(List<DeliveryTicketModel> ticketModels, List<ProductTicketModel> productTicketModels) async {
    ClientDeliveryNote clientDeliveryNote = ClientDeliveryNote();
    ProductDeliveryNote productDeliveryNote = ProductDeliveryNote();

    clientDeliveryNote.clientId = client.id;
    clientDeliveryNote.date = DateTime.now();
    List<ClientDeliveryNote> clients = await clientDeliveryNote.selectAll<ClientDeliveryNote>();

    if (clients.isNotEmpty) {
      var lastClient = await clientDeliveryNote.selectLast<ClientDeliveryNote>();
      clientDeliveryNote.number = lastClient.number! + 1;
    } else {
      clientDeliveryNote.number = 1;
    }

    dynamic slaughterhouseName = await Preferences.getValue('slaughterhouse');
    Slaughterhouse slaughterhouse = await DatabaseRepository.getEntityByName(Slaughterhouse(), slaughterhouseName);
    String vehicleRegistrationPreferences = await Preferences.getValue('vehicle_registration');
    List<VehicleRegistration> listVehicleRegistration = await VehicleRegistration().getData<VehicleRegistration>(where: [
      'vehicleRegistrationNum',
      SqlBuilder.constOperators['equals']!,
      "'$vehicleRegistrationPreferences'"
    ]);
    VehicleRegistration vehicleRegistration = listVehicleRegistration.first;

    clientDeliveryNote.series = vehicleRegistration.deliveryTicket;
    clientDeliveryNote.slaughterhouseId = slaughterhouse.id;
    clientDeliveryNote.isSend = false;

    await _insertIfNotExists(clientDeliveryNote);

    // Guardar los datos consolidados sin cálculos adicionales
    for (var product in productTicketModels) {
      productDeliveryNote.idTicket = clientDeliveryNote.id;
      productDeliveryNote.idProduct = product.product!.id;
      productDeliveryNote.idClassification = product.classification!.id;
      productDeliveryNote.nameClassification = product.classification!.name!;
      productDeliveryNote.units = product.numAnimals!;
      productDeliveryNote.kilograms = product.weight!;
      productDeliveryNote.color = product.color;

      productDeliveryNote.insert();
    }

    for (var x in tickets) {
      x.idOut = clientDeliveryNote.id;
      await x.update();
    }
  }

  Future<void> _insertIfNotExists(dynamic entity) async {
    try {
      await entity.insert();
    } catch (e) {
      FileLogger fileLogger = FileLogger();

      fileLogger.handleError(e, file: 'home_bloc.dart');
      if (e.toString().contains('Record already exists')) {
        // Manejar el caso en que el registro ya existe
        print('Registro ya existe: ${entity.runtimeType}');
      } else {
        // Manejar otros errores
        rethrow;
      }
    }
  }

  Future<List<DeliveryTicketModel>> _convertTicketsToModels(List<DeliveryTicket> tickets) async {
    List<DeliveryTicketModel> ticketModels = [];
    for (var ticket in tickets) {
      ticketModels.add(await DeliveryTicketModel().fromEntity(ticket));
    }
    return ticketModels;
  }

  Future<String> _buildEmailBody(List<DeliveryTicketModel> ticketModels, List<ProductTicketModel> productTicketModels, int clientId) async {
    String emailBody = '';

    emailBody += await _buildTicketString(ticketModels.first, clientId);
    emailBody += _buildProductTicketsString(productTicketModels);
    emailBody += '-----------------------------\n';
    return emailBody;
  }

  Future<List<ProductTicketModel>> _getProductTickets(int ticketId) async {
    List<ProductTicket> productTickets = await ProductTicket().getData<ProductTicket>(where: ['idTicket = $ticketId']);
    List<ProductTicketModel> productTicketModels = [];
    for (var x in productTickets) {
      productTicketModels.add(await ProductTicketModel().fromEntity(x));
    }
    return productTicketModels;
  }

  Future<String> _buildTicketString(DeliveryTicketModel ticket, int clientId) async {
    Client client = await DatabaseRepository.getEntityById(Client(), clientId);
    return '-----------------------------\n'
        '           Ticket\n'
        '-----------------------------\n'
        'Serie: ${ticket.deliveryTicket ?? 'N/A'}\n'
        'Numero: ${ticket.number ?? 'N/A'}\n'
        'Fecha: ${ticket.date?.toString() ?? 'N/A'}\n'
        'Conductor: ${ticket.driver?.name ?? 'N/A'}, ${ticket.driver?.nif ?? 'N/A'}\n'
        'Matadero: ${ticket.slaughterhouse?.name ?? 'N/A'}\n'
        'Cliente: ${client.name ?? 'N/A'}\n'
        '-----------------------------\n';
  }

  String _buildProductTicketsString(List<ProductTicketModel> products) {
    // Crear un mapa para almacenar los datos agrupados por producto.
    Map<String, Map<String, List<Map<String, dynamic>>>> groupedData = {};

    for (var e in products) {
      // Obtener el nombre del producto, la clasificación y el rendimiento.
      String productName = e.product!.name!;
      String key = '${e.classification!.name}-${e.performance!.performance}';

      if (!groupedData.containsKey(productName)) {
        // Si el producto no existe en el mapa, se inicializa.
        groupedData[productName] = {};
      }

      if (groupedData[productName]!.containsKey(key)) {
        // Si la clave ya existe, acumular el número de animales y el peso.
        var existing = groupedData[productName]![key]!.first;
        existing['numAnimals'] += e.numAnimals ?? 0;
        existing['weight'] += e.weight ?? 0;
      } else {
        // Si la clave no existe, crear una nueva entrada en la lista del producto.
        groupedData[productName]![key] = [
          {
            'classification': e.classification!.name,
            'performance': e.performance!.performance,
            'numAnimals': e.numAnimals ?? 0,
            'weight': e.weight ?? 0,
          }
        ];
      }
    }

    // Construir la cadena de salida.
    String str = '';
    groupedData.forEach((productName, productEntries) {
      str += '$productName\n';
      str += '   Nº - Clas - Rend - Kg\n';
      productEntries.forEach((key, valueList) {
        for (var value in valueList) {
          str += '   ${value['numAnimals']} - ${value['classification']} - ${value['performance']} - ${value['weight']} Kg\n';
        }
      });
    });

    return str;
  }



  Future<void> _addSelectedTicket(AddSelected event, Emitter<SendState> emit) async {
    if (!tickets.contains(event.selected)) {
      tickets.add(event.selected);
    } else {
      tickets.remove(event.selected);
    }
  }

  Future<void> _selectClient(SelectEmailClient event, Emitter<SendState> emit) async {
    client = await DatabaseRepository.getEntityById(Client(), event.selectedClient);
  }
}
