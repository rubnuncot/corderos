import 'dart:async';

import 'package:corderos_app/!helpers/!helpers.dart';
import 'package:corderos_app/data/!data.dart';
import 'package:corderos_app/presentation/!presentation.dart';
import 'package:corderos_app/presentation/widgets/bluetooth_list.dart';
import 'package:corderos_app/presentation/widgets/new_drop_down.dart';
import 'package:corderos_app/presentation/widgets/searchable_dropdown.dart';
import 'package:corderos_app/repository/!repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:permission_handler/permission_handler.dart';

class TableTicket extends StatefulWidget {
  const TableTicket({super.key});

  @override
  State<TableTicket> createState() => _TableTicketState();
}

class _TableTicketState extends State<TableTicket> {
  int _tableCount = 0;
  int _numeroCorderos = 0;
  double _kilogramos = 0.0;
  String _color = '-';

  DatabaseBloc? databaseBloc;
  BurdenBloc? burdenBloc;
  bool isLoading = false;
  StreamSubscription? databaseBlocSubscription;
  StreamSubscription? tableItemDatabaseSubscription;
  final ScrollController _scrollController = ScrollController();
  bool dialogShown = false;

  @override
  void initState() {
    super.initState();
    burdenBloc = context.read<BurdenBloc>();
    tableItemDatabaseSubscription = burdenBloc!.stream.listen((state) {
      setState(() {
        isLoading = state is BurdenLoading;
        if (state is BurdenSuccess) {
          switch (state.event) {
            case "IncrementTableIndex":
            case "GetTableIndex":
              _tableCount = state.data.first.first;
              break;
          }
        }
      });
    });
    burdenBloc!.add(GetTableIndex());
  }

