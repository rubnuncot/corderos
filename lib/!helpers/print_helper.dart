import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:corderos_app/!helpers/bluetooth_helper.dart';
import 'package:corderos_app/!helpers/printer_enum.dart';
import 'package:meta/meta.dart';

class PrintHelper {
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  BluetoothHelper bluetoothHelper = BluetoothHelper();

  void _ticketStructure({
    @required required String date,
    @required required String vehicleRegistrationNum,
    @required required String driver,
    @required required String slaughterHouse,
    @required required String rancher,
    @required required String deliveryTicketNumber,
    @required required String product,
    @required required String number,
    @required required String classification,
    @required required String performance,
    @required required String kilograms,
    @required required String color,
  }) async {
    var connected = await bluetoothHelper.isConnected();
    if(connected) {
      printer.printNewLine();

      printer.printLeftRight(date, deliveryTicketNumber, Size.boldMedium.val);
      printer.printNewLine();
      printer.printLeftRight(driver, vehicleRegistrationNum, Size.medium.val);
      printer.printNewLine();
      printer.printLeftRight(slaughterHouse, rancher, Size.medium.val);
      printer.printNewLine();
      printer.printLeftRight(product, number, Size.medium.val);
      printer.printNewLine();
      printer.printLeftRight(classification, performance, Size.medium.val);
      printer.printNewLine();
      printer.printLeftRight(kilograms, color, Size.medium.val);
      printer.printNewLine();
      printer.printNewLine();
      printer.paperCut();
    }
  }

  //! Función --> impresión de ticket.
  void printTicket() async {

    _ticketStructure(
      date: "Fecha: 12/12/2021",
      vehicleRegistrationNum: "1234567890",
      driver: "Driver",
      slaughterHouse: "Slaughter House",
      rancher: "Rancher",
      deliveryTicketNumber: "Delivery Ticket Number",
      product: "Product",
      number: "Number",
      classification: "Classification",
      performance: "Performance",
      kilograms: "Kilograms",
      color: "Color",
    );
  }
}