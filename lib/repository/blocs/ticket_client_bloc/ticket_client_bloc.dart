import 'package:bloc/bloc.dart';
import 'package:corderos_app/data/!data.dart';
import 'package:corderos_app/data/database/entities/!!model_dao.dart';
import 'package:corderos_app/repository/!repository.dart';
import 'package:corderos_app/repository/data_conversion/!data_conversion.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:reflectable/reflectable.dart';
import 'package:sqflite_simple_dao_backend/database/database/sql_builder.dart';
import 'package:sqflite_simple_dao_backend/sqflite_simple_dao_backend.dart';

part 'ticket_client_event.dart';

part 'ticket_client_state.dart';

class TicketClientBloc extends Bloc<TicketClientEvent, TicketClientState> {
  TicketClientBloc() : super(TicketClientLoading()) {
    on<FetchTicketsClientScreen>(_onFetchTicketsScreen);
    on<SelectTicketClient>(_onSelectTicket);
    on<DeleteTicketClient>(_onDeleteTicket);
    on<GetTicketClientInfo>(_onGetTicketInfo);
    on<SendTicket>(_sendTicket);
    on<DeleteAllTicketsClients>(_onDeleteAllTickets);
    on<SetIconTicketClientState>(_onSetIconTicketState);
  }

  Future<void> _onFetchTicketsScreen(
      FetchTicketsClientScreen event, Emitter<TicketClientState> emit) async {
    emit(TicketClientLoading());
    try {
      final tickets = await ClientDeliveryNote().selectAll<ClientDeliveryNote>();

      final List<ClientDeliveryNote> agrTickets = [];
      ClientDeliveryNote ticketAux = ClientDeliveryNote();
      for (var ticket in tickets) {
        if (ticket.clientId != ticketAux.clientId) {
          agrTickets.add(ticket);
          ticketAux = ticket;
        }
      }

      if (agrTickets.isNotEmpty) {
        final List<Client> clients = [];
        final List<Product> products = [];

        for (var ticket in agrTickets) {
          final client = await DatabaseRepository.getEntityById(
            Client(),
            ticket.clientId!,
          );
          clients.add(client);
        }

        emit(TicketClientSuccess(
          message: 'Tickets, rancher y product recibidos con éxito',
          data: [agrTickets, clients, products],
          event: 'FetchTicketsClientScreen',
        ));
      }
    } catch (e) {
      emit(TicketClientError(
        'Ha ocurrido un error a la hora de cargar los tickets: $e',
      ));
    }
  }

