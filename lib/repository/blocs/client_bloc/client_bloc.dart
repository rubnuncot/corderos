import 'package:corderos_app/!helpers/!helpers.dart';
import 'package:corderos_app/data/database/entities/!!model_dao.dart';
import 'package:corderos_app/repository/!repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_simple_dao_backend/database/database/sql_builder.dart';

import '../../../data/!data.dart';
import '../../data_conversion/database_repository.dart';

part 'client_event.dart';

part 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  ClientBloc() : super(ClientLoading()) {
    List<Client> clients = [];
    List<DeliveryTicket> tickets = [];
    List<DeliveryTicket> selectedTickets = [];

    on<FetchClients>((event, emit) async {
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
    });

    on<SelectClient>((event, emit) {
      emit(ClientSuccess(
          message: 'Cliente seleccionado con éxito',
          data: clients,
          event: 'SelectClient',
          selectedClient: event.clientId));
    });

    on<FetchTickets>((event, emit) async {
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
    });

    //! EDITAR PARA VARIOS PRODUCTOS
    on<FetchProductTickets>((event, emit) async {
      emit(ClientLoading());
      try {
        int selectedTicket = event.idTicket;
        List<ProductTicket> productsTickets = [];
        List<ProductTicketModel> productsTicketModel = [];
        DeliveryTicketModel deliveryTicketModel = DeliveryTicketModel();

        await deliveryTicketModel.fromEntity(
            await DatabaseRepository.getEntityById(
                DeliveryTicket(), event.idTicket));

        productsTickets = (await ProductTicket().getData<ProductTicket>(
          where: [
            'idTicket',
            SqlBuilder.constOperators['equals']!,
            '$selectedTicket'
          ],
        ));

        for (var product in productsTickets) {
          ProductTicketModel productTicketModel = ProductTicketModel();
          await productTicketModel.fromEntity(product);
          productsTicketModel.add(productTicketModel);
        }

        emit(ClientSuccess(
            message: 'Product Tickets obtenidos con éxito',
            data: [productsTicketModel, deliveryTicketModel],
            event: 'FetchProductTickets'));
      } catch (e) {
        emit(ClientError(
            'Ha ocurrido un error al intentar traer los products tickets'));
      }
    });

    //! EDITAR PARA VARIOS PRODUCTOS
    on<SelectSendTicket>((event, emit) {
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
    });
  }
}
