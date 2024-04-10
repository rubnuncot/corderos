import 'package:bloc/bloc.dart';

class ThemeBloc extends Cubit {
  ThemeBloc() : super(ThemeBlocState(isDarkTheme: false));

  void changeTheme() {
    final isDarkTheme = !state.isDarkTheme;
    emit(ThemeBlocState(isDarkTheme: isDarkTheme));
  }

  void restoreDefaultTheme() {
    emit(ThemeBlocState(isDarkTheme: false));
  }
}

class ThemeBlocState {
  bool isDarkTheme = false;

  ThemeBlocState({required this.isDarkTheme});
}
