import 'package:corderos_app/data/!data.dart';
import 'package:meta/meta.dart';

class ClientModel {
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

  ClientModel.fromEntity(Client client) {
    id = client.id;
    code = client.code;
    nif = client.nif;
    name = client.name;
    email = client.email;
  }

  Client toEntity() {
    return Client.all(
      id: id,
      code: code,
      nif: nif,
      name: name,
      email: email
    );
  }
}
