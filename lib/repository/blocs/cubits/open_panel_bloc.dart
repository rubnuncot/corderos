import 'package:flutter_bloc/flutter_bloc.dart';

class OpenPanelBloc extends Cubit<OpenPanelState> {
  OpenPanelBloc() : super(OpenPanelState());

  void openPanel() {
    emit(OpenPanelState(isOpen: true));
  }

  void closePanel() {
    emit(OpenPanelState(isOpen: false));
  }

  void changeScreen(int screen) {
    emit(OpenPanelState(isOpen: true, screen: screen));
  }
}

class OpenPanelState {
  final bool isOpen;
  final int screen;

  OpenPanelState({this.isOpen = false, this.screen = 0});
}