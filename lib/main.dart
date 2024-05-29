import 'package:corderos_app/repository/!repository.dart';
import 'package:corderos_app/repository/blocs/send_bloc/send_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        BlocProvider(
          create: (context) => DropDownBloc(),
        ),
        BlocProvider(
          create: (context) => DatabaseBloc(),
        ),
        BlocProvider(
          create: (context) => ReportBloc(),
        ),
        BlocProvider(
          create: (context) => HomeBloc(),
        ),
        BlocProvider(
          create: (context) => BurdenBloc(),
        ),
        BlocProvider(
          create: (context) => SearchableDropdownBloc(),
        ),
        BlocProvider(
          create: (context) => ClientBloc(),
        ),
        BlocProvider(
          create: (context) => TicketBloc(),
        ),
        BlocProvider(
          create: (context) => SendBloc(),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  DateTime? _lastPressed;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  Future<bool> didPopRoute() async {
    final now = DateTime.now();
    if (_lastPressed == null || now.difference(_lastPressed!) > const Duration(seconds: 2)) {
      _lastPressed = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Presiona de nuevo para salir'),
          duration: Duration(seconds: 2),
        ),
      );
      return true;
    } else {
      //! 2º Click en menos de 2 segundos
      SystemNavigator.pop(); //! Cierra App
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeBlocState = context.watch<ThemeBloc>().state;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Corderos',
      routerConfig: context.read<RouterBloc>().state,
      theme: themeBlocState.isDarkTheme ? AppTheme.darkTheme : AppTheme.lightTheme,
    );
  }
}
