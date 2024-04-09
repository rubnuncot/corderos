import 'package:corderos_app/presentation/!presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigatorBloc extends Cubit<NavigatorState> {
  NavigatorBloc() : super(NavigatorState());

  void push(Widget screen, int index, name) {
    emit(NavigatorState(screen: screen, index: index, name: name));
  }

  void pop() {
    emit(NavigatorState());
  }
}

class NavigatorState {
  Widget screen;
  final int index;
  final String name;

  NavigatorState({Widget? screen, this.index = 0, this.name = HomeScreen.name})
      : screen = screen ?? HomeScreen();
}

