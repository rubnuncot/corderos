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
  ///
  ///
  ///
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
    for (String key in data.keys) {
      String dataString;
      String fileName = key;

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