  Future<void> _onSelectTicket(
      SelectTicketClient event, Emitter<TicketClientState> emit) async {
    try {
      final selectedClientDeliveryNote =
      await _fetchClientDeliveryNoteById(event.ticketId);
      if (selectedClientDeliveryNote != null) {
        selectedClientDeliveryNote.isSend = !selectedClientDeliveryNote.isSend!;
        await selectedClientDeliveryNote.update();
        emit(TicketClientSuccess(
          message: 'Ticket seleccionado correctamente',
          data: [selectedClientDeliveryNote],
          event: 'SelectTicketClient',
        ));
      } else {
        throw Exception('No ticket found with id ${event.ticketId}');
      }
    } catch (e) {
      emit(TicketClientError(
          'Ha habido un error al seleccionar el ticket: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteTicket(
      DeleteTicketClient event, Emitter<TicketClientState> emit) async {
    try {
      final selectedClientDeliveryNote =
      await _fetchClientDeliveryNoteById(event.ticketId);
      final selectedProductTicket =
      await _fetchProductTicketByTicketId(event.ticketId);
      await selectedClientDeliveryNote?.delete();
      for (var productTicket in selectedProductTicket!) {
        await productTicket.delete();
      }
      emit(TicketClientSuccess(
        message: 'Ticket borrado correctamente',
        data: [selectedClientDeliveryNote],
        event: 'DeleteTicketClient',
      ));
    } catch (e) {
      emit(TicketClientError('Ha habido un error al borrar el ticket'));
    }
  }

  Future<void> _onGetTicketInfo(
      GetTicketClientInfo event, Emitter<TicketClientState> emit) async {
    emit(TicketClientLoading());
    try {
      final clientDeliveryNoteModel =
      await _getClientDeliveryNoteModelById(event.ticketId);
      final productTicketModel =
      await _getProductTicketModelByTicketId(event.ticketId);
      emit(TicketClientSuccess(
        message: 'Tickets de productos obtenidos correctamente',
        data: [productTicketModel, clientDeliveryNoteModel],
        event: "GetTicketClientInfo",
      ));
    } catch (e) {
      emit(
          TicketClientError('Ha ocurrido un error a la hora de obtener los tickets'));
    }
  }

  Future<ClientDeliveryNote?> _fetchClientDeliveryNoteById(int ticketId) async {
    final results = await ClientDeliveryNote().select(
      model: ClientDeliveryNote(),
      sqlBuilder: SqlBuilder()
          .querySelect(fields: ["*"])
          .queryFrom(table: ClientDeliveryNote().getTableName(ClientDeliveryNote()))
          .queryWhere(conditions: [
        'id',
        SqlBuilder.constOperators['equals']!,
        '$ticketId'
      ]),
    );
    return results.isNotEmpty ? results.first as ClientDeliveryNote : null;
  }

  Future<List<ProductDeliveryNote>?> _fetchProductTicketByTicketId(
      int ticketId) async {
    final results = await ProductDeliveryNote().getData<ProductDeliveryNote>(
        where: ['idDeliveryNote', SqlBuilder.constOperators['equals']!, '$ticketId']);
    return results.isNotEmpty ? results : null;
  }

  Future<ClientDeliveryNoteModel> _getClientDeliveryNoteModelById(int ticketId) async {
    final model = ClientDeliveryNoteModel();
    final entity =
    await DatabaseRepository.getEntityById(ClientDeliveryNote(), ticketId);
    await model.fromEntity(entity);
    return model;
  }

  Future<List<ProductDeliveryNoteModel>> _getProductTicketModelByTicketId(
      int ticketId) async {
    final selectedProductTicket = await _fetchProductTicketByTicketId(ticketId);
    List<ProductDeliveryNoteModel> model = [];
    if (selectedProductTicket != null) {
      for (var productTicket in selectedProductTicket) {
        ProductDeliveryNoteModel product = ProductDeliveryNoteModel();
        await product.fromEntity(productTicket);
        model.add(product);
      }
    }
    return model;
  }

  Future<T> _getModelById<T>(ModelDao entity, int id) async {
    final classMirror = reflector.reflectType(T) as ClassMirror;
    final model = classMirror.newInstance('', []) as T;
    final entityData = await DatabaseRepository.getEntityById(entity, id);
    await (model as dynamic).fromEntity(entityData);
    return model;
  }

  Future<void> _sendTicket(
      SendTicket event, Emitter<TicketClientState> emit) async {
    List<ClientDeliveryNote> tickets = await ClientDeliveryNote().selectAll();
    List<ClientDeliveryNoteModel> ticketModels = await _convertTicketsToModels(tickets);
    String emailBody = await _buildEmailBody(ticketModels);

    var email = Email(
      body: emailBody,
      subject: 'Ticket de entrega',
      recipients: [ticketModels[0].client == null ? '' : ticketModels[0].client!.email ?? ''],
    );

    await FlutterEmailSender.send(email);
  }

  Future<String> _buildEmailBody(List<ClientDeliveryNoteModel> ticketModels) async {
    String emailBody = '';
    for (var ticket in ticketModels) {
      List<ProductDeliveryNoteModel> productTicketModels = await _getProductTickets(ticket.idDeliveryNote!);

      emailBody += _buildTicketString(ticket);
      emailBody += _buildProductTicketsString(productTicketModels);
      emailBody += '-----------------------------\n';
    }
    return emailBody;
  }

  Future<List<ProductDeliveryNoteModel>> _getProductTickets(int ticketId) async {
    List<ProductDeliveryNote> productTickets = await ProductDeliveryNote()
        .getData<ProductDeliveryNote>(where: ['idDeliveryNote = $ticketId']);
    List<ProductDeliveryNoteModel> productTicketModels = [];
    for (var x in productTickets) {
      productTicketModels.add(await ProductDeliveryNoteModel().fromEntity(x));
    }
    return productTicketModels;
  }

  String _buildTicketString(ClientDeliveryNoteModel ticket) {
    return '-----------------------------\n'
        '           Ticket\n'
        '-----------------------------\n'
        'Serie: ${ticket.series ?? 'N/A'}\n'
        'Numero: ${ticket.number ?? 'N/A'}\n'
        'Fecha: ${ticket.date?.toString() ?? 'N/A'}\n'
        'Conductor: ${ticket.driver?.name ?? 'N/A'}, NIF: ${ticket.driver?.nif ?? 'N/A'}\n'
        'Matricula: ${ticket.vehicleRegistration ?? 'N/A'}\n'
        'Matadero: ${ticket.slaughterhouse?.name ?? 'N/A'}\n'
        'Cliente: ${ticket.client ?? 'N/A'}, NIF: ${ticket.client?.name ?? 'N/A'}\n'
        'Producto: ${ticket.product?.name ?? 'N/A'}\n';
  }

  String _buildProductTicketsString(List<ProductDeliveryNoteModel> productTicketModels) {
    String productTicketsString = '';
    for (var productTicket in productTicketModels) {
      productTicketsString += '-----------------------------\n';
      productTicketsString += 'Animales: ${(productTicket.units!)}\n'
          'Peso: ${productTicket.kilograms ?? 'N/A'} kg\n'
          'Rendimiento: ${productTicket.nameClassification ?? 'N/A'}\n';
    }
    return productTicketsString;
  }

  Future<List<ClientDeliveryNoteModel>> _convertTicketsToModels(List<ClientDeliveryNote> tickets) async {
    List<ClientDeliveryNoteModel> ticketModels = [];
    for (var ticket in tickets) {
      ticketModels.add(await ClientDeliveryNoteModel().fromEntity(ticket));
    }
    return ticketModels;
  }

  Future<void> _onDeleteAllTickets(
      DeleteAllTicketsClients event, Emitter<TicketClientState> emit) async {
    try {
      final allTickets = await ClientDeliveryNote().selectAll<ClientDeliveryNote>();

      for (var ticket in allTickets) {
        final allProductTickets = await ProductDeliveryNote().getData<ProductTicket>(
            where: [
              'idDeliveryNote',
              SqlBuilder.constOperators['equals']!,
              '${ticket.id}'
            ]);

        ClientDeliveryNote().batchDelete(objectsToDelete: allTickets);
        ProductDeliveryNote().batchDelete(objectsToDelete: allProductTickets);
      }

      emit(TicketClientSuccess(
        message: 'Todos los tickets borrados correctamente',
        data: [],
        event: 'DeleteAllTicketsClients',
      ));
    } catch (e) {
      emit(TicketClientError('Ha habido un error al borrar todos los tickets'));
    }
  }

  Future<void> _onSetIconTicketState(
      SetIconTicketClientState event, Emitter<TicketClientState> emit) async {

    try {
      int clientDeliveryNoteNumber = event.number;
      bool isTicketSend;

      final selectedTicket =  await ClientDeliveryNote().getData<ClientDeliveryNote>(
          where: ['number', SqlBuilder.constOperators['equals']!, '$clientDeliveryNoteNumber']
      );

      if (selectedTicket.isEmpty) {
        isTicketSend = false;
      } else {
        isTicketSend = true;
      }

      emit(TicketClientSuccess(
          message: 'Icono de ticket establecido correctamente',
          data: [isTicketSend],
          event: 'SetIconTicketClientState')
      );
    } catch(e) {
      emit(TicketClientError('Ha habido un error al establecer el estado del icono'));
    }
  }
}
