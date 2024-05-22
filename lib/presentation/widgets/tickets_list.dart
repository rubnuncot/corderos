import 'dart:async';

import 'package:corderos_app/!helpers/!helpers.dart';
import 'package:corderos_app/data/!data.dart';
import 'package:corderos_app/repository/!repository.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class TicketList extends StatefulWidget {
  const TicketList({super.key});

  @override
  State<TicketList> createState() => _TicketListState();
}

class _TicketListState extends State<TicketList> {
  TicketBloc? ticketBloc;
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  DateFormat timeFormat = DateFormat('HH:mm:ss');
  Rancher rancher = Rancher();
  Product product = Product();
  StreamSubscription? ticketSubscription;

  IconData icon = Icons.radio_button_unchecked;

  List<DeliveryTicket> tickets = [];
  List<ProductTicketModel> productTickets = [];

  int losses = 0;

  bool openedList = false;
  bool openedTicket= false;

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
              if (!openedTicket) {
                //! 0 --> ProductTicket | 1 --> DeliveryTicket
                showAlertDialog(state.data[0], state.data[1]);
              }
            });
            break;
          case 'GetTicketLines':
            break;
          case 'OpenProductTicketList':
            productTickets = state.data[0] as List<ProductTicketModel>;
            if (!openedList) {
              _showTicket();
            }
            break;
          case 'AddLosses':
            break;
          case 'FetchRancherAndProductInfo':
            setState(() {
              var data = state.data as Map<String, dynamic>;
              rancher = data['rancher'] as Rancher;
              product = data['product'] as Product;
            });
            break;
          default:
        }
      }
    });
    super.initState();
  }

  //! DETALLES TICKET
  void showAlertDialog(List<ProductTicketModel> productTicketModel,
      DeliveryTicketModel deliveryTicketModel) {
    final appColors = AppColors(context: context).getColors();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    openedTicket = true;

    Dialogs.materialDialog(
      onClose: (value) {
        openedTicket = false;
      },
      color: appColors!['backgroundCard'],
      customView: Container(
        padding: const EdgeInsets.all(16.0),
        width: screenWidth * 0.9,
        height: screenHeight * 0.72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: appColors['backgroundCard'],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Serie Nº: ${deliveryTicketModel.number}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: appColors['updateDialogButtonColor'],
                ),
              ),
              const SizedBox(height: 20),
              for (var x in productTicketModel)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: screenHeight * 0.9,
                        maxWidth: screenWidth * 0.8,
                      ),
                      child: Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        border: TableBorder.all(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12)),
                        children: [
                          _buildRow("Producto",
                              '${productTicketModel.first.product!.name}'),
                          _buildRow("Unidades", '${x.numAnimals}'),
                          _buildRow("Clasificación", '${x.nameClassification}'),
                          _buildRow("Kilogramos", '${x.weight}'),
                          _buildRow("Color", '${x.color}'),
                          _buildRow(
                              "Rendimiento", '${x.performance!.performance}'),
                          _buildRow("Número del ticket",
                              '${deliveryTicketModel.number}'),
                          _buildRow("Fecha", '${deliveryTicketModel.date}'),
                          _buildRow(
                              "Vehículo",
                              deliveryTicketModel.vehicleRegistration
                                      ?.vehicleRegistrationNum ??
                                  ""),
                          _buildRow("Conductor",
                              deliveryTicketModel.driver?.name ?? ""),
                          _buildRow("Ganadero",
                              deliveryTicketModel.rancher?.name ?? ""),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      context: context,
    );
  }

  _showTicket() {
    openedTicket = true;
    Dialogs.materialDialog(
        context: context,
        onClose: (value) {
          openedTicket = false;
        },
        customView: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: ListView.builder(
            itemCount: productTickets.length,
            itemBuilder: (context, index) {
              return ZoomTapAnimation(
                onTap: () {
                  Navigator.pop(context);
                  _showLossesDialog(index);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.blueGrey[50],
                    ),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Producto: ${productTickets[index].product!.name}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blueGrey[800],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Clasificación: ${productTickets[index].nameClassification}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blueGrey[800],
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              );
            },
          ),
        ));
  }

  _showLossesDialog(int index) {
    Dialogs.materialDialog(
      context: context,
      customView: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.2,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Añadir Bajas',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.blueGrey[800],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Bajas',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    losses = int.parse(value);
                  },
                ),
              ),
            ],
          )),
      actions: [
        IconsButton(
          onPressed: () {
            ticketBloc!.add(AddLosses(
              productTicketId: productTickets[index].id!,
              losses: losses,
            ));
            Navigator.pop(context);
            _showTicket();
          },
          text: 'Hecho',
          iconData: Icons.save_alt,
          color: Colors.blueGrey[800],
          textStyle: const TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
        IconsButton(
          onPressed: () {
            Navigator.pop(context);
            _showTicket();
          },
          text: 'Cancelar',
          iconData: Icons.cancel,
          color: Colors.redAccent,
          textStyle: const TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
    );
  }

  TableRow _buildRow(String title, String value) {
    final appColors = AppColors(context: context).getColors();

    return TableRow(
      decoration: BoxDecoration(color: appColors!['headBoardTableColor']),
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
              textAlign: TextAlign.justify,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        TableCell(
          child: Container(
            color: appColors['backgroundValueColor'],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                value,
                style: TextStyle(
                  color: appColors['valueTableColor'],
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
          SelectedListItem(name: 'Imprimir', value: 'print'),
          SelectedListItem(name: 'Añadir Bajas', value: 'addLosses'),
        ],
        selectedItems: (selectedItems) {
          switch (selectedItems.first.value) {
            case 'delete':
              ticketBloc!.add(DeleteTicket(ticketId: ticket.id!));
              break;
            case 'showTicket':
              ticketBloc!.add(GetTicketInfo(ticketId: ticket.id!));
              break;
            case 'print':
              ticketBloc!.add(
                  PrintTicketEvent(context: context, deliveryTicket: ticket));
            case 'addLosses':
              ticketBloc!.add(OpenProductTicketList(ticketId: ticket.id!));
            default:
              LogHelper.logger.d('Evento no reconocido');
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
          final reversedTickets = List.from(tickets.reversed);
          String formattedDate = dateFormat.format(reversedTickets[index].date);
          return ZoomTapAnimation(
            onTap: () {
              showDropDown(tickets[index]);
            },
            child: Card(
              color: appColors!['background'],
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
                              'Fecha: $formattedDate\nGanadero: ${rancher.name}',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: appColors['dialogTitleColor']),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${product.name}',
                              style: const TextStyle(
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
                            ticketBloc!.add(SelectTicket(
                                ticketId: reversedTickets[index].id!));
                          },
                          icon: Icon(
                            reversedTickets[index].isSend!
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
