import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../data/preferences/preferences.dart';

class PrintHelper {
  String mac = 'none';
  static bool connected = false;

  void _getPreferences() async {
    mac = await Preferences.getValue("mac");
    if (mac == 'none') {
      mac = 'NO DISPONIBLE';
    }
  }

  Future<Map<String, bool>> connect() async {
    Map<String, bool> result = {};
    connected = false;

    if (mac == 'none') {
      _getPreferences();
    } else if (mac != "NO DISPONIBLE") {
      await Preferences.setValue("mac", mac);
    } else {
      result.addAll(
          {'No se puede identificar la dirección mac del dispositivo.': false});
    }
    _getPreferences();

    if (mac != '') {
      getBluetooth();
      final bool resultBool =
          await PrintBluetoothThermal.connect(macPrinterAddress: mac);
      if (resultBool) {
        result.addAll({'Conexión exitosa.': true});
        connected = true;
      } else {
        result.addAll({'No se ha podido conectar con el dispositivo.': false});
      }
    } else {
      result.addAll(
          {'No se puede identificar la dirección mac del dispositivo.': false});
    }

    return result;
  }

  Future<Map<String, List<BluetoothInfo>>> getBluetooth() async {
    Map<String, List<BluetoothInfo>> result = {};
    final List<BluetoothInfo> listResult =
        await PrintBluetoothThermal.pairedBluetooths;

    if (listResult.isEmpty) {
      result.addAll({
        "Actualmente no hay dispositivos bluetooth conectados.": listResult
      });
    } else {
      result.addAll(
          {"Selecciona el dispositivo al que desea conectarse.": listResult});
    }
    return result;
  }

  void dialogConnect(BuildContext context, List<BluetoothInfo> items) {
    getBluetooth();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Colors.grey.withOpacity(0.3),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
            child: ListView.builder(
              itemCount: items.isNotEmpty ? items.length : 0,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () async {
                    String newMac = items[index].macAdress;
                    mac = newMac;
                    connect();
                    Navigator.pop(context);
                  },
                  title: Text('Name: ${items[index].name}'),
                  subtitle: Text("macAdress: ${items[index].macAdress}"),
                );
              },
            )),
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
      List<int> ticket = await createStructure(tickets: tickets);
      final resultPrint = await PrintBluetoothThermal.writeBytes(ticket);
      result = resultPrint ? 'Impresión exitosa.' : 'Error al imprimir.';
    } else {
      result = 'No se ha podido conectar con el dispositivo.';
    }

    return result;
  }

  Future<List<int>> createStructure(
      {@required required Map<String, dynamic> tickets}) async {
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    // var deliveryTicketNumberSplitted =
    //     tickets['deliveryTicketNumber'].split('-');

    bytes += generator.setGlobalFont(PosFontType.fontA);
    bytes += generator.reset();

    bytes += generator.text('Soc. Coop. "ASOVINO"',
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
    bytes += generator.text('Avda. Tres Cruces, 35 · Entpta. A',
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
    bytes += generator.text('Fax: 980 55 79 13',
        styles: const PosStyles(
          bold: true,
          codeTable: 'CP1252',
          align: PosAlign.center,
        ));
    bytes += generator.emptyLines(1);
    bytes += generator.hr();
    // bytes += generator.text(
    //     'Serie: ${deliveryTicketNumberSplitted[0]} -- No: ${deliveryTicketNumberSplitted[1]}',
    //     styles: const PosStyles(
    //         bold: true,
    //         width: PosTextSize.size2,
    //         height: PosTextSize.size2,
    //         align: PosAlign.left));
    // bytes += generator.hr();
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
    bytes += generator.hr();
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
    int i = 0;
    for (var x in tickets['number']) {
      bytes += generator.hr();
      bytes += generator.emptyLines(1);
      bytes += generator.row([
        PosColumn(
          text: 'No',
          width: 1,
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
          width: 2,
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
          width: 4,
          styles: const PosStyles(
            bold: true,
            width: PosTextSize.size2,
            height: PosTextSize.size2,
            codeTable: 'CP1252',
            align: PosAlign.center,
          ),
        ),
        PosColumn(
          text: 'Color',
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
      bytes += generator.emptyLines(1);
      bytes += generator.row([
        PosColumn(
          text: '$x',
          width: 1,
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
          width: 2,
          styles: const PosStyles(
            width: PosTextSize.size2,
            height: PosTextSize.size2,
            codeTable: 'CP1252',
            align: PosAlign.center,
          ),
        ),
        PosColumn(
          text: '${tickets['performance'][i]}',
          width: 4,
          styles: const PosStyles(
            width: PosTextSize.size2,
            height: PosTextSize.size2,
            codeTable: 'CP1252',
            align: PosAlign.center,
          ),
        ),
        PosColumn(
          text: '${tickets['color'][i]}',
          width: 2,
          styles: const PosStyles(
            width: PosTextSize.size2,
            height: PosTextSize.size2,
            codeTable: 'CP1252',
            align: PosAlign.center,
          ),
        ),
      ]);
      bytes += generator.emptyLines(1);
      bytes += generator.hr();
      i++;
    }
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
}
