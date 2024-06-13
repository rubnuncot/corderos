import 'package:corderos_app/!helpers/!helpers.dart';
import 'package:corderos_app/data/!data.dart';
import 'package:corderos_app/data/database/!database.dart';
import 'package:jiffy/jiffy.dart';
import 'package:meta/meta.dart';
import 'package:sqflite_simple_dao_backend/database/database/sql_builder.dart';
import 'package:sqflite_simple_dao_backend/database/database/dao_connector.dart';

class DatabaseRepository {
  final daoConnector = const Dao();
  static final _ftpData = {
    ClientDeliveryNote: ClientDeliveryNote(),
    DeliveryTicket: DeliveryTicket(),
    ProductTicket: ProductTicket(),
    ProductDeliveryNote: ProductDeliveryNote(),
  };

  Future<Map<String, List>> getFTPData() async {
    Map<String, List> result = {};
    String hoy = Jiffy.parse(DateTime.now().toString()).format(pattern: 'ddMMyyyyHHmmss');
    var contain = 'product';

    try {
      for (dynamic table in _ftpData.keys) {
        dynamic value = _ftpData[table];
        String tableName = value.getTableName(value);
        result.addAll({
          tableName.contains(contain)
                  ? '${contain}_${tableName.substring(contain.length, tableName.length - 1)}-$hoy.txt'
                  : '${tableName.substring(0, tableName.length - 1)}-$hoy.txt':
              await value.select(
            sqlBuilder: SqlBuilder()
                .querySelect(fields: ['*'])
                .queryFrom(table: tableName),
            model: value,
            print: true,
          )
        });
      }
    } catch (e) {
      LogHelper.logger.e('Error en getFTPData: $e');
    }
    return result;
  }

  Future<int> insertData(List list) async {
    try {
      return await daoConnector.batchInsertOrUpdate(objects: list);
    } catch (e) {
      LogHelper.logger.e('Error en insertData: $e');
      return -1;
    }
  }

  Future getSingleData({@required required dynamic entity}) async {
    try {
      return await entity.select(
          sqlBuilder: SqlBuilder().querySelect(fields: ['*']).queryFrom(
              table: entity.getTableName(entity)));
    } catch (e) {
      LogHelper.logger.e('Error en getSingleData: $e');
      return -1;
    }
  }

  static Future<dynamic> getEntityById(dynamic entity, int id) async {
    dynamic res = await entity.select(
        sqlBuilder: SqlBuilder()
            .querySelect(fields: ['*'])
            .queryFrom(table: entity.getTableName(entity))
            .queryWhere(conditions: ['id = $id']),
        model: entity);
    return res.first;
  }

  static Future<dynamic> getEntityByCode(dynamic entity, int code) async {
    dynamic res = await entity.select(
        sqlBuilder: SqlBuilder()
            .querySelect(fields: ['*'])
            .queryFrom(table: entity.getTableName(entity))
            .queryWhere(conditions: ['code = $code']),
        model: entity);
    return res.first;
  }

  static Future<dynamic> getEntityByName(dynamic entity, String name) async {
    dynamic res = await entity.select(
        sqlBuilder: SqlBuilder()
            .querySelect(fields: ['*'])
            .queryFrom(table: entity.getTableName(entity))
            .queryWhere(conditions: ["name = '$name'"]),
        model: entity);
    return res.first;
  }
}
