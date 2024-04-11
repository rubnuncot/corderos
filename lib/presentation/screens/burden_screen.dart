import 'package:corderos_app/presentation/!presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/!repository.dart';

class BurdenScreen extends StatelessWidget {
  static const String name = "Carga";

  const BurdenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final openTable = context.read<OpenTable>();
    final openTableState = context.watch<OpenTable>().state;
    final openPanel = context.read<OpenPanelBloc>();
    final size = MediaQuery.of(context).size;

    return const Center(
      child: Text('BurdenScreen')
    );
  }
}
