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
import 'package:sqflite_simple_dao_backend/database/database/sql_builder.dart';

class TableTicket extends StatefulWidget {
  const TableTicket({super.key});

  @override
  State<TableTicket> createState() => _TableTicketState();
}

class _TableTicketState extends State<TableTicket> {
  String _selectedRancher = '';
  DatabaseBloc? databaseBloc;
  BurdenBloc? burdenBloc;
  DropDownBloc? dropDownBloc;
  bool isLoading = false;
  StreamSubscription? databaseBlocSubscription;
  StreamSubscription? tableItemDatabaseSubscription;
  StreamSubscription? performanceSubscription;
  final ScrollController _scrollController = ScrollController();
  bool dialogShown = false;
  bool activateButton = false;

  List<ProductTicketModel> productTickets = [ProductTicketModel()];

  List<String> performances = [];

  FocusNode focusNode = FocusNode();
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    burdenBloc = context.read<BurdenBloc>();
    dropDownBloc = context.read<DropDownBloc>();
    tableItemDatabaseSubscription = burdenBloc!.stream.listen((state) {
      setState(() {
        isLoading = state is BurdenLoading;
        if (state is BurdenSuccess) {
          switch (state.event) {
            case "IncrementTableIndex":
            case "GetTableIndex":
              break;
          }
        }
      });
    });
    performanceSubscription =
        context
            .read<DropDownBloc>()
            .stream
            .listen((state) {
          dropDownBloc!.getSelectedModel();
        });
    burdenBloc!.add(GetTableIndex());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    tableItemDatabaseSubscription!.cancel();
    performanceSubscription?.cancel();
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
              .clientDeliveryNote,
          idProduct: list[ProductModel().runtimeType.toString()].id,
          idRancher: list[RancherModel().runtimeType.toString()].id,
          idSlaughterhouse:
          list[SlaughterhouseModel().runtimeType.toString()].id,
          idDriver: list[DriverModel().runtimeType.toString()].id,
          idVehicleRegistration:
          list[VehicleRegistrationModel().runtimeType.toString()].id,
          date: DateTime.now(),
          number: 0,
          isSend: false,
          idOut: null,
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
    productTickets = [ProductTicketModel()];
  }

  void showEditDialog(String title,
      int index,
      String currentValue,
      Function(String) onUpdate,) {
    bool isDropDown = _isDropDownField(title);
    bool isEditable = title != 'Clasif';
    Map<String, String> dropDownValues = {
      'Producto': 'product',
      'Clasif': 'classification',
      'Rend': 'performance'
    };

    List<String> number = ['NºCorderos', 'Kg'];

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
            number: number.contains(title),
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
      style: TextStyle(color: appColors!['dialogTitleColor']),
    );
  }

  Widget _buildDialogContent(BuildContext context,
      String title,
      String currentValue,
      bool isDropDown,
      bool isEditable,
      DropDownBloc dropdownBloc,
      Map<String, String> dropDownValues,
      Function(String) onChanged,
      Map<String, dynamic>? appColors,
      int index,
      {bool number = false}) {
    return SizedBox(
      width: double.maxFinite,
      height: MediaQuery
          .of(context)
          .size
          .height * 0.1,
      child: isDropDown
          ? _buildDropDownContent(
          title, currentValue, dropDownValues, dropdownBloc, context, index)
          : _buildTextFieldContent(
          isEditable, currentValue, onChanged, appColors,
          number: number),
    );
  }

  Widget _buildDropDownContent(String title,
      String currentValue,
      Map<String, String> dropDownValues,
      DropDownBloc dropDownBloc,
      BuildContext context,
      int index,) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: title == 'Rend'
            ? NewDropDown(
          values: performances,
          mapKey: 'performance',
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

  Widget _buildTextFieldContent(bool isEditable, String currentValue,
      Function(String) onChanged, Map<String, dynamic>? appColors,
      {bool number = false}) {
    if (!isEditable) return Container();
    textController.selection =
        TextSelection(baseOffset: 0, extentOffset: textController.text.length);
    return TextField(
      cursorColor: appColors!['dialogTitleColor'],
      style: TextStyle(color: appColors['dialogHintColor']),
      controller: textController,
      keyboardType: number ? TextInputType.number : TextInputType.text,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Ingresa nuevo valor",
        hintStyle: TextStyle(color: appColors['dialogHintColor']),
      ),
      onChanged: onChanged,
    );
  }

  List<Widget> _buildDialogActions(BuildContext context,
      String title,
      String editedValue,
      Function(String) onUpdate,
      DropDownBloc dropDownBloc,
      Map<String, dynamic>? appColors,
      int index,) {
    return [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          onUpdate(textController.text);
          _updateDropDownBloc(dropDownBloc, title, index);
          dropDownBloc.filterSelectedClassification(productTickets.isEmpty
              ? ''
              : productTickets[index].classification!.name ?? '');
          performances = dropDownBloc.state.values['performance']!;

          activateButton = (title == 'Kg');
          setState(() {});
        },
        child: Text(
          'Actualizar',
          style: TextStyle(color: appColors!['updateDialogButtonColor']),
        ),
      ),
    ];
  }

  void _updateDropDownBloc(DropDownBloc dropDownBloc, String title,
      int index) async {
    dropDownBloc.filterSelectedProduct();
    Classification classificationEntity = Classification();

    if (title == 'Producto') {
      productTickets = [];
      for (var x in dropDownBloc.state.values["classification"]!) {
        var product = await Product().getData<Product>(where: [
          'name',
          SqlBuilder.constOperators['equals']!,
          "'${dropDownBloc.state.selectedValues['product']!}'"
        ]);
        final classifications =
        await classificationEntity.getData<Classification>(
          where: [
            'name',
            SqlBuilder.constOperators['like']!,
            "'%${x.replaceAll('\r', '')}%'",
            SqlBuilder.constOperators['and']!,
            'productId',
            SqlBuilder.constOperators['equals']!,
            "'${product[0].id!}'"
          ],
        );
        ClassificationModel classificationModel = ClassificationModel();
        await classificationModel.fromEntity(classifications[0]);
        productTickets.addAll([
          ProductTicketModel()
              .updateValue<ProductTicketModel>(
              'classification', classificationModel)
              .updateValue<ProductTicketModel>(
              'product',
              dropDownBloc.state.models['product']!
                  .where((element) =>
              element.name ==
                  dropDownBloc.state.selectedValues['product'])
                  .first)
        ]);
        setState(() {});
      }
    }
  }

  Widget buildTableHeader(String text) {
    final appColors = AppColors(context: context).getColors();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: appColors!['headBoardTableColor'],
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

  Widget buildEditableCell(String value, Map<String, String> label,
      int listIndex) {
    final appColors = AppColors(context: context).getColors();

    return TableCell(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: appColors!['backgroundValueColor'],
          padding: EdgeInsets.zero,
          foregroundColor: appColors['valueTableColor'],
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        onPressed: label.keys.first == "Clasificacion" ? null : () async {
          textController.text = value;
          Map<String, dynamic> list = await dropDownBloc!.getSelectedModel();
          setState(() {});
          if (label.keys.first == 'Producto' ||
              (label.keys.first == 'NºCorderos' &&
                  productTickets[listIndex].product != null) ||
              (productTickets[listIndex].product != null &&
                  productTickets[listIndex].numAnimals != null &&
                  productTickets[listIndex].numAnimals! > 0)) {
            showEditDialog(label.keys.first, listIndex, value,
                    (newValue) async {
                  dynamic requestValue = list;
                  String key = label.keys.first;
                  switch (key) {
                    case 'NºCorderos':
                    case 'Kg':
                      requestValue = newValue;
                    case 'Clasif':
                      requestValue =
                          list[ClassificationModel().runtimeType.toString()]
                              .name;
                      break;
                    case 'Rend':
                      requestValue = await dropDownBloc!.getSelectedModel();
                      break;
                    default:
                      requestValue = list;
                  }

                  value = newValue;
                  productTickets[listIndex] = productTickets[listIndex]
                      .updateValue<ProductTicketModel>(
                      label.values.first, requestValue);
                  setState(() {});
                });
          } else if (label.keys.first != 'Producto' &&
              productTickets[listIndex].product == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Primero selecciona un producto para poder seguir introduciendo datos.'),
              ),
            );
          } else if (productTickets[listIndex].numAnimals == null ||
              productTickets[listIndex].numAnimals! == 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Primero añade el número de animales.'),
              ),
            );
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
          TableBorder.all(color: appColors!['borderTableColor'], width: 2),
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
                  '${productTickets[tableIndex - 1].product == null
                      ? ''
                      : productTickets[tableIndex - 1].product!.name}',
                  {'Producto': 'product'},
                  tableIndex - 1),
              buildEditableCell(
                  '${productTickets[tableIndex - 1].numAnimals ?? '0'}',
                  {'NºCorderos': 'numAnimals'},
                  tableIndex - 1),
              buildEditableCell(
                  '${productTickets[tableIndex - 1].classification == null
                      ? ''
                      : productTickets[tableIndex - 1].classification!.name}',
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
              color: appColors['borderTableColor'] ?? Colors.transparent,
              width: 2,
            ),
            left: BorderSide(
              color: appColors['borderTableColor'] ?? Colors.transparent,
              width: 2,
            ),
            right: BorderSide(
              color: appColors['borderTableColor'] ?? Colors.transparent,
              width: 2,
            ),
            bottom: BorderSide(
              color: appColors['borderTableColor'] ?? Colors.transparent,
              width: 2,
            ),
            horizontalInside: BorderSide(
              color: appColors['borderTableColor'] ?? Colors.transparent,
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
            ]),
            TableRow(children: [
              buildEditableCell(
                  '${productTickets[tableIndex - 1].performance == null
                      ? ''
                      : productTickets[tableIndex - 1].performance!
                      .performance}',
                  {'Rend': 'performance'},
                  tableIndex - 1),
              buildEditableCell(
                  '${productTickets[tableIndex - 1].weight ?? '0'}',
                  {'Kg': 'weight'},
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
    double tableWidth = MediaQuery
        .of(context)
        .size
        .width * 0.945;
    final appColors = AppColors(context: context).getColors();
    final dropDownState = context
        .watch<DropDownBloc>()
        .state;
    final searchableDropdownBloc = context.read<SearchableDropdownBloc>();

    String formattedDate =
        "${DateTime
        .now()
        .day
        .toString()
        .padLeft(2, '0')}/${DateTime
        .now()
        .month
        .toString()
        .padLeft(2, '0')}/${DateTime
        .now()
        .year}";

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery
                    .of(context)
                    .size
                    .width,
                maxHeight: MediaQuery
                    .of(context)
                    .size
                    .height,
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
                                      screenHeight: MediaQuery
                                          .of(context)
                                          .size
                                          .height);
                                  setState(() {});
                                },
                                textColor: appColors!['valueTableColor'],
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
        onPressed: !activateButton ? null : () async {
          final dropDownBloc = context.read<DropDownBloc>();
          Map<String, dynamic> list = await dropDownBloc.getSelectedModel();

          if (await Permission.bluetooth
              .request()
              .isGranted &&
              await Permission.bluetoothScan
                  .request()
                  .isGranted &&
              await Permission.location
                  .request()
                  .isGranted &&
              await Permission.bluetoothAdvertise
                  .request()
                  .isGranted &&
              await Permission.bluetoothConnect
                  .request()
                  .isGranted) {
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
