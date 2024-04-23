import 'dart:io';

import 'package:corderos_app/repository/data_conversion/!data_conversion.dart';
import 'package:path_provider/path_provider.dart';

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
    Directory dir = await getApplicationDocumentsDirectory();
    Map<String, List> data = await repository
        .getFTPData(); //! Key: productticket.txt | value: ProductTicket()

    Map<String, List> productData = {};
    Map<String, List> restData = {};

    for(var line in data.keys){
      if(line.contains('product')){
        productData.addAll({line : data[line]!});
      } else {
        restData.addAll({line : data[line]!});
      }
    }

    for(var key in restData.keys){
      var dataString = "";
      var fileName = key;

      if(key.contains('delivery')){
        dataString = _getDataString(restData, key, dataString, productData, 'product_deliverynote.txt');
      } else {
        dataString = _getDataString(restData, key, dataString, productData, 'product_ticket.txt');
      }

      File file = File('${dir.path}/$fileName');
      file.writeAsStringSync(dataString);
      files.add(file);
    }
    return files;
  }

  String _getDataString(Map<String, List<dynamic>> restData, String key, String dataString, Map<String, List<dynamic>> productData, String productTicketKey) {
    for(var data in restData[key]!){
      dataString += 'C\t${data.toString()}\n';
      for(var product in productData[productTicketKey]!){
        if(product.id == data.id){
          dataString += 'L\t${product.toString()}\n';
        }
      }
    }
    return dataString;
  }
}
