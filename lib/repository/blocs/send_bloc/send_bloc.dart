import 'package:bloc/bloc.dart';
import 'package:corderos_app/repository/!repository.dart';
import 'package:sqflite_simple_dao_backend/database/database/sql_builder.dart';
import '../../../data/!data.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

part 'send_event.dart';
part 'send_state.dart';

class SendBloc extends Bloc<SendEvent, SendState> {
  List<DeliveryTicket> tickets = [];
  Client client = Client();

  SendBloc() : super(SendLoading()) {
    on<SendClientEmail>(_sendClientEmail);
    on<AddSelected>(_addSelectedTicket);
    on<SelectEmailClient>(_selectClient);
  }

  Future<void> _sendClientEmail(SendClientEmail event, Emitter<SendState> emit) async {
    emit(SendLoading());
    try {
      List<DeliveryTicketModel> ticketModels = await _convertTicketsToModels(tickets);
      String emailBody = await _buildEmailBody(ticketModels);

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
      var lastClient = await clientDeliveryNote.selectLast<ClientDeliveryNote>();
      clientDeliveryNote.number = lastClient.number! + 1;
      clientDeliveryNote.isSend = true;
      await clientDeliveryNote.insert();

      for (var ticket in ticketModels) {
        List<ProductTicketModel> productTicketModels = await _getProductTickets(ticket.id!);
        for(var x in productTicketModels){
          productDeliveryNote.idDeliveryNote = clientDeliveryNote.id;
          productDeliveryNote.idProduct = x.product!.id;
          productDeliveryNote.idClassification = x.classification!.id;
          productDeliveryNote.nameClassification = x.classification!.name;
          productDeliveryNote.units = x.numAnimals;
          productDeliveryNote.kilograms = x.weight;
          productDeliveryNote.color = x.color;
        }
        await productDeliveryNote.insert();
      }
      emit(SendSuccess('Correo enviado', [], 'SendEmail'));
    } catch (e) {
      emit(SendError('Error enviando correo'));
    }
  }

  Future<List<DeliveryTicketModel>> _convertTicketsToModels(List<DeliveryTicket> tickets) async {
    List<DeliveryTicketModel> ticketModels = [];
    for (var ticket in tickets) {
      ticketModels.add(await DeliveryTicketModel().fromEntity(ticket));
    }
    return ticketModels;
  }

  Future<String> _buildEmailBody(List<DeliveryTicketModel> ticketModels) async {
    String emailBody = '';
    for (var ticket in ticketModels) {
      List<ProductTicketModel> productTicketModels = await _getProductTickets(ticket.id!);

      emailBody += _buildTicketString(ticket);
      emailBody += _buildProductTicketsString(productTicketModels);
      emailBody += '-----------------------------\n';
    }
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

  String _buildTicketString(DeliveryTicketModel ticket) {
    return '-----------------------------\n'
        '           Ticket\n'
        '-----------------------------\n'
        'Serie: ${ticket.deliveryTicket ?? 'N/A'}\n'
        'Numero: ${ticket.number ?? 'N/A'}\n'
        'Fecha: ${ticket.date?.toString() ?? 'N/A'}\n'
        'Conductor: ${ticket.driver?.name ?? 'N/A'}, NIF: ${ticket.driver?.nif ?? 'N/A'}\n'
        'Matricula: ${ticket.vehicleRegistration?.vehicleRegistrationNum ?? 'N/A'}\n'
        'Matadero: ${ticket.slaughterhouse?.name ?? 'N/A'}\n'
        'Ganadero: ${ticket.rancher?.name ?? 'N/A'}, NIF: ${ticket.rancher?.nif ?? 'N/A'}\n'
        'Producto: ${ticket.product?.name ?? 'N/A'}\n';
  }

  String _buildProductTicketsString(List<ProductTicketModel> productTicketModels) {
    String productTicketsString = '';
    for (var productTicket in productTicketModels) {
      productTicketsString += '-----------------------------\n';
      productTicketsString += 'Animales: ${(productTicket.numAnimals! - (productTicket.losses ?? 0))}\n'
          'Peso: ${productTicket.weight ?? 'N/A'} kg\n'
          'Rendimiento: ${productTicket.performance?.performance ?? 'N/A'}\n'
          'Color: ${productTicket.color ?? 'N/A'}\n';
    }
    return productTicketsString;
  }

  void _addSelectedTicket(AddSelected event, Emitter<SendState> emit) {
    emit(SendLoading());
    try {
      tickets.add(event.selected);
      emit(SendSuccess('Ticket añadido', tickets, 'AddSelected'));
    } catch (e) {
      emit(SendError('Error añadiendo ticket'));
    }
  }

  void _selectClient(SelectEmailClient event, Emitter<SendState> emit) async {
    emit(SendLoading());
    try {
      var clientSelect = await client.getData<Client>(where: ['id', SqlBuilder.constOperators['equals']!, '${event.selectedClient}']);
      client = clientSelect.first;
      emit(SendSuccess('Cliente seleccionado', [], 'SelectClient'));
    } catch (e) {
      emit(SendError('Error seleccionando cliente'));
    }
  }
}
