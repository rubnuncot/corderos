import 'package:corderos_app/repository/!repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/preferences/preferences.dart';
import 'main.reflectable.dart';

import '!helpers/!helpers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseConfig();
  initializeReflectable();
  await Preferences.init();
  runApp(const BlocsProviders());
}

class BlocsProviders extends StatelessWidget {
  const BlocsProviders({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RouterBloc(),
        ),
        BlocProvider(
          create: (context) => NavigatorBloc(),
        ),
        BlocProvider(
          create: (context) => OpenPanelBloc(),
        ),
        BlocProvider(
          create: (context) => OpenTable(),
        ),
        BlocProvider(
          create: (context) => ThemeBloc(),
        ),
      ],
      child: const MyApp(),
    );
  }
}

//Cuando entre en la app, tiene que leer de las preferencias el tema
//y aplicarlo.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final themeBloc = context.read<ThemeBloc>();
    final themeBlocState = context.watch<ThemeBloc>().state;

    return FutureBuilder(
        future: themeBloc.preferencesTheme(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Corderos',
              theme: themeBlocState.isDarkTheme
                  ? AppTheme.darkTheme
                  : AppTheme.lightTheme,
            );
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }
}
