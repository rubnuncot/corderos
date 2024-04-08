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
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Gestión Documental',
      routerConfig: context.read<RouterBloc>().state,
    );
  }
}