import 'package:corderos_app/!helpers/!helpers.dart';
import 'package:sqflite_simple_dao_backend/database/database/sql_builder.dart';
import 'package:sqflite_simple_dao_backend/sqflite_simple_dao_backend.dart';

@reflector
class ModelDao extends Dao {
  ModelDao() : super();

  Future<int> insert() async {
    return await super.insertSingle(objectToInsert: this);
  }

  Future<int> update() async {
    return await super.updateSingle(objectToUpdate: this);
  }

  Future<int> delete() async {
    return await super.deleteSingle(objectToDelete: this);
  }

  Future<List<ModelDao>> selectAll() async {
    return await super.select(
        sqlBuilder: SqlBuilder()
            .querySelect(fields: ['*']).queryFrom(table: getTableName(this)),
        model: this);
  }

  Future<bool> existsInDatabase() async {
    try {
      List all = await selectAll();
      return all.contains(this);
    } catch (e) {
      LogHelper.logger.d(e);
      return false;
    }
  }

  Future<int> truncate() async {
    List all = await selectAll();
    return super.batchDelete(objectsToDelete: all);
  }
}
