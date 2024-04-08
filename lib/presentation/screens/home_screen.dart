import 'package:corderos_app/presentation/!presentation.dart';
import 'package:corderos_app/presentation/widgets/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/!repository.dart';

class HomeScreen extends StatelessWidget {
  static const String name = "Inicio";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final openPanel = context.read<OpenPanelBloc>();

    return Stack(
      children: [
        Center(
          child: DefaultButton(
            onPressed: () => openPanel.openPanel(),
          ),
        ),
        Center(
          child: Panel(
            size: MediaQuery.of(context).size,
          ),
        )
      ]
    );
  }
}
