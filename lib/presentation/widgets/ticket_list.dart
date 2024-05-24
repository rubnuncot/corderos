import 'dart:async';
import 'package:corderos_app/repository/!repository.dart';
import 'package:corderos_app/repository/blocs/send_bloc/send_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  SendBloc? sendBloc;
  List<bool> isOpen = [];
  List<AnimationController> animationControllers = [];
  Map<int, List<ProductTicketModel>> productTicketModels = {};
  Map<int, DeliveryTicketModel> deliveryTicketModels = {};
  List<DeliveryTicket> tickets = [];
  List<DeliveryTicket> selectedTickets = [];

  @override
  void initState() {
    super.initState();
    _initializeBloc();
  }

  void _initializeBloc() {
    clientBloc = BlocProvider.of<ClientBloc>(context);
    sendBloc = BlocProvider.of<SendBloc>(context);
    clientBloc!.add(FetchTickets());

    clientSubscription = clientBloc!.stream.listen((state) {
      if (state is ClientSuccess) {
        _handleClientSuccess(state);
      }
    });
  }

  void _handleClientSuccess(ClientSuccess state) {
    switch (state.event) {
      case 'FetchTickets':
        _handleFetchTickets(state);
        break;
      case 'FetchProductTickets':
        _handleFetchProductTickets(state);
        break;
      case 'SelectSendTicket':
        _handleSelectSendTicket(state);
        break;
      default:
        LogHelper.logger.d('Evento no reconocido');
    }
  }

  void _handleFetchTickets(ClientSuccess state) {
    setState(() {
      tickets = state.data as List<DeliveryTicket>;
      isOpen = List.generate(tickets.length, (_) => false);
      animationControllers = List.generate(tickets.length, (_) =>
          AnimationController(duration: const Duration(milliseconds: 300), vsync: this));
    });
    _fetchProductTickets();
  }

  void _handleFetchProductTickets(ClientSuccess state) {
    final ticketId = state.data[1].id;
    setState(() {
      productTicketModels[ticketId] = state.data[0];
      deliveryTicketModels[ticketId] = state.data[1];
    });
  }

  void _handleSelectSendTicket(ClientSuccess state) {
    setState(() {
      selectedTickets = state.selectedTickets!;
    });
  }

  void _fetchProductTickets() {
    for (var ticket in tickets) {
      clientBloc!.add(FetchProductTickets(idTicket: ticket.id!));
    }
  }

  void _toggleSelection(DeliveryTicket ticket) {
    clientBloc!.add(SelectSendTicket(ticket: ticket));
    sendBloc!.add(AddSelected(ticket));
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
          return _buildTicketCard(context, index, appColors);
        },
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context, int index, Map<String, dynamic>? appColors) {
    final ticket = tickets[index];
    final productTicketModelsList = productTicketModels[ticket.id];
    final deliveryTicketModel = deliveryTicketModels[ticket.id];
    final isSelected = selectedTickets.contains(ticket);
    final animationController = animationControllers[index];

    return Card(
      color: isSelected ? appColors!['selectedBackgroundCard'] : null,
      child: Column(
        children: [
          _buildListTile(ticket, index, isSelected, appColors, animationController),
          AnimatedSize(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.fastLinearToSlowEaseIn,
            child: _buildExpandedContent(isSelected, productTicketModelsList, deliveryTicketModel, appColors, index),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(DeliveryTicket ticket, int index, bool isSelected, Map<String, dynamic>? appColors, AnimationController animationController) {
    return ListTile(
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
      trailing: _buildAnimatedIcon(isSelected, animationController, index, appColors),
      onTap: () {
        _toggleSelection(ticket);
      },
    );
  }

  Widget _buildAnimatedIcon(bool isSelected, AnimationController animationController, int index, Map<String, dynamic>? appColors) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: animationController,
        color: isSelected
            ? appColors!['selectedIconCard']
            : appColors!['unSelectedIconCard'],
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
    );
  }

  Widget _buildExpandedContent(bool isSelected, List<ProductTicketModel>? productTicketModelsList, DeliveryTicketModel? deliveryTicketModel, Map<String, dynamic>? appColors, int index) {
    if (isOpen[index] && productTicketModelsList != null && deliveryTicketModel != null) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDeliveryDetails(deliveryTicketModel, isSelected, appColors),
              const SizedBox(height: 8.0),
              _buildProductDetails(productTicketModelsList, isSelected, appColors),
            ],
          ),
        ),
      );
    }
    return Container();
  }

  Widget _buildDeliveryDetails(DeliveryTicketModel deliveryTicketModel, bool isSelected, Map<String, dynamic>? appColors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ganadero: ${deliveryTicketModel.rancher?.name ?? ""}',
          style: TextStyle(
            color: isSelected
                ? appColors!['selectedHeaderCard']
                : appColors!['unSelectedHeaderCard'],
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
      ],
    );
  }

  Widget _buildProductDetails(List<ProductTicketModel> productTicketModelsList, bool isSelected, Map<String, dynamic>? appColors) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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
            children: _buildProductTableRows(productTicketModel, isSelected),
          ),
        );
      },
    );
  }

  List<TableRow> _buildProductTableRows(ProductTicketModel productTicketModel, bool isSelected) {
    return [
      _buildTableRow('Producto', productTicketModel.product?.name ?? '', isSelected),
      _buildTableRow('Nº Animales', '${productTicketModel.numAnimals ?? ' '}', isSelected),
      _buildTableRow('Peso', '${productTicketModel.weight ?? ' '}', isSelected),
      _buildTableRow('Clasificación', productTicketModel.classification!.name ?? '', isSelected),
      _buildTableRow('Rendimiento', '${productTicketModel.performance?.performance ?? ''}', isSelected),
      _buildTableRow('Color', productTicketModel.color ?? '', isSelected),
      _buildTableRow('Pérdidas', '${productTicketModel.losses ?? ' '}', isSelected),
    ];
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
