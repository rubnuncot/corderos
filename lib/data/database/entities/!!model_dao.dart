import 'package:corderos_app/!helpers/!helpers.dart';
import 'package:sqflite_simple_dao_backend/database/database/sql_builder.dart';
import 'package:sqflite_simple_dao_backend/sqflite_simple_dao_backend.dart';

@reflector
class ModelDao extends Dao {
  ModelDao() : super();

  int? id;

  Future<int> insert() async {
    List all = await selectAll();
    id = all.last.id + 1;
    return await super.insertSingle(objectToInsert: this);
  }

  Future<int> update() async {
    return await super.updateSingle(objectToUpdate: this);
  }

  Future<int> delete() async {
    return await super.deleteSingle(objectToDelete: this);
  }

  Future<List<ModelDao>> getData({
    List<String> where = const [],
    List<String> orderBy = const [],
    int limit = -1,
    SqlBuilder? subSelect,
  }) async {
    SqlBuilder builder = SqlBuilder();
    builder.querySelect(fields: ['*']).queryFrom(table: getTableName(this));
    if (where.isNotEmpty) {
      builder.queryWhere(conditions: where);
    }
    if (subSelect != null) {
      builder.queryWhere(conditions: [SqlBuilder.querySubSelect(subSelect)]);
    }
    if (orderBy.isNotEmpty) {
      builder.queryOrder(fields: [orderBy]);
    }
    if (limit != -1) {
      builder.queryLimit(limit: '$limit');
    }
    return await super.select(sqlBuilder: builder, model: this);
  }

  Future<List<ModelDao>> selectAll() async {
    return await getData();
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
