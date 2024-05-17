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
  int _numeroCorderos = 0;
  double _kilogramos = 0.0;
  String _color = '-';
  int _losses = 0;
  String _selectedRancher = ''; // Nueva variable de estado

  DatabaseBloc? databaseBloc;
  BurdenBloc? burdenBloc;
  bool isLoading = false;
  StreamSubscription? databaseBlocSubscription;
  StreamSubscription? tableItemDatabaseSubscription;
  final ScrollController _scrollController = ScrollController();
  bool dialogShown = false;

  List<ProductTicketModel> productTickets = [ProductTicketModel()];

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

    // Scroll listener to detect when we reach the end of the list
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent + 200) {
        // When at the bottom, ask to generate new table
        if (!dialogShown) {
          dialogShown = true;
          _showGenerateTableDialog();
        }
      }
    });

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

  Future<void> _showGenerateTableDialog() async {
    final appColors = AppColors(context: context).getColors();
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Generar nueva tabla'),
          content: const Text('¿Deseas generar una nueva tabla?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancelar',
                  style:
                      TextStyle(color: appColors?['cancelDialogButtonColor'])),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Aceptar',
                  style:
                      TextStyle(color: appColors?['acceptDialogButtonColor'])),
            ),
          ],
        );
      },
    );

    if (result == true) {
      // Temporarily disable the scroll listener to avoid triggering it during the animation
      _scrollController.removeListener(_scrollListener);
      productTickets.add(ProductTicketModel());
      setState(() {
        _tableCount += 1;
      });

      // Animate to the new table
      await Future.delayed(const Duration(milliseconds: 300));
      _scrollController
          .animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      )
          .then((_) {
        // Re-enable the scroll listener
        _scrollController.addListener(_scrollListener);
      });
    }

    dialogShown = false;
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // When at the bottom, ask to generate new table
      if (!dialogShown) {
        dialogShown = true;
        _showGenerateTableDialog();
      }
    }
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
        productTicket: ProductTicket.all(
            idTicket: 0,
            idProduct: list[ProductModel().runtimeType.toString()].id,
            nameClassification:
                list[ClassificationModel().runtimeType.toString()].name,
            numAnimals: _numeroCorderos,
            weight: _kilogramos,
            idPerformance: list[PerformanceModel().runtimeType.toString()].id,
            color: _color,
            losses: _losses)));

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
                    cursorColor: appColors?['dialogTitleColor'],
                    style: TextStyle(color: appColors?['dialogHintColor']),
                    controller: textController,
                    focusNode: focusNode,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "Ingresa nuevo valor",
                      hintStyle:
                          TextStyle(color: appColors?['dialogHintColor']),
                    ),
                    onChanged: (value) {
                      editedValue = value;
                    },
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

          showEditDialog(label.keys.first, value, (newValue) {
            setState(() {
              dynamic requestValue = list;
              // Asume que `label` es un Map con un solo par clave-valor
              String key = label.keys.first;

              switch (key) {
                case 'NºCorderos':
                case 'Kg':
                case 'Color':
                  requestValue = newValue;
                case 'Clasif':
                  requestValue = list[ClassificationModel().runtimeType.toString()].name;
                  break;
                default:
                  requestValue = list;
              }

              value = newValue;
              productTickets[listIndex].updateValue<ProductTicketModel>(
                  label.values.first, requestValue);
            });
          });
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
              buildEditableCell('${productTickets[tableIndex - 1].product == null ? '' : productTickets[tableIndex - 1].product!.name}',
                  {'Producto': 'product'}, tableIndex - 1),
              buildEditableCell('${productTickets[tableIndex - 1].numAnimals ?? '0'}',
                  {'NºCorderos': 'numAnimals'}, tableIndex - 1),
              buildEditableCell('${productTickets[tableIndex - 1].nameClassification}' == 'null' ? '' : '${productTickets[tableIndex - 1].nameClassification}',
                  {'Clasif': 'nameClassification'}, tableIndex - 1),
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
              buildEditableCell('${productTickets[tableIndex - 1].performance == null ? '' : productTickets[tableIndex - 1].performance!.performance}',
                  {'Rend': 'performance'}, tableIndex - 1),
              buildEditableCell(
                  '${productTickets[tableIndex - 1].weight ?? '0'}', {'Kg': 'weight'}, tableIndex - 1),
              buildEditableCell('${productTickets[tableIndex - 1].color}' == 'null' ? '' : '${productTickets[tableIndex - 1].color}', {'Color': 'color'}, tableIndex - 1),
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
