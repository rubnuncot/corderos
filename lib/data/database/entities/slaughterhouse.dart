import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';
import 'package:sqflite_simple_dao_backend/database/params/constants.dart';
import '!!model_dao.dart';

@reflector
class Slaughterhouse extends ModelDao {
  int? id;
  String? code;
  String? name;

  Slaughterhouse();

  Slaughterhouse.all(
      {@required required this.id,
        @required required this.code,
        @required required this.name});

  static final Map<String, String> _fields = {
    'id': Constants.bigint,
    'code': Constants.varchar["255"]!,
    'name': Constants.varchar["255"]!,
  };

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
    };
  }

  factory Slaughterhouse.fromRawJson(String str) =>
      Slaughterhouse.fromJson(json.decode(str));

  factory Slaughterhouse.fromJson(Map<String, dynamic> map) {
    return Slaughterhouse.all(
      id: map['id'],
      code: map['code'],
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

    return other is Slaughterhouse
        && other.id == id
        && other.code == code
        && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ code.hashCode ^ name.hashCode;

  @override
  String toString() {
    return '$code\t$name';
  }
}
