part of 'send_bloc.dart';

abstract class SendEvent {}

class SendClientEmail extends SendEvent {
}

class AddSelected extends SendEvent {
  final DeliveryTicket selected;

  AddSelected(this.selected);
}

class SelectEmailClient extends SendEvent {
  final int selectedClient;

  SelectEmailClient(this.selectedClient);
}

