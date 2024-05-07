part of 'home_bloc.dart';

abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}

class HomeSuccess extends HomeState {
  final String message;
  List data;
  String event;

  HomeSuccess(this.message, this.data, this.event);
}