import 'package:bloc/bloc.dart';
import 'package:corderos_app/data/preferences/preferences.dart';

class ThemeBloc extends Cubit {
  ThemeBloc() : super(ThemeBlocState(isDarkTheme: false));

  void changeTheme() {
    final isDarkTheme = !state.isDarkTheme;
    _setPreferencesTheme(isDarkTheme);
    emit(ThemeBlocState(isDarkTheme: isDarkTheme));
  }

  void restoreDefaultTheme() {
    emit(ThemeBlocState(isDarkTheme: false));
  }

  Future<void> preferencesTheme() async {
    final isDarkTheme = await _getPreferencesTheme();
    emit(ThemeBlocState(isDarkTheme: isDarkTheme));
  }

  Future<bool> _getPreferencesTheme() async {
    return await Preferences.getValue('theme') as bool;
  }

  _setPreferencesTheme(isDarkTheme) async {
    await Preferences.setValue('theme', isDarkTheme);
  }
}

class ThemeBlocState {
  bool isDarkTheme = false;

  ThemeBlocState({required this.isDarkTheme});
}
