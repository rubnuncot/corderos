import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';

import '!!model_base.dart';
import 'package:corderos_app/data/!data.dart';
import 'package:meta/meta.dart';

import '../../data/database/entities/!!model_dao.dart';

@reflector
class ClientModel extends ModelBase{
  int? id;
  String? code;
  String? nif;
  String? name;
  String? email;

  ClientModel();

  ClientModel.all({
    @required required this.id,
    @required required this.code,
    @required required this.nif,
    @required required this.name,
    @required required this.email
  });

  @override
  Future<void> fromEntity(ModelDao entity) async {
    final client = entity as Client;
    id = client.id;
    code = client.code;
    nif = client.nif;
    name = client.name;
    email = client.email;
  }

  Client toEntity() {
    return Client.all(
      code: code,
      nif: nif,
      name: name,
      email: email
    );
  }
}
