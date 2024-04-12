
import 'package:corderos_app/data/!data.dart';
import 'package:meta/meta.dart';

class DriverModel {
  int? id;
  String? nif;
  String? name;

  DriverModel();
  DriverModel.all({
    @required required this.id,
    @required required this.nif,
    @required required this.name
  });

  DriverModel.fromEntity (Driver driver) {
    id = driver.id;
    nif = driver.nif;
    name = driver.name;
  }

  Driver toEntity() {
    return Driver.all(
      id: id,
      nif: nif,
      name: name,
    );
  }
}