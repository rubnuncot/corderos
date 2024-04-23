import 'dart:async';

import 'package:corderos_app/!helpers/!helpers.dart';
import 'package:corderos_app/presentation/!presentation.dart';
import 'package:corderos_app/presentation/widgets/new_drop_down.dart';
import 'package:corderos_app/presentation/widgets/new_table_drop_down.dart';
import 'package:corderos_app/repository/!repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TablaTicket extends StatefulWidget {
  const TablaTicket({Key? key}) : super(key: key);

  @override
  State<TablaTicket> createState() => _TablaTicketState();
}

class _TablaTicketState extends State<TablaTicket> {
  int _tableCount = 1;
  DatabaseBloc? databaseBloc;
  bool isLoading = false;
  StreamSubscription? databaseBlocSubscription;
  final ScrollController _scrollController = ScrollController();
  bool dialogShown = false;

  @override
  void initState() {
    super.initState();
    databaseBloc = context.read<DatabaseBloc>();
    databaseBlocSubscription = databaseBloc!.stream.listen((state) {
      setState(() {
        isLoading = state is DatabaseLoading;
        if (state is DatabaseSuccess) {
          LogHelper.logger.d(state.message);
          LogHelper.logger.f(state.data.toString());
        } else if (state is DatabaseError) {
          LogHelper.logger.d(state.message);
        }
      });
    });
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    databaseBlocSubscription?.cancel();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void showEditDialog(
      String title,
      String currentValue,
      Function(String) onUpdate,
      ) {
    final appColors = AppColors(context: context).getColors();
    bool isDropDown = title == 'Producto' || title == 'Clasif';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String editedValue = currentValue;
        return AlertDialog(
          title: Text('Editar $title',
              style: TextStyle(color: appColors?['dialogTitleColor'])),
          content: SizedBox(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.1,
            child: isDropDown
                ? const SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: NewDropDown(
                  listIndex: 1, // Adjust the list index as needed
                ),
              ),
            )
                : TextField(
              onChanged: (value) {
                editedValue = value;
              },
              cursorColor: appColors?['dialogTitleColor'],
              style: TextStyle(color: appColors?['dialogHintColor']),
              controller: TextEditingController(text: currentValue),
              decoration: InputDecoration(
                hintText: "Ingresa nuevo valor",
                hintStyle: TextStyle(color: appColors?['dialogHintColor']),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onUpdate(editedValue);
              },
              child: Text('Actualizar',
                  style: TextStyle(color: appColors?['updateDialogButtonColor'])),
            ),
          ],
        );
      },
    );
  }


  void _scrollListener() {
    double screenWidth = MediaQuery.of(context).size.width;
    double offsetThreshold = screenWidth * 0.2; // 20% del ancho de la pantalla
    double closeOffsetThreshold = screenWidth * 0.2 + 5; // 20% + 5 unidades

    if (_scrollController.position.pixels > _scrollController.position.maxScrollExtent + offsetThreshold) {
      if (!dialogShown) {
        dialogShown = true;
        setState(() {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: Text(
                  'Crear nueva tabla',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                content: Text(
                  '¿Deseas añadir una nueva tabla?',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.grey[600],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Colors.redAccent,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      dialogShown = false;
                    },
                  ),
                  TextButton(
                    child: const Text(
                      'Aceptar',
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      setState(() {
                        _tableCount++;
                        dialogShown = false;
                      });
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToNewTable();
                      });
                    },
                  ),
                ],
                backgroundColor: Colors.white,
                elevation: screenWidth * 0.06,
              );
            },
          );
        });
      }
    } else if (_scrollController.position.pixels < _scrollController.position.maxScrollExtent + closeOffsetThreshold) {
      dialogShown = false;
    }
  }

  void _scrollToNewTable() {
    double newTablePositionPercentage = 0.20;
    double screenWidth = MediaQuery.of(context).size.width;
    double newTablePosition = _scrollController.position.maxScrollExtent + (screenWidth * newTablePositionPercentage);

    _scrollController.animateTo(
      newTablePosition,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

  }

  Widget buildTableHeader(String text) {
    final appColors = AppColors(context: context).getColors();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: appColors?['headBoardTableColor'],
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[800],
          ),
        ),
      ),
    );
  }

  Widget buildEditableCell(String value, String label) {
    final appColors = AppColors(context: context).getColors();

    return TableCell(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: appColors?['backgroundValueColor'],
          // Color de fondo del botón
          padding: EdgeInsets.zero,
          foregroundColor: appColors?['valueTableColor'],
          // Color del texto
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        onPressed: () => showEditDialog(label, value, (newValue) {}),
        child: Text(value.isEmpty ? '-' : value),
      ),
    );
  }

  Widget buildTable() {
    final appColors = AppColors(context: context).getColors();

    return Column(
      children: [
        //! PRIMERA TABLA
        Table(
          border:
              TableBorder.all(color: appColors?['borderTableColor'], width: 2),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(3),
            2: FlexColumnWidth(2),
          },
          children: [
            TableRow(children: [
              buildTableHeader('Producto'),
              buildTableHeader('Número'),
              buildTableHeader('Clase'),
            ]),
            TableRow(children: [
              buildEditableCell('', 'Producto'),
              buildEditableCell('0', 'NºCorderos'),
              buildEditableCell('', 'Clasif'),
            ]),
          ],
        ),
        //! SEGUNDA TABLA
        Table(
          border: TableBorder(
            top: BorderSide.none,
            verticalInside: BorderSide(
              color: appColors?['borderTableColor'] ?? Colors.transparent,
              width: 2,
            ),
            left: BorderSide(
              color: appColors?['borderTableColor'] ?? Colors.transparent,
              width: 2,
            ),
            right: BorderSide(
              color: appColors?['borderTableColor'] ?? Colors.transparent,
              width: 2,
            ),
            bottom: BorderSide(
              color: appColors?['borderTableColor'] ?? Colors.transparent,
              width: 2,
            ),
            horizontalInside: BorderSide(
              color: appColors?['borderTableColor'] ?? Colors.transparent,
              width: 2,
            ),
          ),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(3),
            2: FlexColumnWidth(2),
          },
          children: [
            TableRow(children: [
              buildTableHeader('Rend'),
              buildTableHeader('Kg'),
              buildTableHeader('Color'),
            ]),
            TableRow(children: [
              buildEditableCell('0', 'Rendimiento'),
              buildEditableCell('0', 'Kg'),
              buildEditableCell('', 'Color'),
            ]),
          ],
        ),
      ],
    );
  }

  @override
    Widget build(BuildContext context) {
    double tableWidth = MediaQuery.of(context).size.width * 0.945;


    String formattedDate =
          "${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}";

      return Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              //! FILA 1 - DESPLEGABLES
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: InputSettings(
                        label: 'Fecha',
                        isNumeric: false,
                        isEditable: false,
                        valueNonEditable: formattedDate,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    const Expanded(
                      child: NewDropDown(
                        listIndex: 1,
                        labelText: 'Matrícula',
                      ),
                    ),
                  ],
                ),
              ),
              //! FILA 2 - DESPLEGABLES
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: NewDropDown(
                        listIndex: 1,
                        labelText: 'Matrícula',
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: NewDropDown(
                        listIndex: 1,
                        labelText: 'Matrícula',
                      ),
                    ),
                  ],
                ),
              ),
              //! FILA 3 - DESPLEGABLES
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: NewDropDown(
                        listIndex: 1,
                        labelText: 'Matrícula',
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: NewDropDown(
                        listIndex: 1,
                        labelText: 'Matrícula',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26.0),

              //! LISTA SCROLLEABLE DE TABLAS
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(
                      decelerationRate: ScrollDecelerationRate.normal),
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  itemCount: _tableCount,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        margin: const EdgeInsets.all(2.0),
                        width: tableWidth - 12,
                        child: Column(children: [
                          buildTable(),
                        ]));
                  },
                ),
              )
            ],
          ),
        ),
      );
  }
}
