import 'package:meta/meta.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';
import '!!model_base.dart';
import '../../data/!data.dart';
import '../../data/database/entities/!!model_dao.dart';

@reflector
class RancherModel extends ModelBase{
  int? id;
  String? code;
  String? nif;
  String? name;

  RancherModel();
  RancherModel.all({
    @required required this.id,
    @required required this.code,
    @required required this.nif,
    @required required this.name
  });

  @override
  Future<void> fromEntity(ModelDao entity) async {
    final rancher = entity as Rancher;
    id = rancher.id;
    code = rancher.code;
    nif = rancher.nif;
    name = rancher.name;
  }

  Rancher toEntity() {
    return Rancher.all(
      code: code,
      nif: nif,
      name: name,
    );
  }
}