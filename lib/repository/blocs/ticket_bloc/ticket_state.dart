part of 'ticket_bloc.dart';

abstract class TicketState {}

class TicketLoading extends TicketState {}

class TicketError extends TicketState {
  final String message;

  TicketError(this.message);
}

class TicketSuccess extends TicketState {
  String message = '';
  List data = [];
  String event = '';

  TicketSuccess({required this.message,required this.data,required this.event});

  TicketSuccess copyWith(
      {String? message, List? data, String? event, int? selectedTicket}) {
    return TicketSuccess(
        message: message ?? this.message,
        data: data ?? this.data,
        event: event ?? this.event,
    );
  }
}