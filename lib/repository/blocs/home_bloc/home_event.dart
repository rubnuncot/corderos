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





