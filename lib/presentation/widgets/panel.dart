import 'package:corderos_app/presentation/!presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../!helpers/app_theme.dart';
import '../../repository/!repository.dart';
import '../../repository/blocs/send_bloc/send_bloc.dart';

class Panel extends StatelessWidget {
  final Size size;

  const Panel({super.key, @required required this.size});

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors(context: context).getColors();
    final openPanel = context.read<OpenPanelBloc>();
    final openPanelState = context.watch<OpenPanelBloc>().state;
    final sendBloc = context.read<SendBloc>();

    final screens = {
      0 : const ClientList(),
      1 : const TicketList(),
    };

    return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        height: openPanelState.isOpen ? size.height * 0.7 : 0,
        width: openPanelState.isOpen ? size.width * 0.95 : 0,
        decoration: BoxDecoration(
          color: appColors!['backgroundPanel'],
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
                title: Text(
                  sendBloc.client.name != null
                      ? sendBloc.client.name!
                      : 'Seleccionar cliente',
                  style: TextStyle(color: appColors['dialogTitleColorPanel']!),
                ),
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
