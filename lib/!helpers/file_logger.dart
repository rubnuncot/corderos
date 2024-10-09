import 'dart:io';

import 'package:corderos_app/!helpers/!helpers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class FileLogger {
  Future<String> _getFilePath() async {
    Directory directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/log.txt';
  }

  Future<String> _getExternalFilePath() async {
    requestStoragePermission();
    Directory? directory = await getExternalStorageDirectory();
    String downloadsPath = directory!.path;
    return '$downloadsPath/log.txt';
  }

  Future<void> writeToFile(String data) async {
    try {
      final path = await _getExternalFilePath();
      final file = File(path);

      await file.writeAsString(data, mode: FileMode.append);
      LogHelper.logger.d('Datos guardados en $path');
    } catch (e) {
      LogHelper.logger.d('Error al escribir en el archivo: $e');
    }
  }

  void handleError(Object error, {String? message, String? file, String? line}) {
    final errorData = 'Error on file $file: $error}\n$message';
    writeToFile(errorData);
  }

  Future<void> shareLogFile() async {
    final path = await _getFilePath();

    Share.shareXFiles([XFile(path)]);
  }

  Future<void> requestStoragePermission() async {
    var status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      LogHelper.logger.d('Permiso concedido');
    } else {
      LogHelper.logger.d('Permiso denegado');
    }
  }
}