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
          .querySelect(fields: ['*'])
          .queryFrom(table: getTableName(this)),
      model: this
    );
  }
}
