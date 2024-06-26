part of 'client_bloc.dart';

abstract class ClientEvent {}

class FetchClients extends ClientEvent {
  FetchClients();
}

class SendEmail extends ClientEvent {
  final String email;
  final String subject;
  final String body;

  SendEmail({
    required this.email,
    required this.subject,
    required this.body,
  });
}

class PrintTicket extends ClientEvent {
  final String ticketId;

  PrintTicket({
    required this.ticketId,
  });
}

class SelectClient extends ClientEvent {
  final int clientId;

  SelectClient({
    required this.clientId,
  });
}

class FetchTickets extends ClientEvent {
  FetchTickets();
}

class FetchProductTickets extends ClientEvent {
  final int idTicket;

  FetchProductTickets({required this.idTicket});
}

class SelectSendTicket extends ClientEvent {
  final DeliveryTicket ticket;

  SelectSendTicket({required this.ticket});
}

class FetchTicketsEmail extends ClientEvent {
  FetchTicketsEmail();
}
