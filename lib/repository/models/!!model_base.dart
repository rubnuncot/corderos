import 'package:corderos_app/data/database/entities/!!model_dao.dart';
import 'package:reflectable/mirrors.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';

@reflector
class ModelBase {
  Future<void> fromEntity(ModelDao entity) async {
    throw UnimplementedError();
  }

  Future<List<T>> fromEntityList<T>(List<ModelDao> entities) async {
    List<T> models = [];

    for (var entity in entities) {
      var classMirror = reflector.reflectType(runtimeType) as ClassMirror;
      var instanceMirror = classMirror.newInstance('', []) as ModelBase;
      await instanceMirror.fromEntity(entity);
      models.add(instanceMirror as T);
    }
    return models;
  }

  T updateValue<T>(String fieldName, dynamic newValue) {
    var classMirror = reflector.reflectType(T) as ClassMirror;
    var instanceMirror = reflector.reflect(this);

    if (classMirror.instanceMembers.containsKey(fieldName)) {
      var variableMirror =
          classMirror.declarations[fieldName] as VariableMirror;
      if (newValue is Map<String, dynamic>) {
        newValue = newValue[variableMirror.reflectedType.toString()];
        instanceMirror.invokeSetter(fieldName, newValue);
      } else if (newValue is ModelBase){
        instanceMirror.invokeSetter(
            fieldName,
            newValue);
      } else {
        instanceMirror.invokeSetter(
            fieldName,
            _convertStringToType(
                newValue, variableMirror.reflectedType.toString()));
      }
      return this as T;
    } else {
      throw Exception(
          'Field $fieldName not found in class ${classMirror.simpleName}');
    }
  }

  dynamic _convertStringToType(String value, String targetType) {
    switch (targetType) {
      case 'int':
        return int.tryParse(value);
      case 'double':
        return double.tryParse(value);
      case 'bool':
        return value.toLowerCase() == 'true';
      case 'String':
        return value;
      default:
        throw ArgumentError('Unsupported target type: $targetType');
    }
  }
}
