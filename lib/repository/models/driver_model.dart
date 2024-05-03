import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';

import '!!model_base.dart';
import 'package:corderos_app/data/!data.dart';
import 'package:meta/meta.dart';

import '../../data/database/entities/!!model_dao.dart';

@reflector
class DriverModel extends ModelBase{
  int? id;
  String? nif;
  String? name;

  DriverModel();
  DriverModel.all({
    @required required this.id,
    @required required this.nif,
    @required required this.name
  });

  @override
  Future<void> fromEntity (ModelDao entity) async {
    final driver = entity as Driver;
    id = driver.id;
    nif = driver.nif;
    name = driver.name;
  }

  Driver toEntity() {
    return Driver.all(
      nif: nif,
      name: name,
    );
  }
}