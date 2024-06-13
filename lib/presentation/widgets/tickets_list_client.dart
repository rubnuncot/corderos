import 'dart:async';

import 'package:corderos_app/!helpers/!helpers.dart';
import 'package:corderos_app/data/!data.dart';
import 'package:corderos_app/repository/!repository.dart';
import 'package:corderos_app/repository/blocs/!blocs.dart';
import 'package:corderos_app/repository/blocs/ticket_client_bloc/ticket_client_bloc.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class TicketListClient extends StatefulWidget {
  const TicketListClient({super.key});

  @override
  State<TicketListClient> createState() => _TicketListClientState();
}

class _TicketListClientState extends State<TicketListClient> {
  TicketClientBloc? ticketBloc;
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  DateFormat timeFormat = DateFormat('HH:mm:ss');
  StreamSubscription? ticketSubscription;

  IconData icon = Icons.radio_button_unchecked;

  List<ClientDeliveryNote> tickets = [];
  List<Client> clients = [];
  List<Product> products = [];
  List<ProductTicketModel> productTickets = [];

  int losses = 0;

  bool isTicketSend = false;
  bool openedList = false;
  bool openedTicket = false;

  @override
  void initState() {
    ticketBloc = BlocProvider.of<TicketClientBloc>(context);
    ticketBloc!.add(FetchTicketsClientScreen());

    ticketSubscription = ticketBloc!.stream.listen((state) {
      if (state is TicketClientSuccess) {
        switch (state.event) {
          case 'FetchTicketsClientScreen':
            setState(() {
              tickets = (state.data[0] as List<ClientDeliveryNote>).reversed.toList();
              clients = (state.data[1] as List<Client>).reversed.toList();
            });
            break;
          case 'SelectTicketClient':
            setState(() {
              int updatedIndex = tickets
                  .indexWhere((ticket) => ticket.id == state.data.first.id);
              if (updatedIndex != -1) {
                tickets[updatedIndex].isSend = !tickets[updatedIndex].isSend!;
              }
            });
            break;
          case 'DeleteTicketClient':
            setState(() {
              int ticketIndex = tickets
                  .indexWhere((ticket) => ticket.id == state.data.first.id);
              if (ticketIndex != -1) {
                tickets.removeAt(ticketIndex);
              }
            });
            break;
          case 'GetTicketClientInfo':
            setState(() {
              if (!openedTicket) {
                showAlertDialog(state.data[0], state.data[1]);
              }
            });
            break;
          case 'OpenProductTicketClientList':
            productTickets = state.data[0] as List<ProductTicketModel>;
            if (!openedList) {
              _showTicket();
            }
            break;
          case 'DeleteAllTicketsClients':
            setState(() {
              tickets = [];
              clients = [];
              products = [];
              _showSuccessDialog();
            });
            break;
          default:
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    ticketSubscription!.cancel();
    super.dispose();
  }

  //! DETALLES TICKET
  void showAlertDialog(List<ProductDeliveryNoteModel> productTicketModel,
      ClientDeliveryNoteModel deliveryTicketModel) {
    final appColors = AppColors(context: context).getColors();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final formattedDate = Jiffy.parse(deliveryTicketModel.date.toString()).format(pattern: 'dd/MM/yyyy');


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
                'Ticket ${deliveryTicketModel.number}',
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
                          _buildRow("Unidades", '${x.units}'),
                          _buildRow(
                              "Clasificación", '${x.classification!.name}'),
                          _buildRow("Kilogramos", '${x.kilograms}'),
                          _buildRow("Color", '${x.color}'),
                          _buildRow("Fecha", formattedDate),
                          _buildRow("Conductor",
                              deliveryTicketModel.driver?.name ?? ""),
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
    final appColors = AppColors(context: context).getColors();
    openedTicket = true;
    Dialogs.materialDialog(
      context: context,
      onClose: (value) {
        openedTicket = false;
      },
      color: appColors!['lineTicketBackground'],
      customView: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Tickets',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: appColors['dialogTitleColor'],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: productTickets.length,
                itemBuilder: (context, index) {
                  return ZoomTapAnimation(
                    onTap: () {
                      Navigator.pop(context);
                      _showLossesDialog(index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 24.0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: appColors['background'],
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Producto: ${productTickets[index].product!.name}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: appColors['dialogTitleColor'],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Clasificación: ${productTickets[index].classification!.name}',
                              style: TextStyle(
                                fontSize: 16,
                                color: appColors['dialogTitleColor'],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showLossesDialog(int index) {
    final appColors = AppColors(context: context).getColors();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appColors!['buttonNavigationBackground'],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Añadir Bajas',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: appColors['dialogTitleColor'],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Producto: ${productTickets[index].product!.name}',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Clasificación: ${productTickets[index].classification!.name}',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blueGrey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueGrey[800]!,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      losses = int.parse(value);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
  void showDropDown(ClientDeliveryNote ticket) {
    DropDownState(
      DropDown(
        isSearchVisible: false,
        bottomSheetTitle: const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Menú de Opciones:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        data: [
          SelectedListItem(name: 'Borrar', value: 'delete'),
          SelectedListItem(name: 'Ver Ticket', value: 'showTicket'),
          SelectedListItem(name: 'Enviar', value: 'send'),
        ],
        selectedItems: (selectedItems) {
          switch (selectedItems.first.value) {
            case 'delete':
              ticketBloc!.add(DeleteTicketClient(ticketId: ticket.id!));
              break;
            case 'showTicket':
              ticketBloc!.add(GetTicketClientInfo(ticketId: ticket.id!));
              break;
            case 'send':
              ticketBloc!.add(SendTicket(ticketId: ticket.id!));
            default:
              LogHelper.logger.d('Evento no reconocido');
          }
        },
      ),
    ).showModal(context);
  }

  void _showDeleteAllDialog() {
    final appColors = AppColors(context: context).getColors();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appColors!['buttonNavigationBackground'],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Column(
            children: [
              const Icon(Icons.warning, color: Colors.redAccent, size: 50),
              const SizedBox(height: 8),
              Text(
                'Confirmar Borrado',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: appColors['dialogTitleColor'],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              '¿Está seguro de que desea borrar todos los tickets?',
              style: TextStyle(
                fontSize: 16,
                color: appColors['dialogContentColor'],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                if (tickets.isNotEmpty) {
                  ticketBloc!.add(DeleteAllTicketsClients());
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pop();
                  _showNoTicketsDialog();
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
              child: const Text('Sí'),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    final appColors = AppColors(context: context).getColors();

    Dialogs.materialDialog(
      context: context,
      color: appColors!['buttonNavigationBackground'],
      customView: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, size: 80, color: appColors['successIconColor']),
            const SizedBox(height: 16),
            Text(
              '¡Éxito!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: appColors['dialogTitleColor'],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Todos los tickets han sido borrados con éxito.',
              style: TextStyle(
                fontSize: 18,
                color: appColors['dialogContentColor'],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8), // Reduced margin here
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }


  void _showNoTicketsDialog() {
    final appColors = AppColors(context: context).getColors();

    Dialogs.materialDialog(
      context: context,
      color: appColors!['buttonNavigationBackground'],
      customView: Container(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.info, size: 80, color: appColors['infoIconColor']),
            const SizedBox(height: 16),
            Text(
              'Sin tickets',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: appColors['dialogTitleColor'],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay tickets que borrar.',
              style: TextStyle(
                fontSize: 18,
                color: appColors['dialogContentColor'],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors(context: context).getColors();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showDeleteAllDialog,
        backgroundColor: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: tickets.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox,
                  size: 100, color: appColors!['emptyStateIconColor']),
              const SizedBox(height: 16),
              Text(
                'No hay tickets disponibles',
                style: TextStyle(
                  fontSize: 24,
                  color: appColors['emptyStateTextColor'],
                ),
              ),
            ],
          ),
        )
            : ListView.builder(
          itemCount: tickets.length,
          itemBuilder: (context, index) {
            final ticket = tickets[index];
            String formattedDate = dateFormat.format(ticket.date!);
            ticketBloc!.add(SetIconTicketClientState(
                number: ticket.number!));
            return ZoomTapAnimation(
              onTap: () {
                showDropDown(ticket);
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        //FontAwesomeIcons.file, size: 24
                        child: Icon(
                          isTicketSend
                              ? FontAwesomeIcons.check
                              : FontAwesomeIcons.file,
                          size: 24,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('Serie: ${ticket.series}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: appColors['labelInputColor'])),
                                Text('Num: ${ticket.number}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: appColors['labelInputColor'])),
                              ],
                            ),
                            Text(
                              'Cliente: ${clients[index].name}',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: appColors['labelInputColor']),
                            ),
                            Text(
                              'Fecha: $formattedDate',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: appColors['labelInputColor']),
                            ),
                          ],
                        )
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 10.0),
                        child: IconButton(
                          onPressed: () {
                            ticketBloc!.add(SelectTicketClient(
                                ticketId: ticket.id!));
                          },
                          icon: Icon(
                            ticket.isSend!
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: Colors.blue,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
