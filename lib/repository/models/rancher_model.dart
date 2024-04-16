
import 'package:meta/meta.dart';

import '../../data/!data.dart';

class RancherModel {
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

  RancherModel.fromEntity(Rancher rancher) {
    id = rancher.id;
    code = rancher.code;
    nif = rancher.nif;
    name = rancher.name;
  }

  Rancher toEntity() {
    return Rancher.all(
      id: id,
      code: code,
      nif: nif,
      name: name,
    );
  }
}