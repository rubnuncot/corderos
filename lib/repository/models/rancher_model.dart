
import 'package:meta/meta.dart';

import '../../data/!data.dart';

class RancherModel {
  int? id;
  String? nif;
  String? name;

  RancherModel();
  RancherModel.all({
    @required required this.id,
    @required required this.nif,
    @required required this.name
  });

  RancherModel.fromEntity(Rancher rancher) {
    id = rancher.id;
    nif = rancher.nif;
    name = rancher.name;
  }

  Rancher toEntity() {
    return Rancher.all(
      id: id,
      nif: nif,
      name: name,
    );
  }
}