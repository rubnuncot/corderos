import 'dart:io';

import 'package:corderos_app/!helpers/!helpers.dart';
import 'package:corderos_app/repository/data_conversion/!data_conversion.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class FtpDataTransfer {
  FtpConnector ftp = FtpConnector.instance;

  List<String> files = [
    'conductores.txt',
    'matriculas.txt',
    'ganaderos.txt',
    'mataderos.txt',
    'clientes.txt',
    'productos.txt',
    'clasifiaciones.txt',
    'rendimientos.txt'
  ];

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

  Future<void> downloadApk () async {
    FTPConnect ftpConnect = await ftp.ftpConnection(isDefault: true);
    Directory directory = await getApplicationDocumentsDirectory();
    File apk = File('${directory.path}/app-release.apk');
    await ftpConnect.downloadFile('app-release.apk', apk);
    ftp.closeConnection();
  }

//TODO: Implementar un método que envíe los ficheros al FTP
/*
  ! Este método tiene que enviar los ficheros al ftp, estos ficheros siempre
  ! van a ser los mismos, los cuales los vamos a recibir desde el repositorio.
  ! (data_file_writer.dart)
  */
}
