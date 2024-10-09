import 'package:corderos_app/!helpers/!helpers.dart';
import 'package:corderos_app/repository/data_conversion/!data_conversion.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:sqflite_simple_dao_backend/database/database/sql_builder.dart';

import '../data/!data.dart';
import '../data/preferences/preferences.dart';
import '../repository/!repository.dart';
import 'file_logger.dart';

class PrintHelper {
  String mac = 'none';
  static bool connected = false;
  Map<String, double> totalWeightNotConsolidated = {};
  Map<String, int> totalAnimalsNotConsolidated = {};
  Map<String, int> totalLosses = {};
  Map<String, double> totalLossesWeight = {};

  Future<void> _getPreferences() async {
    mac = await Preferences.getValue("mac");
    if (mac == 'none' || mac.isEmpty) {
      mac = 'NO DISPONIBLE';
    }
  }

  Future<Map<String, bool>> connect() async {
    Map<String, bool> result = {};
    connected = false;

    try {
      if (mac == 'none') {
        await _getPreferences();
      }

      if (mac != "NO DISPONIBLE" && mac.isNotEmpty) {
        await Preferences.setValue("mac", mac);
      } else {
        LogHelper.logger
            .e('No se puede identificar la dirección mac del dispositivo.');
        result.addAll(
          {'No se puede identificar la dirección mac del dispositivo.': false},
        );
      }

      if (mac == '' || mac == 'NO DISPONIBLE') {
        await getBluetooth();
        LogHelper.logger.e('No se ha encontrado ningún dispositivo Bluetooth.');
        result.addAll(
          {'No se ha encontrado ningún dispositivo Bluetooth.': false},
        );
        return result;
      }

      final bool resultBool =
      await PrintBluetoothThermal.connect(macPrinterAddress: mac);
      if (resultBool) {
        result.addAll({'Conexión exitosa.': true});
        connected = true;
      } else {
        await Preferences.setValue('mac', '');
        LogHelper.logger.e('No se ha podido conectar con el dispositivo.');

        result.addAll({'No se ha podido conectar con el dispositivo.': false});
      }
    } catch(e) {
      FileLogger fileLogger = FileLogger();

      fileLogger.handleError(e, file: 'print_helper.dart');
    }

    return result;
  }

  Future<Map<String, List<BluetoothInfo>>> getBluetooth() async {
    final List<BluetoothInfo> listResult =
        await PrintBluetoothThermal.pairedBluetooths;
    return listResult.isEmpty
        ? {"Actualmente no hay dispositivos bluetooth conectados.": []}
        : {"Selecciona el dispositivo al que desea conectarse.": listResult};
  }

