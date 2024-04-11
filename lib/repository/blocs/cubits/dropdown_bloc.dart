import 'package:bloc/bloc.dart';
import 'package:corderos_app/data/preferences/preferences.dart';
import 'package:meta/meta.dart';

class DropDownBloc extends Cubit<DropDownState> {
  DropDownBloc() : super(DropDownState());
  Map<int, List<String>> values = {
    1: ['Item 1', 'Item 2', 'Item 3'],
    2: ['Item 4', 'Item 5', 'Item 6'],
  };

  Map<int, String> preferencesKeys = {
    1: 'vehicle_registration',
    2: 'name',
  };

  Future<void> changeValue(int index, String value) async {
    if (values.containsKey(index) && values[index]!.contains(value)) {
      emit(state.copyWith(index: index, value: value));
      await Preferences.setValue(preferencesKeys[index]!, value);
    }
  }

  Future<void> getPreferenceValue() async {
    for (var entry in preferencesKeys.entries) {
      final value = await Preferences.getValue(entry.value);
      if (values[entry.key]!.contains(value)) {
        emit(state.copyWith(index: entry.key, value: value));
      }
    }
  }

  void reset() {
    emit(DropDownState());
  }
}

class DropDownState {
  String value = '';
  int index = 0;

  DropDownState();

  DropDownState.all(this.index, {@required required this.value});

  DropDownState copyWith({String? value, int? index}) {
    return DropDownState.all(index ?? 0, value: value ?? this.value);
  }
}
