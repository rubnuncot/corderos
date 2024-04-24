import '!!model_base.dart';
import 'package:corderos_app/data/!data.dart';
import 'package:meta/meta.dart';

import '../../data/database/entities/!!model_dao.dart';

class DriverModel extends ModelBase{
  int? id;
  String? code;
  String? nif;
  String? name;

  DriverModel();
  DriverModel.all({
    @required required this.id,
    @required required this.code,
    @required required this.nif,
    @required required this.name
  });

  @override
  Future<void> fromEntity (ModelDao entity) async {
    final driver = entity as Driver;
    id = driver.id;
    code = driver.code;
    nif = driver.nif;
    name = driver.name;
  }

  Driver toEntity() {
    return Driver.all(
      code: code,
      nif: nif,
      name: name,
    );
  }
}