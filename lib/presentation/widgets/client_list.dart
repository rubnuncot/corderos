import 'dart:async';

import 'package:corderos_app/repository/blocs/send_bloc/send_bloc.dart';
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
  SendBloc? sendBloc;
  StreamSubscription? clientSubscription;

  List<Client> clients = [];
  List<Client> filteredClients = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    clientBloc = BlocProvider.of<ClientBloc>(context);
    sendBloc = BlocProvider.of<SendBloc>(context);
    clientBloc!.add(FetchClients());

    clientSubscription = clientBloc!.stream.listen((state) {
      if (state is ClientSuccess) {
        switch (state.event) {
          case 'FetchClients':
            setState(() {
              clients = state.data as List<Client>;
              filteredClients = clients;
            });
            break;
          case 'SelectClient':
            sendBloc!.add(SelectEmailClient(state.selectedClient));
            print('Cliente seleccionado: ${state.selectedClient}');
            break;
          default:
            print('Event not recognized');
        }
      }
    });

    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    clientSubscription!.cancel();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredClients = clients.where((client) {
        return client.name!.toLowerCase().contains(query) ||
            client.email!.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final openPanel = context.read<OpenPanelBloc>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Buscar cliente',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              )
                  : null,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredClients.length,
            itemBuilder: (context, index) {
              return ZoomTapAnimation(
                onTap: () {
                  clientBloc!.add(SelectClient(clientId: filteredClients[index].id!));
                  openPanel.changeScreen(1);
                },
                child: Card(
                  child: ListTile(
                    title: Text(filteredClients[index].name!),
                    subtitle: Text('Email: ${filteredClients[index].email!}'),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
