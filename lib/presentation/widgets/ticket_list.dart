import 'dart:async';

import 'package:corderos_app/repository/!repository.dart';
import 'package:corderos_app/repository/blocs/!blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../!helpers/log_helper.dart';
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
  List<double>? newSize = [];
  List<bool>? isOpen = [];

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
              newSize = List.generate(tickets.length,
                  (index) => MediaQuery.of(context).size.height * 0.07);
              isOpen = List.generate(tickets.length, (index) => false);
            });
            break;
          case 'SelectClient':
            break;
          default:
            LogHelper.logger.d('Evento no reconocido');
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
    if (newSize!.isNotEmpty) {
      newSize = newSize!
          .map((e) => e = MediaQuery.of(context).size.height * 0.07)
          .toList();
    }
    return Container(
      padding: const EdgeInsets.all(8),
      child: ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          return Card(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: newSize![index],
              curve: Curves.elasticOut,
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 50,
                ),
                child: ListTile(
                  onTap: () {
                    setState(() {
                      newSize![index] = isOpen![index]
                          ? MediaQuery.of(context).size.height * 0.07
                          : MediaQuery.of(context).size.height * 0.4;
                      isOpen![index] = !isOpen![index];
                    });
                  },
                  title: Text(
                      '${tickets.isEmpty ? "Lista vacía!" : tickets[index].number!}'),
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
              ),
            ),
          );
        },
      ),
    );
  }
}
