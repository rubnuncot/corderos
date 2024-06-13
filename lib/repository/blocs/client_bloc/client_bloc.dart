import 'package:corderos_app/!helpers/!helpers.dart';
import 'package:corderos_app/repository/!repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_simple_dao_backend/database/database/sql_builder.dart';

import '../../../data/!data.dart';
import '../../data_conversion/database_repository.dart';

part 'client_event.dart';
part 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  List<Client> clients = [];
  List<DeliveryTicket> tickets = [];
  List<DeliveryTicket> selectedTickets = [];

  ClientBloc() : super(ClientLoading()) {
    on<FetchClients>(_onFetchClients);
    on<SelectClient>(_onSelectClient);
    on<FetchTickets>(_onFetchTickets);
    on<FetchProductTickets>(_onFetchProductTickets);
    on<SelectSendTicket>(_onSelectSendTicket);
    on<FetchTicketsEmail>(_onFetchTicketsEmail);
  }

  Future<void> _onFetchClients(FetchClients event, Emitter<ClientState> emit) async {
    emit(ClientLoading());
    try {
      clients = await Client().selectAll<Client>();
      emit(ClientSuccess(
          message: 'Clientes recibidos con éxito',
          data: clients,
          event: 'FetchClients'));
    } catch (e) {
      emit(ClientError(
          'Ha ocurrido un error a la hora de cargar los clientes.'));
    }
  }

  void _onSelectClient(SelectClient event, Emitter<ClientState> emit) {
    emit(ClientSuccess(
        message: 'Cliente seleccionado con éxito',
        data: clients,
        event: 'SelectClient',
        selectedClient: event.clientId));
  }

  Future<void> _onFetchTickets(FetchTickets event, Emitter<ClientState> emit) async {
    emit(ClientLoading());
    try {
      tickets = await DeliveryTicket().selectAll<DeliveryTicket>();
      emit(ClientSuccess(
          message: 'Tickets recibidos con éxito',
          data: tickets,
          event: 'FetchTickets'));
    } catch (e) {
      emit(ClientError(
          'Ha ocurrido un error a la hora de cargar los tickets.'));
    }
  }

  Future<void> _onFetchProductTickets(FetchProductTickets event, Emitter<ClientState> emit) async {
    emit(ClientLoading());
    try {
      final selectedTicket = event.idTicket;
      final deliveryTicketModel = await _fetchDeliveryTicketModel(selectedTicket);
      final productsTicketModel = await _fetchProductsTicketModel(selectedTicket);

      emit(ClientSuccess(
          message: 'Product Tickets obtenidos con éxito',
          data: [productsTicketModel, deliveryTicketModel],
          event: 'FetchProductTickets'));
    } catch (e) {
      emit(ClientError(
          'Ha ocurrido un error al intentar traer los products tickets'));
    }
  }

  Future<DeliveryTicketModel> _fetchDeliveryTicketModel(int ticketId) async {
    final deliveryTicketModel = DeliveryTicketModel();
    await deliveryTicketModel.fromEntity(
        await DatabaseRepository.getEntityById(DeliveryTicket(), ticketId));
    return deliveryTicketModel;
  }

  Future<List<ProductTicketModel>> _fetchProductsTicketModel(int ticketId) async {
    final productsTickets = await ProductTicket().getData<ProductTicket>(
      where: ['idTicket', SqlBuilder.constOperators['equals']!, '$ticketId'],
    );

    final productsTicketModel = <ProductTicketModel>[];
    for (var product in productsTickets) {
      final productTicketModel = ProductTicketModel();
      await productTicketModel.fromEntity(product);
      productsTicketModel.add(productTicketModel);
    }
    return productsTicketModel;
  }

  void _onSelectSendTicket(SelectSendTicket event, Emitter<ClientState> emit) {
    if (selectedTickets.contains(event.ticket)) {
      selectedTickets.remove(event.ticket);
      LogHelper.logger.d("Ticket eliminado: ${event.ticket}, Total: ${selectedTickets.length}");
    } else {
      selectedTickets.add(event.ticket);
      LogHelper.logger.d("Ticket añadido: ${selectedTickets.last}, Total: ${selectedTickets.length}");
    }

    emit(ClientSuccess(
        message: 'Ticket seleccionado con éxito',
        data: tickets,
        event: 'SelectSendTicket',
        selectedTickets: selectedTickets));
  }

  Future<void> _onFetchTicketsEmail(FetchTicketsEmail event, Emitter<ClientState> emit) async {
    emit(ClientLoading());
    try {
      final tickets = await DeliveryTicket().selectAll<DeliveryTicket>();
      final deliveryNotes = await ClientDeliveryNote().selectAll<ClientDeliveryNote>();
      _getSelectedTickets(tickets, deliveryNotes);

      emit(ClientSuccess(
          message: 'Tickets recibidos con éxito',
          data: tickets,
          event: 'FetchTicketsEmail'));
    } catch (e) {
      emit(ClientError(
          'Ha ocurrido un error a la hora de cargar los tickets.'));
    }
  }

  void _getSelectedTickets(List<DeliveryTicket> tickets, List<ClientDeliveryNote> deliveryNotes) {
    for (var ticket in tickets) {
      for (var deliveryNote in deliveryNotes) {
        if (ticket.idOut == deliveryNote.id) {
          tickets.removeWhere((element) => element.id == ticket.id);
        }
      }
    }
  }
}
