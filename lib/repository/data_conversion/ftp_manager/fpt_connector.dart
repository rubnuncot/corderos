import 'package:corderos_app/!helpers/log_helper.dart';
import 'package:ftpconnect/ftpconnect.dart';

import '../../../data/preferences/preferences.dart';

class FtpConnector {
  Map<String, dynamic> data = {};

  late FTPConnect connection;

  FtpConnector._privateConstructor();

  static final FtpConnector _instance = FtpConnector._privateConstructor();

  static FtpConnector get instance => _instance;

  Future<void> _getFtpConnectionData() async {
    for (var key in ['host', 'port', 'username', 'password', 'path']) {
      data[key] = await Preferences.getValue(key);
    }
  }

  Future<dynamic> ftpConnection({bool isDefault = true}) async {
    await _getFtpConnectionData();

    String path = data['path'];

    connection = FTPConnect(
      data['host'],
      port: data['port'],
      user: data['username'],
      pass: data['password'],
    );

    if (isDefault) {
      connection = FTPConnect(
        '82.223.98.115',
        port: 21,
        user: 'android',
        pass: 'Android2023/*-',
      );
      path = '/corderos';
    }

    try {
      if (await connection.connect()) {
        connection.changeDirectory(path);
        return connection;
      }
      throw Exception('FTP connection error');
    } catch (e) {
      LogHelper.logger.d('Error de conexión FTP en ftp_connector.dart: $e');
      return ;
    }
  }

  Future<void> closeConnection() async {
    if (!await connection.disconnect()) {
      throw Exception('Error closing FTP connection');
    }
  }
}
