import 'package:flutter/material.dart';

class AppTheme {
  // Tema claro
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF5E56E7), // Violeta suave
      onPrimary: Colors.white, // Contraste para texto/iconos sobre el primario
      secondary: Color(0xFF03dac6), // Verde menta
      onSecondary: Colors.black, // Contraste para texto/iconos sobre el secundario
      surface: Color(0xFFF0F0F6), // Fondo general claro
      onSurface: Color(0xFF333333), // Texto general sobre fondo claro
      error: Color(0xffcf6679), // Rojo error
      onError: Colors.black, // Contraste para texto/iconos sobre el error
    ),
    scaffoldBackgroundColor: const Color(0xFFF0F0F6),
    cardColor: const Color(0xFFFFFFFF),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Color(0xFF333333)),
      bodySmall: TextStyle(color: Color(0xFF333333)),
    ),
  );

  // Tema oscuro
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xffbb86fc), // Violeta
      onPrimary: Colors.black, // Contraste para texto/iconos sobre el primario
      secondary: Color(0xff03dac6), // Verde menta
      onSecondary: Colors.black, // Contraste para texto/iconos sobre el secundario
      surface: Color(0xFF232222), // Fondo general oscuro
      onSurface: Colors.white, // Texto general sobre fondo oscuro
      error: Color(0xffcf6679), // Rojo error
      onError: Colors.black, // Contraste para texto/iconos sobre el error
      inversePrimary: Colors.white70, // Color primario inverso para ciertos controles
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: Color(0xFFA68AF5),
      unselectedItemColor: Colors.white70,
    ),
    scaffoldBackgroundColor: const Color(0xFF2D2D2D),
    cardColor: const Color(0xFF1E1E1E),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Color(0xFFE0E0E0)),
      bodySmall: TextStyle(color: Color(0xFFE0E0E0)),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF232222),
    )
  );
}


class AppColors {
  final BuildContext context;
  Map<String, dynamic>? colors;

  AppColors({@required required this.context});

  Map<String, dynamic>? getColors() {
    colors = {};
    colors!.addAll({
      'primary': Theme.of(context).colorScheme.primary,
      'secondary': Theme.of(context).colorScheme.secondary,
      'bottomBarIconColor': Theme.of(context).colorScheme.inversePrimary,
      'bottomBarBackgroundColor': Theme.of(context).colorScheme.surface,
      'appBarTitle': Theme.of(context).colorScheme.secondary,
    });
    return colors;
  }
}
