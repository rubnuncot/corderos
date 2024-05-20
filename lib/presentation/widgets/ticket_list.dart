import 'dart:async';
import 'package:corderos_app/repository/!repository.dart';
import 'package:corderos_app/repository/blocs/!blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../!helpers/app_theme.dart';
import '../../!helpers/log_helper.dart';
import '../../data/!data.dart';

class TicketList extends StatefulWidget {
  const TicketList({super.key});

  @override
  State<TicketList> createState() => _TicketListState();
}

class _TicketListState extends State<TicketList> with TickerProviderStateMixin {
  ClientBloc? clientBloc;
  StreamSubscription? clientSubscription;
  List<bool> isOpen = [];
  Map<int, ProductTicketModel> productTicketModels = {};
  Map<int, DeliveryTicketModel> deliveryTicketModels = {};
  List<DeliveryTicket> tickets = [];
  List<DeliveryTicket> selectedTickets = [];

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
              isOpen = List.generate(tickets.length, (index) => false);
            });
            _fetchProductTickets();
            break;
          case 'FetchProductTickets':
            final ticketId = state.data[0].id;
            setState(() {
              productTicketModels[ticketId] = state.data[0];
              deliveryTicketModels[ticketId] = state.data[1];
            });
            break;
          case 'SelectSendTicket':
            setState(() {
              selectedTickets = state.selectedTickets!;
            });
            break;
          default:
            LogHelper.logger.d('Evento no reconocido');
        }
      }
    });
  }

  void _fetchProductTickets() {
    for (var ticket in tickets) {
      clientBloc!.add(FetchProductTickets(idTicket: ticket.id!));
    }
  }

  void _toggleSelection(DeliveryTicket ticket) {
    clientBloc!.add(SelectSendTicket(ticket: ticket));
  }

  @override
  void dispose() {
    clientSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors(context: context).getColors();

    return Container(
      padding: const EdgeInsets.all(8),
      child: ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          final productTicketModel = productTicketModels[ticket.id];
          final deliveryTicketModel = deliveryTicketModels[ticket.id];
          final isSelected = selectedTickets.contains(ticket);

          return Card(
            color: isSelected ? appColors!['selectedBackgroundCard'] : null,
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    '${ticket.number!}',
                    style: TextStyle(
                        color: isSelected ? appColors!['selectedTitleCard'] : appColors!['unSelectedTitleCard']),
                  ),
                  subtitle: Text('Description $index',
                    style: TextStyle(color: isSelected ? appColors['selectedTitleCard'] : appColors['unSelectedTitleCard']),
                  ),
                  trailing: IconButton(
                    icon: isOpen[index]
                        ? Icon(FontAwesomeIcons.chevronUp, color: isSelected ? appColors['selectedIconCard'] : appColors['unSelectedIconCard'])
                        : Icon(FontAwesomeIcons.chevronDown, color: isSelected ? appColors['selectedIconCard'] : appColors['unSelectedIconCard']),
                    onPressed: () {
                      setState(() {
                        isOpen[index] = !isOpen[index];
                      });
                    },
                  ),
                  onTap: () {
                    _toggleSelection(ticket);
                  },
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.elasticOut,
                  child: isOpen[index] &&
                          productTicketModel != null &&
                          deliveryTicketModel != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Ganadero: ${deliveryTicketModel.rancher?.name ?? ""}'),
                              Text(
                                  'Matadero: ${deliveryTicketModel.slaughterhouse?.name ?? ""}'),
                              const SizedBox(height: 8.0),
                              Table(
                                border: TableBorder.all(color: Colors.grey),
                                columnWidths: const <int, TableColumnWidth>{
                                  0: FlexColumnWidth(),
                                  1: FlexColumnWidth(),
                                },
                                children: [
                                  _buildTableRow(
                                    'Producto',
                                    productTicketModel.product?.name ?? '',
                                  ),
                                  _buildTableRow(
                                    'Nº Animales',
                                    '${productTicketModel.numAnimals ?? ' '}',
                                  ),
                                  _buildTableRow(
                                    'Peso',
                                    '${productTicketModel.weight ?? ' '}',
                                  ),
                                  _buildTableRow(
                                    'Clasificación',
                                    productTicketModel.nameClassification ?? '',
                                  ),
                                  _buildTableRow(
                                    'Rendimiento',
                                    '${productTicketModel.performance?.performance ?? ''}',
                                  ),
                                  _buildTableRow(
                                    'Color',
                                    productTicketModel.color ?? '',
                                  ),
                                  _buildTableRow(
                                    'Pérdidas',
                                    '${productTicketModel.losses ?? ' '}',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    final appColors = AppColors(context: context).getColors();

    return TableRow(
      children: [
        Container(
          color: appColors?['headBoardTableColor'],
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            value,
            style: TextStyle(color: appColors?['valueTableColor']),
          ),
        ),
      ],
    );
  }
}
