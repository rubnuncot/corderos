part of 'ticket_bloc.dart';

abstract class TicketEvent {}

class FetchTickets extends TicketEvent {
  FetchTickets();
}

class SelectTicket extends TicketEvent {
  final int ticketId;

  SelectTicket({required this.ticketId});
}

class DeleteTicket extends TicketEvent {
  final int ticketId;

  DeleteTicket({required this.ticketId});
}

class GetTicketInfo extends TicketEvent {
  final int ticketId;

  GetTicketInfo({
    required this.ticketId
  });
}