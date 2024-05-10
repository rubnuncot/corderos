import 'dart:async';

import 'package:corderos_app/repository/!repository.dart';
import 'package:corderos_app/repository/blocs/!blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/!data.dart';

class TicketList extends StatefulWidget {
  const TicketList({super.key});

  @override
  State<TicketList> createState() => _TicketListState();
}

class _TicketListState extends State<TicketList> {
  Icon icon = const Icon(FontAwesomeIcons.cloudArrowUp);

  ClientBloc? clientBloc;
  StreamSubscription? clientSubscription;

  List<DeliveryTicket> tickets = [];

  @override
  void initState() {
    super.initState();
    clientBloc = BlocProvider.of<ClientBloc>(context);
    clientBloc!.add(FetchTickets());

    clientSubscription = clientBloc!.stream.listen((state) {
      if (state is ClientSuccess) {
        switch (state.event) {
          case 'FetchTickets':
            setState(() {
              tickets = state.data as List<DeliveryTicket>;
            });
            break;
          case 'SelectClient':
            print('Cliente seleccionado: ${state.selectedClient}');
            break;
          default:
            print('Event not recognized');
        }
      }
    });
  }

  @override
  void dispose() {
    clientSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text('${tickets.isEmpty ? "Lista vacía!" : tickets[index].number!}'),
              subtitle: Text('Description $index'),
              trailing: IconButton(
                icon: icon,
                onPressed: () {
                  setState(() {
                    icon = const Icon(FontAwesomeIcons.check);
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
