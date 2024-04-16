
import 'package:corderos_app/data/!data.dart';
import 'package:meta/meta.dart';

class SlaughterhouseModel {
  int? id;
  String? code;
  String? name;

  SlaughterhouseModel();

  SlaughterhouseModel.all({
    @required required this.id,
    @required required this.code,
    @required required this.name
  });

  SlaughterhouseModel.fromEntity(Slaughterhouse slaughterhouse) {
    id = slaughterhouse.id;
    code = slaughterhouse.code;
    name = slaughterhouse.name;
  }

  Slaughterhouse toEntity() {
    return Slaughterhouse.all(
      id: id,
      code: code,
      name: name,
    );
  }
}