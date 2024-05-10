import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/!data.dart';

part 'client_event.dart';

part 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  ClientBloc() : super(ClientLoading()) {
    List<Client> clients = [];
    List<DeliveryTicket> tickets = [];
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

  }
}
