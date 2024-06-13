import 'package:corderos_app/data/!data.dart';
import 'package:corderos_app/data/database/entities/!!model_dao.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchableDropdownBloc extends Cubit<SearchableDropdownState> {
  SearchableDropdownBloc() : super(SearchableDropdownState());

  void search(String value) {
    RegExp regExp = RegExp(r'[a-zA-Z]');

    if(regExp.hasMatch(value)) {
      List list = state.firstItems
          .where((item) =>
          item.toString().toLowerCase().contains(value.toLowerCase()))
          .toList();

      emit(state.copyWith(items: list));
    } else {
      _searchByCode(value, Rancher());
    }
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

  _searchByCode(String value, dynamic model) async {
    List search = await model.getData(
      where: ["code = '$value'"],
    );

    List<String> names = search.map((e) => e.name as String).toList();
    emit(state.copyWith(items: names));
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
