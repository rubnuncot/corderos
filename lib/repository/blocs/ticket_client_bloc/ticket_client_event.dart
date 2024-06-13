part of 'ticket_client_bloc.dart';

abstract class TicketClientEvent {}

class FetchTicketsClientScreen extends TicketClientEvent {
  FetchTicketsClientScreen();
}

class SelectTicketClient extends TicketClientEvent {
  final int ticketId;

  SelectTicketClient({required this.ticketId});
}

class DeleteTicketClient extends TicketClientEvent {
  final int ticketId;

  DeleteTicketClient({required this.ticketId});
}

class GetTicketClientInfo extends TicketClientEvent {
  final int ticketId;

  GetTicketClientInfo({
    required this.ticketId
  });
}

class SendTicket extends TicketClientEvent {
  final int ticketId;

  SendTicket({required this.ticketId});
}

class DeleteAllTicketsClients extends TicketClientEvent {

}

class SetIconTicketClientState extends TicketClientEvent {
  final int number;

  SetIconTicketClientState({required this.number});
}