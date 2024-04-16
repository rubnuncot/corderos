import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';
import 'package:sqflite_simple_dao_backend/database/params/constants.dart';
import '!!model_dao.dart';

@reflector
class Rancher extends ModelDao {
  int? id;
  String? code;
  String? nif;
  String? name;

  Rancher();
  Rancher.all({@required required this.id, @required required this.code ,@required required this.nif, @required required this.name});

  static final Map<String, String> _fields = {
    'id': Constants.bigint,
    'code': Constants.varchar["255"]!,
    'nif': Constants.varchar["10"]!,
    'name': Constants.varchar["255"]!,
  };

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'nif': nif,
      'name': name,
    };
  }

  factory Rancher.fromRawJson(String str) =>
      Rancher.fromJson(json.decode(str));

  factory Rancher.fromJson(Map<String, dynamic> map) {
    return Rancher.all(
      id: map['id'],
      code: map['code'],
      nif: map['nif'],
      name: map['name'],
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

    return other is Rancher &&
        other.id == id &&
        other.code == code &&
        other.nif == nif &&
        other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ code.hashCode ^ nif.hashCode ^ name.hashCode;

  @override
  String toString() {
    return '$code\t$nif\t$name';
  }
}
