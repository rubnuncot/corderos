import 'package:corderos_app/!helpers/!helpers.dart';
import 'package:meta/meta.dart';
import 'package:sqflite_simple_dao_backend/database/database/sql_builder.dart';
import 'package:sqflite_simple_dao_backend/sqflite_simple_dao_backend.dart';

@reflector
class ModelDao extends Dao {
  ModelDao() : super();

  int? id;

  ModelDao.all({@required required id});

  Future<int> insert() async {
    List all = await selectAll<ModelDao>();
    id = all.isEmpty ? 0 : all.last.id + 1;
    return await super.insertSingle(objectToInsert: this);
  }

  Future<int> listInsert(List<ModelDao> list) async {
    if (list.isEmpty) return -1;
    List<ModelDao> all = await selectAll<ModelDao>();

    int nextId = all.isEmpty ? 0 : all.last.id! + 1;

    for (var e in list) {
      e.id = nextId++;
      all.add(e);
    }

    return await super.batchInsert(objectsToInsert: list);
  }

  Future<int> update() async {
    return await super.updateSingle(objectToUpdate: this);
  }

  Future<int> delete() async {
    return await super.deleteSingle(objectToDelete: this);
  }

  Future<List<T>> getData<T>({
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

    return await super.select<T>(sqlBuilder: builder, model: this) as List<T>;
  }

  Future<List<T>> selectAll<T>() async {
    return await getData<T>();
  }

  Future<T> selectLast<T>() async {
    List all = await selectAll<T>();
    return all.last;
  }

  Future<bool> existsInDatabase<T>() async {
    try {
      List all = await selectAll<T>();
      return all.contains(this);
    } catch (e) {
      LogHelper.logger.d(e);
      return false;
    }
  }

  Future<int> truncate<T>() async {
    List all = await selectAll<T>();
    return super.batchDelete(objectsToDelete: all);
  }
}
