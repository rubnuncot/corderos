
import 'package:corderos_app/data/!data.dart';
import 'package:meta/meta.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';
import '!!model_base.dart';
import '../../data/database/entities/!!model_dao.dart';

@reflector
class SlaughterhouseModel extends ModelBase{
  int? id;
  String? code;
  String? name;

  SlaughterhouseModel();

  SlaughterhouseModel.all({
    @required required this.id,
    @required required this.code,
    @required required this.name
  });

  @override
  Future<void> fromEntity(ModelDao entity) async{
    final slaughterhouse = entity as Slaughterhouse;
    id = slaughterhouse.id;
    code = slaughterhouse.code;
    name = slaughterhouse.name;
  }

  Slaughterhouse toEntity() {
    return Slaughterhouse.all(
      code: code,
      name: name,
    );
  }
}