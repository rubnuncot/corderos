
part of 'burden_bloc.dart';

abstract class BurdenState {}

class BurdenLoading extends BurdenState {}

class BurdenError extends BurdenState {
  final String message;

  BurdenError(this.message);
}

class BurdenSuccess extends BurdenState {
  final String message;
  List<List> data;
  String event;

  BurdenSuccess(this.message, this.data, this.event);
}