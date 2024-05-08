import 'package:flutter_bloc/flutter_bloc.dart';

class SearchableDropdownBloc extends Cubit<SearchableDropdownState> {
  SearchableDropdownBloc() : super(SearchableDropdownState());

  void search(String value) {
    List list = state.firstItems
        .where((item) =>
            item.toString().toLowerCase().contains(value.toLowerCase()))
        .toList();

    emit(state.copyWith(items: list));
  }

  void setItems(List items) {
    emit(state.copyWith(items: items, firstItems: items));
  }

  void setHeight({required double screenHeight, double? height = 0}) {
    height = height == 0 ? screenHeight * 0.7 : height;
    emit(state.copyWith(height: height));
  }

  void clear() {
    emit(state.copyWith(items: state.firstItems));
  }

  void closePanel() {
    emit(state.copyWith(height: 0));
  }
}

class SearchableDropdownState {
  List firstItems = [];
  List items = [];
  double height = 0;

  SearchableDropdownState();

  SearchableDropdownState copyWith(
      {List? firstItems, List? items, double? height}) {
    return SearchableDropdownState()
      ..firstItems = firstItems ?? this.firstItems
      ..items = items ?? this.items
      ..height = height ?? this.height;
  }
}
