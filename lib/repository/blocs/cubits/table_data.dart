import 'package:flutter_bloc/flutter_bloc.dart';

class TableData extends Cubit<TableDataState> {
  TableData() : super(TableDataState());

  void setSelectedData(int? index, String name, String registration) {
    emit(TableDataState(index: index, name: name, registration: registration));
  }
}

class TableDataState {
  final int? index;
  final String name;
  final String registration;

  TableDataState({
    this.index,
    this.name = '',
    this.registration = '',
  });
}
