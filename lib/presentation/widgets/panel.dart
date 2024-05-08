import 'package:corderos_app/presentation/!presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/!repository.dart';

class Panel extends StatelessWidget {
  final Size size;

  const Panel({super.key, @required required this.size});

  @override
  Widget build(BuildContext context) {
    final openPanel = context.read<OpenPanelBloc>();
    final openPanelState = context.watch<OpenPanelBloc>().state;

    final screens = {
      0 : const ClientList(),
    };

    return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        height: openPanelState.isOpen ? size.height * 0.7 : 0,
        width: openPanelState.isOpen ? size.width * 0.95 : 0,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(children: [
          if (openPanelState.isOpen)
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => openPanel.closePanel(),
                ),
                backgroundColor: Colors.transparent,
              ),
              body: screens[openPanelState.screen],
            ),
        ]));
  }
}
