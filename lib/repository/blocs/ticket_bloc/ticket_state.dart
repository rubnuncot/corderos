part of 'ticket_bloc.dart';

abstract class TicketState {}

class TicketLoading extends TicketState {}

class TicketError extends TicketState {
  final String message;

  TicketError(this.message);
}

class TicketSuccess extends TicketState {
  final String message;
  List<List> data;
  String event;

  TicketSuccess(this.message, this.data, this.event);
}