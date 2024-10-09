part of 'home_bloc.dart';

abstract class HomeEvent {}


class GetFtpData extends HomeEvent {
  final DropDownBloc? dropDownBloc;
  final bool isRead;

  GetFtpData({
    this.dropDownBloc,
    this.isRead = false
  });
}

class SendFiles extends HomeEvent {
  final String tableChanged;
  final bool isRead;

  SendFiles({
    this.tableChanged = 'none',
    this.isRead = false
  });
}

class UpdateApp extends HomeEvent {
  final bool isRead;

  UpdateApp({
    this.isRead = false
  });
}

class PrintResume extends HomeEvent {
  final BuildContext context;

  PrintResume({
    required this.context
  });
}

class PrintConnect extends HomeEvent {
  final BuildContext context;
  PrintConnect({
    required this.context
  });
}



