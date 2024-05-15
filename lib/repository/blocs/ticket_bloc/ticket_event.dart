part of 'ticket_bloc.dart';

abstract class TicketEvent {}

class FetchTicketsScreen extends TicketEvent {
  FetchTicketsScreen();
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

class PrintTicketEvent extends TicketEvent {
  final BuildContext context;
  final DeliveryTicket deliveryTicket;

  PrintTicketEvent({
    required this.context,
    required this.deliveryTicket
  });
}