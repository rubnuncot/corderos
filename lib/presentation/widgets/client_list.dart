import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../data/!data.dart';
import '../../repository/!repository.dart';

class ClientList extends StatefulWidget {
  const ClientList({super.key});

  @override
  State<ClientList> createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> {
  ClientBloc? clientBloc;
  StreamSubscription? clientSubscription;

  List<Client> clients = [];

  @override
  void initState() {
    clientBloc = BlocProvider.of<ClientBloc>(context);
    clientBloc!.add(FetchClients());

    clientSubscription = clientBloc!.stream.listen((state) {
      if (state is ClientSuccess) {
        switch (state.event) {
          case 'FetchClients':
            setState(() {
              clients = state.data as List<Client>;
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
    super.initState();
  }


  @override
  void dispose() {
    clientSubscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: clients.length,
          itemBuilder: (context, index) {
            return ZoomTapAnimation(
              onTap: () {
                clientBloc!.add(SelectClient(clientId: clients[index].id!));
              },
              child: Card(
                child: ListTile(
                  title: Text(clients[index].name!),
                  subtitle: Text('Dirección: ${clients[index].email!}'),
                ),
              ),
            );
          },
        ));
  }
}
