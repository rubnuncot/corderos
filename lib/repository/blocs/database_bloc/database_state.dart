part of 'database_bloc.dart';


abstract class DatabaseState {}

class DatabaseLoading extends DatabaseState {

}

class DatabaseConnectionError extends DatabaseState {
  final String message;

  DatabaseConnectionError(this.message);
}

class DatabaseError extends DatabaseState {
  final String message;

  DatabaseError(this.message);
}

class DatabaseSuccess extends DatabaseState {
  final String message;
  List<List> data;

  DatabaseSuccess(this.message, this.data);
}