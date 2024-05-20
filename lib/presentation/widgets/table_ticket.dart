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
  int _tableCount = 1;
  String _selectedRancher = ''; // Nueva variable de estado

  DatabaseBloc? databaseBloc;
  BurdenBloc? burdenBloc;
  bool isLoading = false;
  StreamSubscription? databaseBlocSubscription;
  StreamSubscription? tableItemDatabaseSubscription;
  final ScrollController _scrollController = ScrollController();
  bool dialogShown = false;

  List<ProductTicketModel> productTickets = [ProductTicketModel()];

  List<String> performances = [];

  FocusNode focusNode = FocusNode();
  TextEditingController textController = TextEditingController();

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    tableItemDatabaseSubscription!.cancel();
    _scrollController.dispose();
    focusNode.dispose();
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
          isSend: false,
        ),
        productTicket: productTickets
            .where((element) =>
                (element.numAnimals != null && element.numAnimals! > 0))
            .toList()));

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
    int index,
    String currentValue,
    Function(String) onUpdate,
  ) {
    bool isDropDown = _isDropDownField(title);
    bool isEditable = title != 'Clasif';
    Map<String, String> dropDownValues = {
      'Producto': 'product',
      'Clasif': 'classification',
      'Rend': 'performance'
    };

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final dropDownBloc = context.read<DropDownBloc>();
        final appColors = AppColors(context: context).getColors();
        String editedValue = currentValue;
        return AlertDialog(
          title: _buildDialogTitle(title, appColors),
          content: _buildDialogContent(
            context,
            title,
            currentValue,
            isDropDown,
            isEditable,
            dropDownBloc,
            dropDownValues,
            (value) => editedValue = value,
            appColors,
            index,
          ),
          actions: _buildDialogActions(
            context,
            title,
            editedValue,
            onUpdate,
            dropDownBloc,
            appColors,
            index,
          ),
        );
      },
    );
  }

  bool _isDropDownField(String title) {
    return title == 'Producto' || title == 'Rend';
  }

  Widget _buildDialogTitle(String title, Map<String, dynamic>? appColors) {
    return Text(
      'Editar $title',
      style: TextStyle(color: appColors?['dialogTitleColor']),
    );
  }

  Widget _buildDialogContent(
    BuildContext context,
    String title,
    String currentValue,
    bool isDropDown,
    bool isEditable,
    DropDownBloc dropdownBloc,
    Map<String, String> dropDownValues,
    Function(String) onChanged,
    Map<String, dynamic>? appColors,
    int index,
  ) {
    return SizedBox(
      width: double.maxFinite,
      height: MediaQuery.of(context).size.height * 0.1,
      child: isDropDown
          ? _buildDropDownContent(
              title, currentValue, dropDownValues, dropdownBloc, context, index)
          : _buildTextFieldContent(
              isEditable, currentValue, onChanged, appColors),
    );
  }

  Widget _buildDropDownContent(
    String title,
    String currentValue,
    Map<String, String> dropDownValues,
    DropDownBloc dropDownBloc,
    BuildContext context,
    int index,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: title == 'Rend'
            ? NewDropDown(
                values: performances,
                initialValue: productTickets[index].performance != null
                    ? productTickets[index].performance!.performance.toString()
                    : performances.first,
              )
            : NewDropDown(
                mapKey: dropDownValues[title]!,
              ),
      ),
    );
  }

  Widget _buildTextFieldContent(
    bool isEditable,
    String currentValue,
    Function(String) onChanged,
    Map<String, dynamic>? appColors,
  ) {
    if (!isEditable) return Container();
    textController.selection = TextSelection(
        baseOffset: 0, extentOffset: textController.text.length);
    return TextField(
      cursorColor: appColors?['dialogTitleColor'],
      style: TextStyle(color: appColors?['dialogHintColor']),
      controller: textController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Ingresa nuevo valor",
        hintStyle: TextStyle(color: appColors?['dialogHintColor']),
      ),
      onChanged: onChanged,
    );
  }

  List<Widget> _buildDialogActions(
    BuildContext context,
    String title,
    String editedValue,
    Function(String) onUpdate,
    DropDownBloc dropDownBloc,
    Map<String, dynamic>? appColors,
    int index,
  ) {
    return [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          onUpdate(textController.text);
          _updateDropDownBloc(dropDownBloc, title, index);
          dropDownBloc.filterSelectedClassification(
              productTickets[index].nameClassification ?? '');
          performances = dropDownBloc.state.values['performance']!;
          setState(() {});
        },
        child: Text(
          'Actualizar',
          style: TextStyle(color: appColors?['updateDialogButtonColor']),
        ),
      ),
    ];
  }

  void _updateDropDownBloc(DropDownBloc dropDownBloc, String title, int index) {
    dropDownBloc.filterSelectedProduct();

    if (title == 'Producto') {
      productTickets = [];
      for (var x in dropDownBloc.state.values["classification"]!) {
        productTickets.addAll([
          ProductTicketModel()
              .updateValue<ProductTicketModel>('nameClassification', x)
              .updateValue<ProductTicketModel>(
                  'product',
                  dropDownBloc.state.models['product']!
                      .where((element) =>
                          element.name ==
                          dropDownBloc.state.selectedValues['product'])
                      .first)
        ]);
      }
    }
  }

  Widget buildTableHeader(String text) {
    final appColors = AppColors(context: context).getColors();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: appColors?['headBoardTableColor'],
      child: Center(
        child: Text(text,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            maxLines: 1),
      ),
    );
  }

  Widget buildEditableCell(
      String value, Map<String, String> label, int listIndex) {
    final appColors = AppColors(context: context).getColors();

    return TableCell(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: appColors?['backgroundValueColor'],
          padding: EdgeInsets.zero,
          foregroundColor: appColors?['valueTableColor'],
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        onPressed: () async {
          final dropDownBloc = context.read<DropDownBloc>();
          textController.text = value;
          Map<String, dynamic> list = await dropDownBloc.getSelectedModel();

          if (label.keys.first != 'Clasif') {
            showEditDialog(label.keys.first, listIndex, value, (newValue) {
              setState(() {
                dynamic requestValue = list;
                String key = label.keys.first;

                switch (key) {
                  case 'NºCorderos':
                  case 'Kg':
                  case 'Color':
                    requestValue = newValue;
                  case 'Clasif':
                    requestValue =
                        list[ClassificationModel().runtimeType.toString()].name;
                    break;
                  default:
                    requestValue = list;
                }

                value = newValue;
                productTickets[listIndex] = productTickets[listIndex]
                    .updateValue<ProductTicketModel>(
                        label.values.first, requestValue);
              });
            });
          }

          textController.selection = TextSelection(
              baseOffset: 0, extentOffset: textController.text.length);
        },
        child: Text(value),
      ),
    );
  }

  Widget buildTable(DropDownStateBloc dropDownState, int tableIndex) {
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
                  '${productTickets[tableIndex - 1].product == null ? '' : productTickets[tableIndex - 1].product!.name}',
                  {'Producto': 'product'},
                  tableIndex - 1),
              buildEditableCell(
                  '${productTickets[tableIndex - 1].numAnimals ?? '0'}',
                  {'NºCorderos': 'numAnimals'},
                  tableIndex - 1),
              buildEditableCell(
                  '${productTickets[tableIndex - 1].nameClassification}' ==
                          'null'
                      ? ''
                      : '${productTickets[tableIndex - 1].nameClassification}',
                  {'Clasif': 'nameClassification'},
                  tableIndex - 1),
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
                  '${productTickets[tableIndex - 1].performance == null ? '' : productTickets[tableIndex - 1].performance!.performance}',
                  {'Rend': 'performance'},
                  tableIndex - 1),
              buildEditableCell(
                  '${productTickets[tableIndex - 1].weight ?? '0'}',
                  {'Kg': 'weight'},
                  tableIndex - 1),
              buildEditableCell(
                  '${productTickets[tableIndex - 1].color}' == 'null'
                      ? ''
                      : '${productTickets[tableIndex - 1].color}',
                  {'Color': 'color'},
                  tableIndex - 1),
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text('Ganadero',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: appColors?[
                                                  'labelInputColor'])),
                                    ),
                                    CustomButton(
                                      text: _selectedRancher.isEmpty
                                          ? dropDownState
                                              .selectedValues['rancher']!
                                          : _selectedRancher,
                                      onPressed: () async {
                                        searchableDropdownBloc.setItems(
                                            dropDownState.values['rancher']!);
                                        searchableDropdownBloc.setHeight(
                                            screenHeight: MediaQuery.of(context)
                                                .size
                                                .height);
                                        setState(() {});
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
                                decelerationRate:
                                    ScrollDecelerationRate.normal),
                            scrollDirection: Axis.horizontal,
                            controller: _scrollController,
                            itemCount: productTickets.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                  margin: const EdgeInsets.all(2.0),
                                  width: tableWidth - 12,
                                  child: Column(children: [
                                    buildTable(dropDownState, index + 1),
                                  ]));
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SearchableDropdown(
                  dropdownValue: 'rancher',
                  titleText: 'Selecciona un ganadero',
                  onItemSelected: (String selectedRancher) {
                    setState(() {
                      _selectedRancher = selectedRancher;
                    });
                  },
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
