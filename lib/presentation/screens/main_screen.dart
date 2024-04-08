import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../!presentation.dart';
import '../../repository/!repository.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final navigatorState = context.watch<NavigatorBloc>().state;

    return Layout(
      content: navigatorState.screen,
      text: navigatorState.name,
    );
  }
}
