import 'package:corderos_app/!helpers/!helpers.dart';
import 'package:meta/meta.dart';
import 'package:sqflite_simple_dao_backend/database/database/sql_builder.dart';
import 'package:sqflite_simple_dao_backend/database/database/dao_connector.dart';

class DatabaseRepository {

  final daoConnector = const Dao();
  static final _ftpData = [];

  Future<List> getFTPData() async {
    List result = [];
    try {
      for (dynamic table in _ftpData) {
        return await table.select(sqlBuilder: SqlBuilder()
            .querySelect(fields: ['*'])
            .queryFrom(table: table.getTableName(table))
        );
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

  Future getSingleData({ @required required dynamic entity }) async {
    try {
      return await entity.select(sqlBuilder: SqlBuilder()
          .querySelect(fields: ['*'])
          .queryFrom(table: entity.getTableName(entity))
    );
    }catch (e) {
    LogHelper.logger.e('Error en getSingleData: $e');
    return -1;
    }
  }

  static Future<dynamic> getEntityById(dynamic entity, int id) async {
    return await entity.select(sqlBuilder: SqlBuilder()
        .querySelect(fields: ['*'])
        .queryFrom(table: entity.getTableName(entity))
        .queryWhere(conditions: ['id = $id'])
    );
  }
}