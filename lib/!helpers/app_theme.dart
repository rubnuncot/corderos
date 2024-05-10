import 'package:flutter/material.dart';

class AppTheme {
  // Tema claro
  static final ThemeData lightTheme = ThemeData.light().copyWith(
      colorScheme: const ColorScheme.light(
          primary: Color(0xFF5E56E7),
          // Violeta suave
          onPrimary: Color(0xFFEEEEEF),
          // Contraste para texto/iconos sobre el primario
          secondary: Color(0xff33b46c),
          // Verde menta
          onSecondary: Colors.white,
          // Contraste para texto/iconos sobre el secundario
          surface: Color(0xFFDBDBE1),
          // Fondo general claro
          onSurface: Color(0xff398357),
          // Texto general sobre fondo claro
          error: Color(0xffb0eeaa),
          // Rojo error
          onError: Colors.black,
          // Contraste para texto/iconos sobre el error
          inversePrimary: Color(0xff3f3c3c),
          // Color primario inverso para ciertos controles
          onTertiary: Colors.black,
          shadow: Colors.black),
      scaffoldBackgroundColor: const Color(0xFFF0F0F6),
      cardColor: const Color(0xFFFFFFFF),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Color(0xFF333333)),
        bodySmall: TextStyle(color: Color(0xFF333333)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xff67af8a),
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        fillColor: Colors.white,
        filled: true,
        hintStyle: TextStyle(color: Color(0xFF333333)),
      ));

  // Tema oscuro
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
      colorScheme: const ColorScheme.dark(
          primary: Color(0xffbb86fc),
          // Violeta
          onPrimary: Color(0xFF232222),
          // Contraste para texto/iconos sobre el primario
          secondary: Color(0xff03dac6),
          // Verde menta
          onSecondary: Colors.black,
          // Contraste para texto/iconos sobre el secundario
          surface: Color(0xFF232222),
          // Fondo general oscuro
          onSurface: Color(0xff03dac6),
          // Texto general sobre fondo oscuro
          error: Color(0xff99e7df),
          // Rojo error
          onError: Colors.white,
          // Contraste para texto/iconos sobre el error
          inversePrimary: Colors.white70,
          // Color primario inverso para ciertos controles
          onTertiary: Colors.white,
          // Color

          shadow: Colors.black),
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
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xc2059a8e),
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        fillColor: Color(0xFF232222),
        filled: true,
        hintStyle: TextStyle(color: Color(0xFF333333)),
      ));
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
      'background': Theme.of(context).colorScheme.surface,
      'bottomBarIconColor': Theme.of(context).colorScheme.inversePrimary,
      'bottomBarBackgroundColor': Theme.of(context).colorScheme.surface,
      'appBarTitle': Theme.of(context).colorScheme.inversePrimary,
      'selectedItemColor': Theme.of(context).colorScheme.secondary,
      'unselectedItemColor': Theme.of(context).colorScheme.inversePrimary,
      'buttonBackgroundColor': Theme.of(context).colorScheme.secondary,
      'textButtonColor': Theme.of(context).colorScheme.surface,
      'labelInputColor': Theme.of(context).colorScheme.onSurface,
      'hintInputColor': Theme.of(context).colorScheme.inversePrimary,
      'iconInputColor': Theme.of(context).colorScheme.onSurface,
      'buttonShadowInput':
          Theme.of(context).colorScheme.inversePrimary.withOpacity(0.2),
      'secondShadowDarkMode': Theme.of(context).colorScheme.onSecondary,
      'themeButtonColor': Theme.of(context).colorScheme.surface,
      'textFieldBackgroundColor': Theme.of(context).colorScheme.surface,
      'buttonBorderColor': Theme.of(context).colorScheme.surface,
      'buttonBackgroundNeuColor': Theme.of(context).colorScheme.onPrimary,
      'buttonBackgroundNeuGradientColor':
          Theme.of(context).colorScheme.secondary,
      'buttonBackgroundNeuGradientSecondColor':
          Theme.of(context).colorScheme.error,
      'buttonNavigationBackground': Theme.of(context).colorScheme.surface,
      //! COLORES TABLA
      'borderTableColor': Theme.of(context).colorScheme.shadow,
      'headBoardTableColor': Theme.of(context).colorScheme.error, //ok
      'titleTableColor': Theme.of(context).colorScheme.onSurface,
      'backgroundValueColor': Theme.of(context).colorScheme.onPrimary, //ok
      'valueTableColor': Theme.of(context).colorScheme.onTertiary,
      //! COLORES DIALOG TABLA
      'dialogTitleColor': Theme.of(context).colorScheme.onSurface,
      'dialogHintColor': Theme.of(context).colorScheme.onError,
      'updateDialogButtonColor': Theme.of(context).colorScheme.onSurface,
      //! COLORES REPORT SCREEN
      'headerBackgroundColor': Theme.of(context).colorScheme.secondary,
      'fontHeaderColor': Theme.of(context).colorScheme.onSecondary,
      'fontCardColor': Theme.of(context).colorScheme.secondary,
      'iconCardColor': Theme.of(context).colorScheme.secondary,
      //! COLORES TICKET SCREEN
      'backgroundCard': Theme.of(context).scaffoldBackgroundColor
    });
    return colors;
  }
}
