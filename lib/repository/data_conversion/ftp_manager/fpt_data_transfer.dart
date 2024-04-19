import 'dart:io';

import 'package:corderos_app/!helpers/!helpers.dart';
import 'package:corderos_app/repository/data_conversion/!data_conversion.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class FtpDataTransfer {
  ///Se almacena en una variable la instancia de la clase FTPConnector
  FtpConnector ftp = FtpConnector.instance;

  ///Lista de archivos .txt que se van a descargar
  List<String> files = [
    'conductores.txt',
    'matriculas.txt',
    'ganaderos.txt',
    'mataderos.txt',
    'clientes.txt',
    'productos.txt',
    'clasificaciones.txt',
    'rendimientos.txt'
  ];

  /// ### `checkVersion`
  ///
  /// Método que comprueba la versión actual de la aplicación comparando
  /// el valor de la versión actual con el valor de la versión que se almacena
  /// en el archivo version.txt.
  ///
  /// ----------------------------------------------------------------
  ///
  /// **Retorno:**
  /// - Devuelve true en caso de que la versión almacenada en el archivo version.txt
  /// sea mayor a la versión actual de la aplicación.
  ///
  ///
  /// **Resumen del Funcionamiento:**
  ///
  /// Se establece una conexión con el servidor FTP con valores por defecto
  /// y se comprueba el PackageInfo. Se almacena el archivo de version.txt en
  /// la variable version, se descarga el archivo, se lee y finalmente se cierra
  /// la conexión. Una vez cerrada, en caso de que la versión almacenada en el archivo
  /// version.txt sea mayor a la versión actual de la aplicación se retorna true, y sino
  /// se retorna false.
  ///
  /// ----------------------------------------------------------------
  ///
  /// **Ejemplo de Uso:**
  ///
  /// ```dart
  /// if (await ftpDataTransfer.checkVersion()) {
  /// ```
  Future<bool> checkVersion() async {
    FTPConnect ftpConnect = await ftp.ftpConnection(isDefault: true);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Directory directory = await getApplicationDocumentsDirectory();
    File version = File('${directory.path}/version.txt');
    await ftpConnect.downloadFile('version.txt', version);

    String versionFile = await version.readAsString();

    await ftp.closeConnection();

    return int.parse(versionFile) > int.parse(packageInfo.buildNumber);
  }

  /// ### `getFtpData`
  ///
  /// Método que obtiene los datos que se encuentran en los archivos .txt del FTP
  /// del path especificado.
  ///
  /// ----------------------------------------------------------------
  ///
  /// **Retorno:**
  /// - Devuelve true en caso de exito a la hora de descargar los archivos desde
  /// el FTP. En caso de que no existan archivos.txt en el path especificado, devuelve
  /// false junto con un mensaje de error en el log.
  ///
  /// **Resumen del Funcionamiento:**
  ///
  /// Se establece una conexión con el servidor FTP con el atributo [isDefault] = false.
  /// Se recorre la lista de archivos.txt a descargar y se almacenan en la variable
  /// [storedFile] el archivo de su respectiva ruta (${directory.path}/${file})) para
  /// posteriormente descargarse una a una. El directorio se obtiene a través del método
  /// [getApplicationDocumentsDirectory();] procedente del paquete pathProvider .En caso
  /// de completar el total de descargas, el método devuelve true. En caso de que no existan
  /// archivos.txt en el path devuelve false y un mensaje de error en el log.
  ///
  /// ----------------------------------------------------------------
  ///
  /// **Ejemplo de Uso:**
  ///
  /// ```dart
  /// await ftpDataTransfer.getFtpData();
  /// ```

  Future<bool> getFtpData() async {
    FTPConnect ftpConnect = await ftp.ftpConnection(isDefault: false);
    Directory directory = await getApplicationDocumentsDirectory();

    try {
      for (var file in files) {
        File storedFile = File('${directory.path}/$file');
        await ftpConnect.downloadFile(file, storedFile);
      }
      return true;
    }catch (e) {
      LogHelper.logger.d('Error getting FTP data: $e');
      return false;
    }
  }

  /// ### `downloadApk`
  ///
  /// Método encargado de descargar la app-release.apk.
  ///
  /// ----------------------------------------------------------------
  ///
  /// **Resumen del Funcionamiento:**
  ///
  /// Este método comienza instanciando una conexión con el parámetro
  /// [isDefault] = true, además de una variable [directory] con
  /// los directorios de documentos de la aplicación actual a través
  /// del método [getApplicationDocumentsDirectory()] procedente del
  /// paquete pathProvider. Se declara la variable [apk] con la ruta de
  /// la app-release.apk y se descarga la app-release.apk a través del
  /// método [downloadFile()] del paquete FTPConnect. Finalmente se cierra
  /// la conexión con el FTP.
  ///
  /// ----------------------------------------------------------------
  ///
  /// **Ejemplo de Uso:**
  ///
  /// ```dart
  /// ftpDataTransfer.downloadApk();
  /// ```

  Future<void> downloadApk () async {
    FTPConnect ftpConnect = await ftp.ftpConnection(isDefault: true);
    Directory directory = await getApplicationDocumentsDirectory();
    File apk = File('${directory.path}/app-release.apk');
    await ftpConnect.downloadFile('app-release.apk', apk);
    ftp.closeConnection();
  }

  /// ### `sendFilesToFTP()`
  ///
  /// Método encargado de enviar los archivos.txt, los cuáles son
  /// escritos por el método [writeFile()], al FTP a través de una
  /// conexión.
  ///
  /// ----------------------------------------------------------------
  ///
  /// **Resumen del Funcionamiento:**
  ///
  /// Comienza con la instancia de una conexión con el servidor FTP y
  /// de un DataFileWriter mediante el cuál podremos acceder al método
  /// [writeFile()] que crea y escribe los archivos.txt. Posteriormente
  /// se almacenan en una lista y se recorren uno a uno para ir subiéndolos
  /// al FTP.
  ///
  /// ----------------------------------------------------------------
  ///
  /// **Ejemplo de Uso:**
  ///
  /// ```dart
  /// FtpDataTransfer ftpDataTransfer = FtpDataTransfer();
  /// ftpDataTransfer.sendFilesToFTP();
  /// ```
  Future<void> sendFilesToFTP() async {
    FTPConnect ftpConnect = await ftp.ftpConnection(isDefault: true);
    DataFileWriter dataFileWriter = DataFileWriter();
    List<File> files = await dataFileWriter.writeFile();

    for (var file in files) {
      await ftpConnect.uploadFile(file);
    }
  }
}
