import 'package:corderos_app/data/database/entities/!!model_dao.dart';
import 'package:reflectable/mirrors.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';

class ModelBase {

  Future<void> fromEntity(ModelDao entity) async {
    throw UnimplementedError();
  }

  Future<List<T>> fromEntityList<T>(List<ModelDao> entities) async {
    List<T> models = [];

    for(var entity in entities) {
      var classMirror = reflector.reflectType(runtimeType) as ClassMirror;
      var instanceMirror = classMirror.newInstance('', []) as ModelBase;
      await instanceMirror.fromEntity(entity);
      models.add(instanceMirror as T);
    }
    return models;
  }
}