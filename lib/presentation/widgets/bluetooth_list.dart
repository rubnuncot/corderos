import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:corderos_app/!helpers/bluetooth_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

@immutable
class BluetoothList extends StatefulWidget {
  const BluetoothList({super.key});

  @override
  State<BluetoothList> createState() => _BluetoothListState();
}

class _BluetoothListState extends State<BluetoothList> {
  final BluetoothHelper bluetoothHelper = BluetoothHelper();
  List<ScanResult>? scanList = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Future<void> getBluetoothList() async {
      scanList = await bluetoothHelper.startScanning();
    }

    return FutureBuilder(
      future: getBluetoothList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError) {
          return SizedBox(
            width: size.width * 0.8,
            height: size.height * 0.7,
            child: ListView.builder(
              itemCount: scanList!.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.bluetooth,
                        color: Theme.of(context).primaryColor),
                    title: Text(
                        scanList![index].device.advName,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(scanList![index].device.remoteId.toString()),
                    onTap: () async {
                      await bluetoothHelper.connectToDevice(scanList![index].device);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          content: AwesomeSnackbarContent(
                            title: "¡Conectado!",
                            message:
                                "Dispositivo ${scanList![index].device.advName} conectado.",
                            contentType: ContentType.success,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
