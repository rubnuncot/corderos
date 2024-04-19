import 'package:corderos_app/!helpers/log_helper.dart';
import 'package:ftpconnect/ftpconnect.dart';

import '../../../data/preferences/preferences.dart';

class FtpConnector {
  ///**Mapa donde se almacenarán los datos de conexión al FTP**
  Map<String, dynamic> ftpConnectionData = {};

  ///**Instancia de la conexión al FTP**
  ///
  ///Se crea la instancia en: [ftpConnection()](#ftpConnection)
  late FTPConnect connection;

  ///**Método que convierte el constructor FtpConnector en privado**
  FtpConnector._privateConstructor();

  ///**Declaración que define una instancia única y privada de la clase
  ///FtpConnector utilizando el patrón Singleton.
  static final FtpConnector _instance = FtpConnector._privateConstructor();

  ///**Declaración que proporciona acceso público estático a la instancia única de
  ///la clase FtpConnector utilizando el patrón Singleton a través de un getter llamado instance.**
  static FtpConnector get instance => _instance;

  ///### _getFTPConnectionData
  ///Método que obtiene los parámetros de conexión al FTP.
  ///a través de las preferencias y los almacena en [ftpConnectionData].
  ///
  ///----------------------------------------------------------------
  ///**Ejemplo de uso:**
  /// ```dart
  /// await _getFtpConnectionData();
  /// ```
  Future<void> _getFtpConnectionData() async {
    for (var key in ['host', 'port', 'username', 'password', 'path']) {
      ftpConnectionData[key] = await Preferences.getValue(key);
    }
  }

  /// ### `ftpConnection`
  ///
  /// Método que establece la conexión al FTP.
  ///
  /// ----------------------------------------------------------------
  /// **Parámetros:**
  /// - `isDefault` (opcional): Si es true, utilizará una serie de valores
  /// por defecto.
  ///
  /// **Retorno:**
  /// - Puede devolver una conexión (`FTPConnect connection`) o null.
  ///
  /// **Resumen del Funcionamiento:**
  ///
  /// A través del método [_getFtpConnection()](#_getFtpConnection), obtenemos los
  /// valores con los que vamos a rellenar la conexión al FTP mediante un constructor
  /// al que se le dan valores. Se pueden seleccionar los valores por defecto usando
  /// la variable `isDefault` con valor true. Una vez los valores de la conexión han sido establecidos,
  /// se realiza la conexión al FTP, devolviendo, en caso de éxito, una conexión (`FTPConnect connection`)
  /// y en caso de error, null.
  ///
  /// ----------------------------------------------------------------
  ///
  /// **Ejemplo de Uso:**
  ///
  /// ```dart
  /// FTPConnect ftpConnect = await ftp.ftpConnection(isDefault: true);
  /// ```

  Future<dynamic> ftpConnection({bool isDefault = true}) async {
    await _getFtpConnectionData();

    String path = ftpConnectionData['path'];

    connection = FTPConnect(
      ftpConnectionData['host'],
      port: ftpConnectionData['port'],
      user: ftpConnectionData['username'],
      pass: ftpConnectionData['password'],
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
        await connection.changeDirectory(path);
        LogHelper.logger.d(await connection.currentDirectory());
        return connection;
      }
      throw Exception('FTP connection error');
    } catch (e) {
      LogHelper.logger.d('Error de conexión FTP en ftp_connector.dart: $e');
      return ;
    }
  }

  /// ### `closeConnection`
  ///
  /// Método que se encarga de cerrar la conexión al FTP.
  ///
  /// ----------------------------------------------------------------
  ///
  /// **Resumen del Funcionamiento:**
  ///
  /// Método que cierra la conexión al FTP. En caso de error, lanza una
  /// excepción de tipo Exception con el mensaje ('Error closing FTP connection')
  ///
  /// ----------------------------------------------------------------
  ///
  /// **Ejemplo de Uso:**
  ///
  /// ```dart
  /// ftp.closeConnection();
  /// ```

  Future<void> closeConnection() async {
    if (!await connection.disconnect()) {
      throw Exception('Error closing FTP connection');
    }
  }
}
