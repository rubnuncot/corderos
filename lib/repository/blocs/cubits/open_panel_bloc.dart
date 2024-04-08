import 'package:flutter_bloc/flutter_bloc.dart';

class OpenPanelBloc extends Cubit<OpenPanelState> {
  OpenPanelBloc() : super(OpenPanelState());

  void openPanel() {
    emit(OpenPanelState(isOpen: true));
  }

  void closePanel() {
    emit(OpenPanelState(isOpen: false));
  }
}

class OpenPanelState {
  final bool isOpen;

  OpenPanelState({this.isOpen = false});
}