  void dialogConnect(BuildContext context, List<BluetoothInfo> items) {
    getBluetooth();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey.withOpacity(0.3),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.grey.withOpacity(0.5)),
                  ),
                  onTap: () {
                    mac = items[index].macAdress;
                    connect();
                    Navigator.pop(context);
                  },
                  title: Text('Name: ${items[index].name}'),
                  subtitle: Text("MAC Address: ${items[index].macAdress}"),
                  hoverColor:
                      Colors.blue.withOpacity(0.2), // Cambio visual al tocar
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<String> print(BuildContext context, List<BluetoothInfo> items,
      {@required required Map<String, dynamic> tickets}) async {
    String result = '';
    if (!connected) {
      dialogConnect(context, items);
    }
    bool conexionStatus = await PrintBluetoothThermal.connectionStatus;
    if (conexionStatus) {
      try {
        List<int> ticket = await createStructure(tickets: tickets);
        final resultPrint = await PrintBluetoothThermal.writeBytes(ticket);
        result = resultPrint ? 'Impresión exitosa.' : 'Error al imprimir.';
      } catch (e) {
        LogHelper.logger.d(e);
        FileLogger fileLogger = FileLogger();

        fileLogger.handleError(e, file: 'home_bloc.dart');
        result = 'Error al imprimir. $e';
      }
    } else {
      result = 'No se ha podido conectar con el dispositivo.';
    }

    return result;
  }

  Future<String> printResume(
      BuildContext context, List<BluetoothInfo> items) async {
    String result = '';
    if (!connected) {
      dialogConnect(context, items);
    }
    bool conexionStatus = await PrintBluetoothThermal.connectionStatus;
    if (conexionStatus) {
      List<int> ticket = await createResume();
      final resultPrint = await PrintBluetoothThermal.writeBytes(ticket);
      result = resultPrint ? 'Impresión exitosa.' : 'Error al imprimir.';
    } else {
      result = 'No se ha podido conectar con el dispositivo.';
    }

    return result;
  }

  Future<String> printExit(
      BuildContext context,
      List<BluetoothInfo> items,
      List<DeliveryTicketModel> ticketModels,
      List<ProductTicketModel> productTicketModels,
      Client client) async {
    String result = '';
    if (!connected) {
      dialogConnect(context, items);
    }
    bool conexionStatus = await PrintBluetoothThermal.connectionStatus;
    if (conexionStatus) {
      List<int> ticket =
          await _buildTicketOutBody(ticketModels, productTicketModels, client);
      final resultPrint = await PrintBluetoothThermal.writeBytes(ticket);
      result = resultPrint ? 'Impresión exitosa.' : 'Error al imprimir.';
    } else {
      result = 'No se ha podido conectar con el dispositivo.';
    }

    return result;
  }

  Future<List<int>> createResume() async {
    try {
      List<int> bytes = [];
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm80, profile);
      DeliveryTicket deliveryTicket =
          await DeliveryTicket().selectLast<DeliveryTicket>();
      List<ProductTicket> products = await ProductTicket()
          .getData<ProductTicket>(
              where: ['idTicket', SqlBuilder.constOperators['in']!],
              subSelect: SqlBuilder()
                  .querySelect(fields: ['id'])
                  .queryFrom(
                      table: DeliveryTicket().getTableName(deliveryTicket))
                  .queryWhere(conditions: [
                    'date',
                    SqlBuilder.constOperators['like']!,
                    "'%${deliveryTicket.date!.toString().split(' ')[0]}%'"
                  ]),
              orderBy: ['idProduct', 'ASC']);

      bytes += generator.setGlobalFont(PosFontType.fontA);
      bytes += generator.reset();

      bytes += generator.text('Asovino Sociedad Cooperativa',
          styles: const PosStyles(
              bold: true,
              width: PosTextSize.size2,
              height: PosTextSize.size2,
              align: PosAlign.center));

      bytes += generator.emptyLines(1);
      Map<int, double> productsWeight = {};
      Map<int, int> productsNumAnimals = {};
      for (var product in products) {
        productsWeight[product.idProduct!] =
            (productsWeight[product.idProduct!] ?? 0) + product.weight!;
        productsNumAnimals[product.idProduct!] =
            (productsNumAnimals[product.idProduct!] ?? 0) + product.numAnimals!;
      }

      bytes += generator.emptyLines(3);

      for (var product in productsNumAnimals.keys) {
        Product p = await DatabaseRepository.getEntityById(Product(), product);
        bytes += generator.text(
          '${p.name}:${productsWeight[product]} Kgs.|${productsNumAnimals[product]} Animales',
          styles: const PosStyles(
            bold: true,
            underline: true,
            fontType: PosFontType.fontA,
            width: PosTextSize.size2,
            height: PosTextSize.size2,
            align: PosAlign.left,
          ),
        );
        bytes += generator.emptyLines(1);
      }
      bytes += generator.emptyLines(3);

      return bytes;
    } catch (e) {
      LogHelper.logger.d(e);
      FileLogger fileLogger = FileLogger();

      fileLogger.handleError(e, file: 'home_bloc.dart');
      return [];
    }
  }

  Future<List<int>> createStructure(
      {@required required Map<String, dynamic> tickets}) async {
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    var deliveryTicketNumberSplitted =
        tickets['deliveryTicketNumber'].split('-');

    bytes += generator.setGlobalFont(PosFontType.fontA);
    bytes += generator.reset();

    bytes += generator.text('Asovino Sociedad Cooperativa',
        styles: const PosStyles(
            bold: true,
            width: PosTextSize.size2,
            height: PosTextSize.size2,
            align: PosAlign.center));
    bytes += generator.emptyLines(1);
    bytes += generator.text('C.I.F: F-49104938',
        styles: const PosStyles(
          bold: true,
          align: PosAlign.center,
        ));
    bytes += generator.text('Avda. Tres Cruces, 35 · Entpta. A, Zamora',
        styles: const PosStyles(
          bold: true,
          codeTable: 'CP1252',
          align: PosAlign.center,
        ));
    bytes += generator.text('Tel.: 980 55 74 16',
        styles: const PosStyles(
          bold: true,
          codeTable: 'CP1252',
          align: PosAlign.center,
        ));
    bytes += generator.emptyLines(1);
    bytes += generator.hr();

    bytes += generator.text('Serie: ${deliveryTicketNumberSplitted[0]}',
        styles: const PosStyles(
          bold: true,
          codeTable: 'CP1252',
          align: PosAlign.center,
        ));
    bytes += generator.text('Número: ${deliveryTicketNumberSplitted[1]}',
        styles: const PosStyles(
          bold: true,
          codeTable: 'CP1252',
          align: PosAlign.center,
        ));
    bytes += generator.emptyLines(1);
    bytes += generator.hr();

    bytes += generator.text(
      'Conductor: ${tickets['driver']}',
      styles: const PosStyles(
        bold: true,
        underline: true,
        fontType: PosFontType.fontA,
        width: PosTextSize.size2,
        height: PosTextSize.size2,
        align: PosAlign.left,
      ),
    );
    bytes += generator.text(
      'Vehiculo: ${tickets['vehicleRegistrationNum']}',
      styles: const PosStyles(
        bold: true,
        underline: true,
        fontType: PosFontType.fontA,
        width: PosTextSize.size2,
        height: PosTextSize.size2,
        align: PosAlign.left,
      ),
    );
    bytes += generator.text(
      'Ganadero: ${tickets['rancher']}',
      styles: const PosStyles(
        bold: true,
        underline: true,
        fontType: PosFontType.fontA,
        width: PosTextSize.size2,
        height: PosTextSize.size2,
        align: PosAlign.left,
      ),
    );
    bytes += generator.text(
      'Matadero: ${tickets['slaughterHouse']}',
      styles: const PosStyles(
        bold: true,
        underline: true,
        fontType: PosFontType.fontA,
        width: PosTextSize.size2,
        height: PosTextSize.size2,
        align: PosAlign.left,
      ),
    );

    bytes += generator.emptyLines(1);
    bytes += generator.text(
      'Producto: ${tickets['product']}',
      styles: const PosStyles(
        bold: true,
        underline: true,
        fontType: PosFontType.fontA,
        width: PosTextSize.size2,
        height: PosTextSize.size2,
        align: PosAlign.center,
      ),
    );
    bytes += generator.emptyLines(1);
    bytes += generator.hr();

    // Header for the items
    bytes += generator.row([
      PosColumn(
        text: '',
        width: 2,
        styles: const PosStyles(
          bold: true,
          width: PosTextSize.size2,
          height: PosTextSize.size2,
          align: PosAlign.center,
        ),
      ),
      PosColumn(
        text: 'No',
        width: 2,
        styles: const PosStyles(
          bold: true,
          width: PosTextSize.size2,
          height: PosTextSize.size2,
          align: PosAlign.center,
        ),
      ),
      PosColumn(
        text: 'Clase',
        width: 3,
        styles: const PosStyles(
          bold: true,
          width: PosTextSize.size2,
          height: PosTextSize.size2,
          codeTable: 'CP1252',
          align: PosAlign.center,
        ),
      ),
      PosColumn(
        text: 'Kgs.',
        width: 3,
        styles: const PosStyles(
          bold: true,
          width: PosTextSize.size2,
          height: PosTextSize.size2,
          codeTable: 'CP1252',
          align: PosAlign.center,
        ),
      ),
      PosColumn(
        text: 'Rendimiento',
        width: 2,
        styles: const PosStyles(
          bold: true,
          width: PosTextSize.size2,
          height: PosTextSize.size2,
          codeTable: 'CP1252',
          align: PosAlign.center,
        ),
      ),
    ]);

    bytes += generator.text(
      '-----------------------------',
      styles: const PosStyles(
        bold: true,
        underline: true,
        fontType: PosFontType.fontA,
        width: PosTextSize.size2,
        height: PosTextSize.size2,
        align: PosAlign.center,
      ),
    );

    int i = 0;
    for (var x in tickets['number']) {
      bytes += generator.row([
        PosColumn(
          text: '',
          width: 2,
          styles: const PosStyles(
            width: PosTextSize.size2,
            height: PosTextSize.size2,
            align: PosAlign.center,
          ),
        ),
        PosColumn(
          text: '$x',
          width: 2,
          styles: const PosStyles(
            width: PosTextSize.size2,
            height: PosTextSize.size2,
            align: PosAlign.center,
          ),
        ),
        PosColumn(
          text: '${tickets['classification'][i]}',
          width: 3,
          styles: const PosStyles(
            width: PosTextSize.size2,
            height: PosTextSize.size2,
            codeTable: 'CP1252',
            align: PosAlign.center,
          ),
        ),
        PosColumn(
          text: '${tickets['kilograms'][i]}',
          width: 3,
          styles: const PosStyles(
            width: PosTextSize.size2,
            height: PosTextSize.size2,
            codeTable: 'CP1252',
            align: PosAlign.center,
          ),
        ),
        PosColumn(
          text: '${tickets['performance'][i]}',
          width: 2,
          styles: const PosStyles(
            width: PosTextSize.size2,
            height: PosTextSize.size2,
            codeTable: 'CP1252',
            align: PosAlign.center,
          ),
        ),
      ]);

      if (tickets['losses'] != null &&
          tickets['losses'][i] != null &&
          tickets['losses'][i] > 0) {
        bytes += generator.text(
          '\tBajas: ${tickets['losses'][i]} -> ${tickets['weightLosses'][i]} kgs.',
          styles: const PosStyles(
            bold: true,
            underline: true,
            fontType: PosFontType.fontA,
            width: PosTextSize.size2,
            height: PosTextSize.size2,
            align: PosAlign.center,
          ),
        );
      }
      bytes += generator.text(
        '-----------------------------',
        styles: const PosStyles(
          bold: true,
          underline: true,
          fontType: PosFontType.fontA,
          width: PosTextSize.size2,
          height: PosTextSize.size2,
          align: PosAlign.center,
        ),
      );

      i++;
    }
    bytes += generator.hr();
    bytes += generator.text(
        'Fecha: ${Jiffy.parse(tickets['date']).format(pattern: 'dd/MM/yyyy')}',
        styles: const PosStyles(
          bold: true,
          fontType: PosFontType.fontB,
          width: PosTextSize.size2,
          height: PosTextSize.size2,
          align: PosAlign.center,
        ));
    bytes += generator.emptyLines(3);
    bytes += generator.feed(2);
    return bytes;
  }

  Future<List<int>> _buildTicketOutBody(List<DeliveryTicketModel> ticketModels,
      List<ProductTicketModel> productTicketModels, Client client) async {
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    bytes += generator.setGlobalFont(PosFontType.fontA);
    bytes += generator.reset();

    bytes += await _buildProductTicketsString(
        ticketModels, productTicketModels, generator, profile, bytes, client);

    bytes += generator.text('-----------------------------',
        styles: const PosStyles(
            bold: true,
            width: PosTextSize.size2,
            height: PosTextSize.size2,
            align: PosAlign.center));

    return bytes;
  }

  Future<List<int>> _buildTicketString(
      DeliveryTicketModel ticket,
      Generator generator,
      CapabilityProfile profile,
      List<int> bytes,
      Client client) async {
    bytes += generator.text('-----------------------------',
        styles: const PosStyles(
            bold: true,
            width: PosTextSize.size2,
            height: PosTextSize.size2,
            align: PosAlign.center));

    bytes += generator.text('Ticket',
        styles: const PosStyles(
            bold: true,
            width: PosTextSize.size2,
            height: PosTextSize.size2,
            align: PosAlign.center));

    bytes += generator.text('-----------------------------',
        styles: const PosStyles(
            bold: true,
            width: PosTextSize.size2,
            height: PosTextSize.size2,
            align: PosAlign.center));

    bytes += generator.text('Serie: ${ticket.deliveryTicket ?? 'N/A'}',
        styles: const PosStyles(
            bold: true,
            width: PosTextSize.size2,
            height: PosTextSize.size2,
            align: PosAlign.center));

    bytes += generator.text('Numero: ${ticket.number ?? 'N/A'}',
        styles: const PosStyles(
            bold: true,
            width: PosTextSize.size2,
            height: PosTextSize.size2,
            align: PosAlign.center));

    bytes += generator.text('Fecha: ${ticket.date?.toString() ?? 'N/A'}',
        styles: const PosStyles(
            bold: true,
            width: PosTextSize.size2,
            height: PosTextSize.size2,
            align: PosAlign.center));

    bytes += generator.text(
        'Conductor: ${CharacterModification.normalizeString(ticket.driver?.name ?? 'N/A')}, NIF: ${CharacterModification.normalizeString(ticket.driver?.nif ?? 'N/A')}',
        styles: const PosStyles(
            bold: true,
            width: PosTextSize.size2,
            height: PosTextSize.size2,
            align: PosAlign.center));

    bytes += generator.text(
        'Matricula: ${CharacterModification.normalizeString(ticket.vehicleRegistration?.vehicleRegistrationNum ?? 'N/A')}',
        styles: const PosStyles(
            bold: true,
            width: PosTextSize.size2,
            height: PosTextSize.size2,
            align: PosAlign.center));

    bytes += generator.text(
        'Matadero: ${CharacterModification.normalizeString(ticket.slaughterhouse?.name ?? 'N/A')}',
        styles: const PosStyles(
            bold: true,
            width: PosTextSize.size2,
            height: PosTextSize.size2,
            align: PosAlign.center));
    bytes += generator.text(
        'Matadero: ${CharacterModification.normalizeString(ticket.slaughterhouse?.name ?? 'N/A')}',
        styles: const PosStyles(
            bold: true,
            width: PosTextSize.size2,
            height: PosTextSize.size2,
            align: PosAlign.center));

    bytes += generator.text(
        CharacterModification.normalizeString(
            'Cliente: ${client.name}, NIF: ${client.nif}'),
        styles: const PosStyles(
            bold: true,
            width: PosTextSize.size2,
            height: PosTextSize.size2,
            align: PosAlign.center));

    bytes += generator.text('- - - - - - - - - - - - - - - - -',
        styles: const PosStyles(
            bold: true,
            width: PosTextSize.size2,
            height: PosTextSize.size2,
            align: PosAlign.center));

    return bytes;
  }

  Future<List<int>> _buildProductTicketsString(
      List<DeliveryTicketModel> ticketModels,
      List<ProductTicketModel> productTicketModels,
      Generator generator,
      CapabilityProfile profile,
      List<int> bytes,
      Client client) async {
    bytes += await _buildTicketString(
        ticketModels.first, generator, profile, bytes, client);

    Map<String, Map<String, Map<String, Tuple2<double, int>>>> productsMap =
        _consolidateProductData(productTicketModels);
    try {
      productsMap.forEach((product, classifications) {
        double totalWeightProduct = 0;
        int totalAnimalsProduct = 0;
        int totalLossesProduct = 0;
        double totalLossesWeightProduct = 0;

        bytes += generator.text('Producto: $product',
            styles: const PosStyles(
                bold: true,
                width: PosTextSize.size2,
                height: PosTextSize.size2,
                align: PosAlign.center));

        bytes += generator.text('-----------------------------',
            styles: const PosStyles(
                bold: true,
                width: PosTextSize.size2,
                height: PosTextSize.size2,
                align: PosAlign.center));
        bytes += generator.text('-----------------------------',
            styles: const PosStyles(
                bold: true,
                width: PosTextSize.size2,
                height: PosTextSize.size2,
                align: PosAlign.center));
        bytes += generator.row([
          PosColumn(
            text: 'No',
            width: 4,
            styles: const PosStyles(
              bold: true,
              width: PosTextSize.size2,
              height: PosTextSize.size2,
              align: PosAlign.center,
            ),
          ),
          PosColumn(
            text: 'Clase',
            width: 3,
            styles: const PosStyles(
              bold: true,
              width: PosTextSize.size2,
              height: PosTextSize.size2,
              codeTable: 'CP1252',
              align: PosAlign.center,
            ),
          ),
          PosColumn(
            text: 'Kgs.',
            width: 5,
            styles: const PosStyles(
              bold: true,
              width: PosTextSize.size2,
              height: PosTextSize.size2,
              codeTable: 'CP1252',
              align: PosAlign.center,
            ),
          ),
        ]);

        classifications.forEach((classification, performances) {
          double totalWeightClassification = 0;
          int totalAnimalsClassification = 0;

          performances.forEach((performance, data) {
            double totalWeight = data.item1;
            int totalAnimals = data.item2;
            totalWeightClassification += totalWeight;
            totalAnimalsClassification += totalAnimals;
          });

          totalWeightProduct += totalWeightClassification;
          totalAnimalsProduct += totalAnimalsClassification;
          totalLossesProduct += totalLosses[classification] ?? 0;
          totalLossesWeightProduct += totalLossesWeight[classification] ?? 0;

          bytes += generator.row([
            PosColumn(
              text: CharacterModification.normalizeString(
                  '$totalAnimalsClassification'),
              width: 4,
              styles: const PosStyles(
                bold: true,
                width: PosTextSize.size2,
                height: PosTextSize.size2,
                align: PosAlign.center,
              ),
            ),
            PosColumn(
              text: CharacterModification.normalizeString(classification),
              width: 3,
              styles: const PosStyles(
                bold: true,
                width: PosTextSize.size2,
                height: PosTextSize.size2,
                codeTable: 'CP1252',
                align: PosAlign.center,
              ),
            ),
            PosColumn(
              text: CharacterModification.normalizeString(
                  '$totalWeightClassification'),
              width: 5,
              styles: const PosStyles(
                bold: true,
                width: PosTextSize.size2,
                height: PosTextSize.size2,
                codeTable: 'CP1252',
                align: PosAlign.center,
              ),
            ),
          ]);

          if (totalLosses[classification] != null &&
              totalLosses[classification]! > 0) {
            bytes += generator.text(
                'Bajas: ${totalLosses[classification] ?? 0} -> ${totalLossesWeight[classification]!.toStringAsFixed(2)} kgs.',
                styles: const PosStyles(
                    bold: true,
                    width: PosTextSize.size2,
                    height: PosTextSize.size2,
                    align: PosAlign.center));
          }
        });

        bytes += generator.text('-----------------------------',
            styles: const PosStyles(
                bold: true,
                width: PosTextSize.size2,
                height: PosTextSize.size2,
                align: PosAlign.center));
        bytes += generator.text(
            CharacterModification.normalizeString(
                'Total Peso: $totalWeightProduct Kgs.'),
            styles: const PosStyles(
                bold: true,
                width: PosTextSize.size2,
                height: PosTextSize.size2,
                align: PosAlign.center));

        bytes += generator.text(
            CharacterModification.normalizeString(
                'Total Animales: $totalAnimalsProduct'),
            styles: const PosStyles(
                bold: true,
                width: PosTextSize.size2,
                height: PosTextSize.size2,
                align: PosAlign.center));

        if (totalLossesProduct > 0) {
          bytes += generator.text(
              CharacterModification.normalizeString(
                  'Total Bajas: $totalLossesProduct -> ${totalLossesWeightProduct.toStringAsFixed(2)} kgs.'),
              styles: const PosStyles(
                  bold: true,
                  width: PosTextSize.size2,
                  height: PosTextSize.size2,
                  align: PosAlign.center));
        }
        bytes += generator.text('- - - - - - - - - - - - - - - - -',
            styles: const PosStyles(
                bold: true,
                width: PosTextSize.size2,
                height: PosTextSize.size2,
                align: PosAlign.center));
      });
    } catch (e) {
      LogHelper.logger.d(e);
      FileLogger fileLogger = FileLogger();

      fileLogger.handleError(e, file: 'home_bloc.dart');
    }

    return bytes;
  }

  Map<String, Map<String, Map<String, Tuple2<double, int>>>>
      _consolidateProductData(List<ProductTicketModel> productTicketModels) {
    Map<String, Map<String, Map<String, Tuple2<double, int>>>> productsMap = {};

    try {
      for (var e in productTicketModels) {
        if (e.product != null &&
            e.classification != null &&
            e.performance != null &&
            e.weight != null &&
            e.numAnimals != null) {
          totalWeightNotConsolidated.putIfAbsent(
              e.classification!.name!, () => 0);
          totalWeightNotConsolidated[e.classification!.name!] =
              totalWeightNotConsolidated[e.classification!.name!]! + e.weight!;

          totalAnimalsNotConsolidated.putIfAbsent(
              e.classification!.name!, () => 0);
          totalAnimalsNotConsolidated[e.classification!.name!] =
              totalAnimalsNotConsolidated[e.classification!.name!]! +
                  e.numAnimals!;

          totalLosses.putIfAbsent(e.classification!.name!, () => 0);
          totalLosses[e.classification!.name!] =
              totalLosses[e.classification!.name!]! + (e.losses ?? 0);

          totalLossesWeight.putIfAbsent(e.classification!.name!, () => 0);
          totalLossesWeight[e.classification!.name!] =
              totalLossesWeight[e.classification!.name!]! +
                  (e.weightLosses ?? 0);

          String productKey = e.product!.name!;
          String classificationKey = e.classification!.name!;
          String performanceKey = e.performance!.performance.toString();

          productsMap.putIfAbsent(productKey, () => {});
          productsMap[productKey]!.putIfAbsent(classificationKey, () => {});
          productsMap[productKey]![classificationKey]!
              .putIfAbsent(performanceKey, () => Tuple2(0.0, 0));

          productsMap[productKey]![classificationKey]![performanceKey] = Tuple2(
            productsMap[productKey]![classificationKey]![performanceKey]!
                    .item1 +
                e.weight!,
            productsMap[productKey]![classificationKey]![performanceKey]!
                    .item2 +
                (e.numAnimals!),
          );
        }
      }
    } catch (e) {
      LogHelper.logger.d(e);
      FileLogger fileLogger = FileLogger();

      fileLogger.handleError(e, file: 'home_bloc.dart');
    }

    return productsMap;
  }
}

// Clase auxiliar para almacenar dos valores (peso y número de animales)
class Tuple2<T1, T2> {
  final T1 item1;
  final T2 item2;

  Tuple2(this.item1, this.item2);
}
