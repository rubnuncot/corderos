import 'dart:io';

import 'package:corderos_app/!helpers/!helpers.dart';
import 'package:corderos_app/data/!data.dart';
import 'package:corderos_app/data/database/!database.dart';
import 'package:corderos_app/data/database/entities/!!model_dao.dart';
import 'package:corderos_app/data/preferences/preferences.dart';
import 'package:corderos_app/repository/data_conversion/!data_conversion.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reflectable/mirrors.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';

/// DataFileReader --> clase que gestiona la lectura de ficheros procedentes
/// del directorio del FTP, y la descargas del Apk.

class DataFileReader {
  Preferences preferences = Preferences();

  FtpDataTransfer ftpDataTransfer = FtpDataTransfer();

  Map<dynamic, String> files = {
    Driver(): 'conductores.txt',
    VehicleRegistration(): 'matriculas.txt',
    Rancher(): 'ganaderos.txt',
    Slaughterhouse(): 'mataderos.txt',
    Client(): 'clientes.txt',
    Product(): 'productos.txt',
    Classification(): 'clasificaciones.txt',
    Performance(): 'rendimientos.txt'
  };

  final separator = ';';

  dynamic lasPreferencesId = [];

  /// ### `readFile`
  ///
  /// TODO:
  ///
  /// ----------------------------------------------------------------
  /// **Parámetros:**
  /// - TODO:
  ///
  /// **Retorno:**
  /// - TODO:
  ///
  /// **Resumen del Funcionamiento:**
  ///
  /// TODO:
  ///
  /// ----------------------------------------------------------------
  ///
  /// **Ejemplo de Uso:**
  ///
  /// ```dart
  /// TODO:
  /// ```
  Future<void> readFile() async {
    Directory directory = await getApplicationDocumentsDirectory();

    try {
      await ftpDataTransfer.getFtpData();
      for (dynamic file in files.keys) {
        await _processFile(directory, file);
      }
    } catch (e) {
      LogHelper.logger.d('Error: $e');
    }
  }

  Future<void> _processFile(Directory directory, dynamic file) async {
    File storedFile = File("${directory.path}/${files[file]}");

    if (await storedFile.exists()) {
      String data = await storedFile.readAsString();
      List<String> lines = data.split("\n");

      var classMirror = reflector.reflectType(file.runtimeType) as ClassMirror;
      Iterable<String> names = classMirror.invokeGetter('names') as Iterable<String>;
      Map<String, String> fields = classMirror.invokeGetter('fields') as Map<String, String>;
      List<String> listNames = names.toList();

      var instanceMirrorEmptyObject = classMirror.newInstance('', []) as ModelDao;
      var tableName = instanceMirrorEmptyObject.getTableName(instanceMirrorEmptyObject);

      await instanceMirrorEmptyObject.truncate<ModelDao>();

      int lastId = await Preferences.getValue('last_${tableName}_id');
      List<ModelDao> daoList = await _processLines(lines, listNames, fields, classMirror, lastId);

      await instanceMirrorEmptyObject.listInsert(daoList);
      await Preferences.setValue('last_${tableName}_id', lastId);
    } else {
      LogHelper.logger.d('File $storedFile does not exist');
    }
  }

  Future<List<ModelDao>> _processLines(
      List<String> lines,
      List<String> listNames,
      Map<String, String> fields,
      ClassMirror classMirror,
      int lastId) async {
    List<ModelDao> daoList = [];

    for (var line in lines) {
      if (line.isNotEmpty) {
        var instanceMirror = await _processLine(line, listNames, fields, classMirror, lastId);
        if (instanceMirror != null && !await instanceMirror.existsInDatabase()) {
          daoList.add(instanceMirror);
        }
      }
    }

    return daoList;
  }

  Future<ModelDao?> _processLine(
      String line,
      List<String> listNames,
      Map<String, String> fields,
      ClassMirror classMirror,
      int lastId) async {
    Map<Symbol, dynamic> constructor = {};
    List<String> lineParts = line.split(separator);

    if (lineParts.length == listNames.length - 1) {
      int index = 1;
      for (var value in lineParts) {
        if (listNames[index] != 'id') {
          constructor[Symbol(listNames[index])] = _castElements(listNames[index], value, fields);
        }
        index++;
      }
      lastId++;
      LogHelper.logger.d(constructor);
      return classMirror.newInstance('all', [], constructor) as ModelDao;
    }

    return null;
  }


  /// ### `executeApp`

  Future<void> executeApp() async {
    Directory directory = await getApplicationDocumentsDirectory();

    if (await ftpDataTransfer.checkVersion()) {
      try {
        ftpDataTransfer.downloadApk();
        if (await Permission.requestInstallPackages.request().isGranted) {
          await OpenFile.open('${directory.path}/app-release.apk');
        } else {
          LogHelper.logger.d('Permiso denegado');
        }
      } catch (e) {
        LogHelper.logger.d('Error en data_file_reader: $e');
      }
    }
  }

  /// Método encargado de ejecutar la app (app-release.apk)
  ///
  /// ----------------------------------------------------------------
  ///
  /// **Resumen del Funcionamiento:**
  ///
  /// En primer lugar, almacena en una variable el directorio de
  /// documentos de la aplicación. Comprueba la version de la app a través
  /// del método [checkVersion()] y mediante un try catch, ejecuta el método
  /// [downloadApk()] para descargar el APK. Comprueba que se han aceptado
  /// los permisos para instalar paquetes y abre la app (app-release.apk).
  /// En caso de error, muestra un log con su respectivo mensaje.
  ///
  /// ----------------------------------------------------------------
  ///
  /// **Ejemplo de Uso:**
  ///
  /// ```dart
  /// DataFileReader dataFileReader = DataFileReader();
  /// dataFileReader.executeApp();
  /// ```
  ///Sacar el valor de fields de cada uno de los elementos y pasarle lowerCase
  ///Si contiene int que haga un casteo a int. bool, date. double
  dynamic _castElements(String key, dynamic value, Map<String, String> fields) {
    //! elementName -> 'id', 'nif'...
    //! fields -> 'id': constants.bigint -> String
    List<String> types = [
      'int',
      'bool',
      'double',
      'date',
      'datetime',
    ];

    for (var type in types) {
      if (fields[key]!.toLowerCase().contains(type)) {
        switch (type) {
          case 'int':
            return int.parse(value);
          case 'bool':
            return bool.parse(value);
          case 'double':
            return double.parse(value);
          case 'date':
            return DateTime.parse(value);
          case 'datetime':
            return DateTime.parse(value);
        }
      } else {
        return value;
      }
    }
  }
}
