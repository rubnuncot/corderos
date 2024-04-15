import 'dart:io';

import 'package:corderos_app/!helpers/!helpers.dart';
import 'package:corderos_app/data/!data.dart';
import 'package:corderos_app/data/database/!database.dart';
import 'package:corderos_app/data/database/entities/!!model_dao.dart';
import 'package:corderos_app/repository/data_conversion/!data_conversion.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reflectable/mirrors.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';

class DataFileReader {

  FtpDataTransfer ftpDataTransfer = FtpDataTransfer();

  Map<dynamic, String> files = {
    Driver(): 'conductores.txt',
    VehicleRegistration(): 'matriculas.txt',
    Rancher(): 'ganaderos.txt',
    Slaughterhouse(): 'mataderos.txt',
    Client(): 'clientes.txt',
    Product(): 'productos.txt',
    Classification(): 'clasifiaciones.txt',
    Performance(): 'rendimientos.txt'
  };

  Future<void> readFile() async {
    Directory directory = await getApplicationDocumentsDirectory();

    try {
      ftpDataTransfer.getFtpData();
      for (dynamic file in files.keys) {
        File storedFile = File("${directory.path}/${files[file]}");

        if (await storedFile.exists()) {
          String data = await storedFile.readAsString();
          List<String> lines = data.split(";");
          var classMirror = reflector.reflectType(
              file.runtimeType) as ClassMirror;

          Iterable<String> names = classMirror.invokeGetter(
              'names') as Iterable<String>;
          List<String> listNames = names.toList();

          Map<Symbol, String> constructor = {};
          int index = 0;
          for (var line in lines) {
            constructor.addAll({
              Symbol(listNames[index]): line
            });
          }

          var instanceMirror = classMirror.newInstance(
              'all', [], constructor) as ModelDao;

          instanceMirror.insert();
        } else {
          LogHelper.logger.d('File $storedFile does not exist');
        }
      }
    } catch (e) {
      LogHelper.logger.d('Error: $e');
    }


  }

  Future<void> executeApp() async {
    Directory directory = await getApplicationDocumentsDirectory();

    if (await ftpDataTransfer.checkVersion()) {
      try {
        ftpDataTransfer.downloadApk();
        if(await Permission.requestInstallPackages.request().isGranted) {
          await OpenFile.open('${directory.path}/app-release.apk');
        } else {
          LogHelper.logger.d('Permiso denegado');
        }
      }catch (e) {
        LogHelper.logger.d('Error en data_file_reader: $e');
      }
    }
  }
}
