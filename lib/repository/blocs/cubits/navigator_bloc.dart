import 'package:corderos_app/presentation/!presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigatorBloc extends Cubit<NavigatorState> {
  NavigatorBloc() : super(NavigatorState());

  void push(Widget screen, int index, name, int lastIndex, String lastName,
      Widget lastScreen) {
    emit(NavigatorState(
        screen: screen,
        lastIndex: lastIndex,
        index: index,
        name: name,
        lastName: lastName,
        lastScreen: lastScreen));
  }

  void pop() {
    emit(NavigatorState());
  }
}

class NavigatorState {
  Widget screen;
  Widget? lastScreen;
  final String lastName;
  final int index;
  final int lastIndex;
  final String name;

  NavigatorState(
      {this.lastName = HomeScreen.name,
      Widget? lastScreen,
      Widget? screen,
      this.lastIndex = 0,
      this.index = 0,
      this.name = HomeScreen.name})
      : screen = screen ?? const HomeScreen();
}
