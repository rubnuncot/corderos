import 'package:corderos_app/data/!data.dart';
import 'package:sqflite_simple_dao_backend/database/params/append.dart';

class DatabaseConfig {
  DatabaseConfig() {
    Append.dbParameters(param: 'name', value: 'Corderos');
    Append.dbParameters(param: 'tables', value: [
      Category,
      Slaughterhouse,
      VehicleRegistration,
      Client,
      Driver,
      Product,
      Rancher,
      Ticket
    ]);
    Append.dbParameters(param: 'version', value: 1);
  }
}
