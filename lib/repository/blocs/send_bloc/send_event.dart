part of 'send_bloc.dart';

abstract class SendEvent {}

class Initialize extends SendEvent {
  List<DeliveryTicket> tickets;

  Initialize(this.tickets);
}

class SendClientEmail extends SendEvent {
  final BuildContext context;

  SendClientEmail(this.context);
}

class AddSelected extends SendEvent {
  final DeliveryTicket selected;

  AddSelected(this.selected);
}

class SelectEmailClient extends SendEvent {
  final int selectedClient;

  SelectEmailClient(this.selectedClient);
}

