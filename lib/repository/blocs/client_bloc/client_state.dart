part of 'client_bloc.dart';

abstract class ClientState {}

class ClientLoading extends ClientState {}

class ClientSuccess extends ClientState {
  String message = '';
  List data = [];
  String event = '';
  int selectedClient = 0;
  final List<DeliveryTicket>? selectedTickets;

  ClientSuccess(
      {required this.message,
      required this.data,
      required this.event,
      this.selectedClient = 0,
        this.selectedTickets,});

  ClientSuccess copyWith(
      {String? message, List? data, String? event, int? selectedClient}) {
    return ClientSuccess(
        message: message ?? this.message,
        data: data ?? this.data,
        event: event ?? this.event,
        selectedClient: selectedClient ?? this.selectedClient,
        selectedTickets: selectedTickets ?? this.selectedTickets
    );
  }
}

class ClientError extends ClientState {
  final String message;

  ClientError(this.message);
}