  @override
  void dispose() {
    tableItemDatabaseSubscription!.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void endTicket(Map<String, dynamic> list) {
    burdenBloc?.add(UploadData(
        context: context,
        deliveryTicket: DeliveryTicket.all(
            deliveryTicket:
                list[VehicleRegistrationModel().runtimeType.toString()]
                    .vehicleRegistrationNum,
            idProduct: list[ProductModel().runtimeType.toString()].id,
            idRancher: list[RancherModel().runtimeType.toString()].id,
            idSlaughterhouse:
                list[SlaughterhouseModel().runtimeType.toString()].id,
            idDriver: list[DriverModel().runtimeType.toString()].id,
            idVehicleRegistration:
                list[VehicleRegistrationModel().runtimeType.toString()].id,
            date: DateTime.now(),
            number: _tableCount,
            id: _tableCount),
        productDeliveryNote: ProductDeliveryNote.all(
          idProduct: list[ProductModel().runtimeType.toString()].id,
          nameClassification:
              list[ClassificationModel().runtimeType.toString()].name,
          units: _numeroCorderos,
          kilograms: _kilogramos,
          color: _color,
          idDeliveryNote: 0,
          idClassification:
              list[ClassificationModel().runtimeType.toString()].id,
        )));

    burdenBloc!.stream
        .firstWhere((state) => state is BurdenSuccess || state is BurdenError)
        .then((state) {
      if (state is BurdenSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: "¡Guardado!",
              contentType: ContentType.success,
              message: state.message,
            ),
          ),
        );
      } else if (state is BurdenError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: "¡Error inesperado!",
              contentType: ContentType.failure,
              message: state.message,
            ),
          ),
        );
      }
    });
  }

  void showEditDialog(
    String title,
    String currentValue,
    Function(String) onUpdate,
  ) {
    final appColors = AppColors(context: context).getColors();
    bool isDropDown =
        title == 'Producto' || title == 'Clasif' || title == 'Rend';
    Map<String, String> dropDownValues = {
      'Producto': 'product',
      'Clasif': 'classification',
      'Rend': 'performance'
    };

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final dropDownBloc = context.read<DropDownBloc>();
        String editedValue = currentValue;
        return AlertDialog(
          title: Text('Editar $title',
              style: TextStyle(color: appColors?['dialogTitleColor'])),
          content: SizedBox(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.1,
            child: isDropDown
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: NewDropDown(
                        mapKey: dropDownValues[title]!,
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
                      hintStyle:
                          TextStyle(color: appColors?['dialogHintColor']),
                    ),
                  ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onUpdate(editedValue);

                switch (title) {
                  case "Producto":
                    dropDownBloc.filterSelectedProduct();
                    break;
                  case "NºCorderos":
                    setState(
                        () => _numeroCorderos = int.tryParse(editedValue) ?? 0);
                    break;
                  case "Kg":
                    setState(() =>
                        _kilogramos = double.tryParse(editedValue) ?? 0.0);
                    break;
                  case "Color":
                    setState(() => _color = editedValue);
                    break;
                  default:
                    dropDownBloc.filterSelectedClassification();
                }

                setState(() {});
              },
              child: Text('Actualizar',
                  style:
                      TextStyle(color: appColors?['updateDialogButtonColor'])),
            ),
          ],
        );
      },
    );
  }

  Widget buildTableHeader(String text) {
    final appColors = AppColors(context: context).getColors();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: appColors?['headBoardTableColor'],
      child: Center(
        child: Text(text,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800]),
            overflow: TextOverflow.ellipsis,
            maxLines: 2
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
          padding: EdgeInsets.zero,
          foregroundColor: appColors?['valueTableColor'],
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        onPressed: () => showEditDialog(label, value, (newValue) {}),
        child: Text(value),
      ),
    );
  }

  Widget buildTable(DropDownState dropDownState, int tableIndex) {
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
              buildTableHeader('Clasif'),
            ]),
            TableRow(children: [
              buildEditableCell(
                  dropDownState.selectedValues['product']!, 'Producto'),
              buildEditableCell('$_numeroCorderos', 'NºCorderos'),
              buildEditableCell(
                  dropDownState.selectedValues['classification']!, 'Clasif'),
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
              buildEditableCell(
                  dropDownState.selectedValues['performance']!, 'Rend'),
              buildEditableCell('$_kilogramos', 'Kg'),
              buildEditableCell(_color, 'Color'),
            ]),
          ],
        ),
      ],
    );
  }

  //! Muestra el cuádro de diálogo de los dispositivos bluetooth
  Future<void> showBluetoothConnectionDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Conexión Bluetooth'),
          content: const BluetoothList(),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double tableWidth = MediaQuery.of(context).size.width * 0.945;
    final appColors = AppColors(context: context).getColors();
    final dropDownState = context.watch<DropDownBloc>().state;
    final searchableDropdownBloc = context.read<SearchableDropdownBloc>();

    String formattedDate =
        "${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}";

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
            children: [
              SingleChildScrollView(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width,
                      maxHeight: MediaQuery.of(context).size.height,
                    ),
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
                                  animate: false,
                                  isNumeric: false,
                                  isEditable: false,
                                  valueNonEditable: formattedDate,
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              const Expanded(
                                child: NewDropDown(
                                  mapKey: 'vehicle_registration',
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
                                  mapKey: 'driver',
                                  labelText: 'Conductor',
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
                                  mapKey: 'slaughterhouse',
                                  labelText: 'Matadero',
                                ),
                              ),
                            ],
                          ),
                        ),
                        //! FILA 4 - DESPLEGABLES
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      child: Text(
                                          'Ganadero',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: appColors?['labelInputColor'])),
                                    ),
                                    CustomButton(
                                      text: dropDownState.selectedValues['rancher']!,
                                      onPressed: () async {
                                        searchableDropdownBloc.setItems(dropDownState.values['rancher']!);
                                        searchableDropdownBloc.setHeight(screenHeight: MediaQuery.of(context).size.height);
                                        setState(() {

                                        });
                                      },
                                      textColor: appColors?['valueTableColor'],
                                    ),
                                  ],
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
                            itemCount: 1,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                  margin: const EdgeInsets.all(2.0),
                                  width: tableWidth - 12,
                                  child: Column(children: [
                                    buildTable(dropDownState, _tableCount + 1),
                                  ]));
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              const SearchableDropdown(
                dropdownValue: 'rancher',
                titleText: 'Selecciona un ganadero',
              ),
            ],
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final dropDownBloc = context.read<DropDownBloc>();
          Map<String, dynamic> list = await dropDownBloc.getSelectedModel();

          if (await Permission.bluetooth.request().isGranted &&
              await Permission.bluetoothScan.request().isGranted &&
              await Permission.location.request().isGranted &&
              await Permission.bluetoothAdvertise.request().isGranted &&
              await Permission.bluetoothConnect.request().isGranted) {
            endTicket(list);
            burdenBloc!.add(IncrementTableIndex());
          }
        },
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(FontAwesomeIcons.print, size: 18),
                Icon(FontAwesomeIcons.download, size: 18),
              ]),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
