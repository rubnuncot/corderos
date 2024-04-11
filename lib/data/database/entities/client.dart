import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';
import 'package:sqflite_simple_dao_backend/database/params/constants.dart';
import '!!model_dao.dart';

@reflector
class Client extends ModelDao {
  int? id;
  String? nif;
  String? name;
  String? email;

  Client();

  Client.all(
      {@required required this.id,
      @required required this.nif,
      @required required this.name,
      @required required this.email});

  static final Map<String, String> _fields = {
    'id': Constants.bigint,
    'nif': Constants.varchar["10"]!,
    'name': Constants.varchar["255"]!,
    'email': Constants.varchar["255"]!,
  };

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nif': nif,
      'name': name,
      'email': email,
    };
  }

  factory Client.fromRawJson(String str) => Client.fromMap(json.decode(str));

  static Client fromMap(Map<String, dynamic> map) {
    return Client.all(
      id: map['id'],
      nif: map['nif'],
      name: map['name'],
      email: map['email'],
    );
  }

  static final Iterable<String> _names = _fields.keys;

  static final List<String> _primary = [_names.elementAt(0)];

  static final List<String> _exception = [];

  static final List<String> _foreign = [];

  static List<String> get foreign => _foreign;

  static Map<String, String> get fields => _fields;

  static Iterable<String> get names => _names;

  static List<String> get primary => _primary;

  static List<String> get exception => _exception;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Client &&
        other.id == id &&
        other.nif == nif &&
        other.name == name &&
        other.email == email;
  }

  @override
  int get hashCode =>
      id.hashCode ^ nif.hashCode ^ name.hashCode ^ email.hashCode;
}
