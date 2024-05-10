import 'dart:async';

import 'package:corderos_app/!helpers/!helpers.dart';
import 'package:corderos_app/data/!data.dart';
import 'package:corderos_app/repository/!repository.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../../!helpers/app_theme.dart';

class TicketList extends StatefulWidget {
  const TicketList({super.key});

  @override
  State<TicketList> createState() => _TicketListState();
}

class _TicketListState extends State<TicketList> {
  TicketBloc? ticketBloc;
  StreamSubscription? ticketSubscription;

  IconData icon = Icons.radio_button_unchecked;

  List<DeliveryTicket> tickets = [];

  @override
  void initState() {
    ticketBloc = BlocProvider.of<TicketBloc>(context);
    ticketBloc!.add(FetchTicketsScreen());

    ticketSubscription = ticketBloc!.stream.listen((state) {
      if (state is TicketSuccess) {
        switch (state.event) {
          case 'FetchTicketsScreen':
            setState(() {
              tickets = state.data as List<DeliveryTicket>;
            });
            break;
          case 'SelectTicket':
            setState(() {
              int updatedIndex = tickets
                  .indexWhere((ticket) => ticket.id == state.data.first.id);
              if (updatedIndex != -1) {
                tickets[updatedIndex].isSend = !tickets[updatedIndex].isSend!;
              }
            });
            break;
          case 'DeleteTicket':
            setState(() {
              int ticketIndex = tickets
                  .indexWhere((ticket) => ticket.id == state.data.first.id);
              if (ticketIndex != -1) {
                tickets.removeAt(ticketIndex);
              }
            });
            break;
          case 'GetTicketInfo':
            setState(() {
              //! 0 --> ProductDeliveryNote | 1 --> DeliveryTicket
              showAlertDialog(state.data[0], state.data[1]);
            });
            break;
          default:
        }
      }
    });
    super.initState();
  }

  //! DETALLES TICKET
  void showAlertDialog(ProductDeliveryNoteModel productDeliveryNoteModel,
      DeliveryTicketModel deliveryTicketModel) {
    final appColors = AppColors(context: context).getColors();

    Dialogs.materialDialog(
      color: appColors?['backgroundCard'],
        customView: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: appColors?['backgroundCard'],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Serie Nº: ${deliveryTicketModel.number}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: appColors?['updateDialogButtonColor'],
                ),
              ),
              const SizedBox(height: 20),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: TableBorder.all(color: Colors.grey),
                children: [
                  _buildRow(
                      "Producto", '${productDeliveryNoteModel.product?.name}'),
                  _buildRow("Unidades", '${productDeliveryNoteModel.units}'),
                  _buildRow("Clasificación",
                      '${productDeliveryNoteModel.nameClassification}'),
                  _buildRow(
                      "Kilogramos", '${productDeliveryNoteModel.kilograms}'),
                  _buildRow("Color", '${productDeliveryNoteModel.color}'),
                  _buildRow(
                      "Número del ticket", '${deliveryTicketModel.number}'),
                  _buildRow("Fecha", '${deliveryTicketModel.date}'),
                  _buildRow(
                      "Vehículo",
                      deliveryTicketModel
                              .vehicleRegistration?.vehicleRegistrationNum ??
                          ""),
                  _buildRow(
                      "Conductor", deliveryTicketModel.driver?.name ?? ""),
                  _buildRow(
                      "Ganadero", deliveryTicketModel.rancher?.name ?? ""),
                ],
              ),
            ],
          ),
        ),
        context: context,
        actions: [
          IconsButton(
            onPressed: () {},
            text: 'Hecho',
            iconData: Icons.confirmation_num,
            color: appColors?['updateDialogButtonColor'],
            textStyle: TextStyle(color: appColors?['background']),
            iconColor: appColors?['background'],
          ),
        ]);
  }

  TableRow _buildRow(String title, String value) {
    final appColors = AppColors(context: context).getColors();

    return TableRow(
      decoration: BoxDecoration(color: appColors?['headBoardTableColor']),
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
        TableCell(
          child: Container(
            color: appColors?['backgroundValueColor'],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                value,
                style: TextStyle(
                  color: appColors?['valueTableColor'],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  //! MENÚ DE OPCIONES DROPDOWN
  void showDropDown(DeliveryTicket ticket) {
    DropDownState(
      DropDown(
        isSearchVisible: false,
        bottomSheetTitle: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Serie Nº: ${ticket.id!}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        data: [
          SelectedListItem(name: 'Borrar', value: 'delete'),
          SelectedListItem(name: 'Ver Ticket', value: 'showTicket'),
          SelectedListItem(name: 'Imprimir'),
        ],
        selectedItems: (selectedItems) {
          switch (selectedItems.first.value) {
            case 'delete':
              ticketBloc!.add(DeleteTicket(ticketId: ticket.id!));
              break;
            case 'showTicket':
              ticketBloc!.add(GetTicketInfo(ticketId: ticket.id!));
              break;
            default:
            //TODO: Imprimir el recibo
          }
        },
      ),
    ).showModal(context);
  }

  @override
  void dispose() {
    ticketSubscription!.cancel();
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
          return ZoomTapAnimation(
            onTap: () {
              showDropDown(tickets[index]);
            },
            child: Card(
              color: appColors?['background'],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(6),
              elevation: 5,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Icon(FontAwesomeIcons.file, size: 24),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(

                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Serie Nº: ${tickets[index].number.toString()}',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: appColors?['dialogTitleColor']),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Aqui pondré el producto.',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: IconButton(
                          onPressed: () {
                            ticketBloc!.add(
                                SelectTicket(ticketId: tickets[index].id!));
                          },
                          icon: Icon(
                            tickets[index].isSend!
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: Colors.blue,
                            size: 30,
                          ),
                        )),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
