import 'package:flutter_bloc/flutter_bloc.dart';

class OpenTable extends Cubit<TableState> {
  OpenTable() : super(TableState());

  void openTable() {
    emit(TableState(isOpen: true));
  }

  void closeTable() {
    emit(TableState(isOpen: false));
  }

  void toggleTable() {
    emit(TableState(isOpen: !state.isOpen));
  }
}

class TableState {
  final bool isOpen;

  TableState({this.isOpen = false});
}