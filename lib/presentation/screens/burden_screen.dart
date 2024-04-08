import 'package:corderos_app/presentation/!presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

    return Expanded(
      child: Column(
        children: [
          Text("Fecha: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}", style: Theme.of(context).textTheme.titleMedium),
          Text("Conductor 1: Juan Perez", style: Theme.of(context).textTheme.titleMedium),
          Text("Matricula: 1234ABC", style: Theme.of(context).textTheme.titleMedium),
          Text("Matadero: 1234ABC", style: Theme.of(context).textTheme.titleMedium),
          GestureDetector(
              onTap: () => openTable.toggleTable(),
              child: Container(
                width: size.width * 0.7,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Center(child: Text('Ganaderos')),
                    Center(child: openTableState.isOpen ? const Icon(Icons.arrow_drop_down) : const Icon(Icons.arrow_drop_up)),
                  ],
                ),
              )),
          CustomTable(
            isOpen: !openTableState.isOpen,
            items: [for (var i = 1; i <= 10; i++) i],
            selected: 1,
          ),
          if(openTableState.isOpen)
          Container(
            width: size.width * 0.7,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(child: Text('Productos')),
          ),
          CustomTable(
            isOpen: openTableState.isOpen,
            items: [for (var i = 1; i <= 5; i++) i],
            onTap: () => openPanel.openPanel(),
          ),
          Center(
            child: Panel(
              size: MediaQuery.of(context).size,
            ),
          )
        ],
      ),
    );
  }
}
