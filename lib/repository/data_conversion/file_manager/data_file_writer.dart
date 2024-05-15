import 'dart:io';

import 'package:corderos_app/repository/data_conversion/!data_conversion.dart';
import 'package:jiffy/jiffy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reflectable/reflectable.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';

import '../../!repository.dart';
import '../../models/!!model_base.dart';

class DataFileWriter {
  //Instancia del repositorio de la base de datos para acceder a sus métodos.
  DatabaseRepository repository = DatabaseRepository();

  /// ### `writeFile`
  ///
  /// Método encargado de crear y escribir los archivos.txt a partir
  /// de la información que obtiene de la FTP.
  ///
  /// ----------------------------------------------------------------
  ///
  /// **Retorno:**
  /// - Devuelve una lista de archivos de tipo File.
  ///
  /// **Resumen del Funcionamiento:**
  /// ! Hay que obtener las listas que vienen e identificarlas para generar las
  /// ! lineas de cada uno de los archivos.
  ///
  /// ! Las keys que contienen product en sus nombres, son las listas de líneas.
  ///
  /// ! Un ejemplo de lo que tendría que quedar.
  ///
  /// ! C lo que sea siendo la línea de la cabecera.
  /// ! L lo que sea la línea de los datos que coincidan con el idProducto y
  /// ! el id de la tabla que sea...
  ///
  /// ? Borrar las líneas en rojo que no son documentación.
  /// ----------------------------------------------------------------
  ///
  /// **Ejemplo de Uso:**
  ///
  /// ```dart
  /// List<File> files = await dataFileWriter.writeFile();
  /// ```
  Future<List<File>> writeFile() async {
    List<File> files = [];
    String hoy =
    Jiffy.parse(DateTime.now().toString()).format(pattern: 'dd-MM-yyyy HH:mm:ss');
    Directory dir = await getApplicationDocumentsDirectory();
    Map<String, List> data = await repository
        .getFTPData(); //! Key: productticket.txt | value: ProductTicket()

    Map<String, List> productData = {};
    Map<String, List> restData = {};

    for (var line in data.keys) {
      if (line.contains('product')) {
        productData.addAll({line: data[line]!});
      } else {
        restData.addAll({line: data[line]!});
      }
    }

    for (var key in restData.keys) {
      var dataString = "";
      var fileName = key;

      if (key.contains('delivery')) {
        dataString = await _getDataString(
            restData, key, dataString, productData, 'product_deliverynote.txt');
      } else {
        dataString = await _getDataString(
            restData, key, dataString, productData, 'product_ticket.txt');
      }

      File file = File('${dir.path}/$hoy$fileName');
      file.writeAsStringSync(dataString);
      files.add(file);
    }
    return files;
  }

  Future <String> _getDataString(
      Map<String, List<dynamic>> restData,
      String key,
      String dataString,
      Map<String, List<dynamic>> productData,
      String productTicketKey) async {
    Map<String, dynamic> models = {
      'product_ticket.txt': ProductTicketModel,
      'product_deliverynote.txt': ProductDeliveryNoteModel,
      'deliveryticket.txt': DeliveryTicketModel,
      'clientdeliverynote.txt': ClientDeliveryNoteModel,
    };

    for (var data in restData[key]!) {
      var classMirror = reflector.reflectType(models[key]) as ClassMirror;

      var instanceMirrorRestData =
          classMirror.newInstance('', []) as ModelBase;
      await instanceMirrorRestData.fromEntity(data);

      dataString += 'C\t${instanceMirrorRestData.toString()}';
      for (var product in productData[productTicketKey]!) {
        var classMirror =
            reflector.reflectType(models[productTicketKey]) as ClassMirror;

        var instanceMirrorProductData =
            classMirror.newInstance('', []) as ModelBase;

        await instanceMirrorProductData.fromEntity(product);

        if (product.id == data.id) {
          dataString += '\tL\t${instanceMirrorProductData.toString()}\n';
        }
      }
    }

    return dataString;
  }
}
