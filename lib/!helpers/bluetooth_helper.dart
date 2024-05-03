import 'package:corderos_app/!helpers/!helpers.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothHelper {
  Future<List<ScanResult>> startScanning() async {

    List<ScanResult> resultList = [];

    if (!await FlutterBluePlus.isSupported) {
      LogHelper.logger.d("Bluetooth no soportado en este dispositivo");
      return [];
    }

    FlutterBluePlus.adapterState.listen((state) {
      if (state == BluetoothAdapterState.on) {
        FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

        FlutterBluePlus.scanResults.listen((results) {
          for (ScanResult result in results) {
            resultList.add(result);
            LogHelper.logger.d(
                'Dispositivo encontrado: ${result.device.advName} [${result.device.remoteId}]');
          }
        });
      } else {
        LogHelper.logger.d("Bluetooth no está encendido o no autorizado");
      }
    });

     stopScanning();

    return resultList;
  }

  bool isConnected () {
    return FlutterBluePlus.connectedDevices.isNotEmpty;
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    device.connectionState.listen((state) {
      if (state == BluetoothConnectionState.connected) {
        LogHelper.logger.d("Conectado al dispositivo ${device.advName}");
      } else if (state == BluetoothConnectionState.disconnected) {
        LogHelper.logger.d("Desconectado del dispositivo ${device.advName}");
      }
    });

    try {
      await device.connect();
    } catch (e) {
      LogHelper.logger.d("Error al conectar con el dispositivo: $e");
    }
  }

  void stopScanning() {
    FlutterBluePlus.stopScan();
  }
}
