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

    Map<String, List> subData = {};

    for(var line in data.keys){
      if(line.contains('product')){
        subData.addAll({line : data[line]!});
      }
    }

    for (String key in data.keys) {
      String dataString;
      String fileName = key;

      if(!key.contains('product')){
        for(var data in data[key]!){
          var idProduct = data.idProduct;

        }
      }

      /*
      ! dataKey --> es una lista de objetos
      ! Se recorre esa lista de objetos y se añaden a otra lista ejecutando
      ! el toString de cada uno de esos modelos. Por úlitmo se juntan todos
      ! esos strings separandolos por saltos de línea.
       */
      dataString = data[key]!.map((object) => object.toString()).toList().join('\n');

      File file = File('${dir.path}/$fileName');
      file.writeAsStringSync(dataString);
      files.add(file);
    }
    return files;
  }
}
