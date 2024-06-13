part of 'ticket_client_bloc.dart';

abstract class TicketClientState {}

class TicketClientLoading extends TicketClientState {}

class TicketClientError extends TicketClientState {
  final String message;

  TicketClientError(this.message);
}

class TicketClientSuccess extends TicketClientState {
  String message = '';
  List data = [];
  String event = '';

  TicketClientSuccess({required this.message,required this.data,required this.event});

  TicketClientSuccess copyWith(
      {String? message, List? data, String? event, int? selectedTicket}) {
    return TicketClientSuccess(
      message: message ?? this.message,
      data: data ?? this.data,
      event: event ?? this.event,
    );
  }
}