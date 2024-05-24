part of 'send_bloc.dart';

abstract class SendState {}

class SendLoading extends SendState {}

class SendError extends SendState {
  final String message;

  SendError(this.message);
}

class SendSuccess extends SendState {
  final String message;
  List data;
  String event;

  SendSuccess(this.message, this.data, this.event);
}