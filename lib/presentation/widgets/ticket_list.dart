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
  List<AnimationController> animationControllers = [];
  Map<int, List<ProductTicketModel>> productTicketModels = {};
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
              animationControllers = List.generate(tickets.length, (index) => AnimationController(
                duration: const Duration(milliseconds: 300),
                vsync: this,
              ));
            });
            _fetchProductTickets();
            break;
          case 'FetchProductTickets':
            final ticketId = state.data[1].id;
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
    for (var controller in animationControllers) {
      controller.dispose();
    }
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
          final productTicketModelsList = productTicketModels[ticket.id];
          final deliveryTicketModel = deliveryTicketModels[ticket.id];
          final isSelected = selectedTickets.contains(ticket);
          final animationController = animationControllers[index];

          return Card(
            color: isSelected ? appColors!['selectedBackgroundCard'] : null,
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    '${ticket.number!}',
                    style: TextStyle(
                      color: isSelected
                          ? appColors!['selectedTitleCard']
                          : appColors!['unSelectedTitleCard'],
                    ),
                  ),
                  subtitle: Text(
                    'Description $index',
                    style: TextStyle(
                      color: isSelected
                          ? appColors['selectedTitleCard']
                          : appColors['unSelectedTitleCard'],
                    ),
                  ),
                  trailing: IconButton(
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.menu_close,
                      progress: animationController,
                      color: isSelected
                          ? appColors['selectedIconCard']
                          : appColors['unSelectedIconCard'],
                    ),
                    onPressed: () {
                      setState(() {
                        isOpen[index] = !isOpen[index];
                        if (isOpen[index]) {
                          animationController.forward();
                        } else {
                          animationController.reverse();
                        }
                      });
                    },
                  ),
                  onTap: () {
                    _toggleSelection(ticket);
                  },
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: isOpen[index] &&
                      productTicketModelsList != null &&
                      deliveryTicketModel != null
                      ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ganadero: ${deliveryTicketModel.rancher?.name ?? ""}',
                            style: TextStyle(
                              color: isSelected
                                  ? appColors['selectedHeaderCard']
                                  : appColors['unSelectedHeaderCard'],
                            ),
                          ),
                          Text(
                            'Matadero: ${deliveryTicketModel.slaughterhouse?.name ?? ""}',
                            style: TextStyle(
                              color: isSelected
                                  ? appColors['selectedHeaderCard']
                                  : appColors['unSelectedHeaderCard'],
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: productTicketModelsList.length,
                            itemBuilder: (context, productIndex) {
                              final productTicketModel = productTicketModelsList[productIndex];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Table(
                                  border: TableBorder.all(color: Colors.black54),
                                  columnWidths: const <int, TableColumnWidth>{
                                    0: FlexColumnWidth(),
                                    1: FlexColumnWidth(),
                                  },
                                  children: [
                                    _buildTableRow(
                                      'Producto',
                                      productTicketModel.product?.name ?? '',
                                      isSelected,
                                    ),
                                    _buildTableRow(
                                      'Nº Animales',
                                      '${productTicketModel.numAnimals ?? ' '}',
                                      isSelected,
                                    ),
                                    _buildTableRow(
                                      'Peso',
                                      '${productTicketModel.weight ?? ' '}',
                                      isSelected,
                                    ),
                                    _buildTableRow(
                                      'Clasificación',
                                      productTicketModel.nameClassification ?? '',
                                      isSelected,
                                    ),
                                    _buildTableRow(
                                      'Rendimiento',
                                      '${productTicketModel.performance?.performance ?? ''}',
                                      isSelected,
                                    ),
                                    _buildTableRow(
                                      'Color',
                                      productTicketModel.color ?? '',
                                      isSelected,
                                    ),
                                    _buildTableRow(
                                      'Pérdidas',
                                      '${productTicketModel.losses ?? ' '}',
                                      isSelected,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
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

  TableRow _buildTableRow(String label, String value, bool isSelected) {
    final appColors = AppColors(context: context).getColors();

    return TableRow(
      children: [
        Container(
          color: appColors?['headBoardTableColor'],
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[800],
            ),
          ),
        ),
        Container(
          color: appColors!['rightColumn'],
          padding: const EdgeInsets.all(8.0),
          child: Text(
            value,
            style: TextStyle(
              color: isSelected
                  ? appColors['selectedContentCard']
                  : appColors['unSelectedContentCard'],
            ),
          ),
        ),
      ],
    );
  }
}
