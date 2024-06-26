import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';
import 'package:sqflite_simple_dao_backend/database/params/constants.dart';
import 'package:corderos_app/data/database/entities/!!model_dao.dart';

@reflector
class Driver extends ModelDao {
  String? nif;
  String? name;

  Driver();

  Driver.all(
      {int? id,
      @required required this.nif,
      @required required this.name}){
    super.id = id;
  }

  static final Map<String, String> _fields = {
    'id': Constants.bigint,
    'nif': Constants.varchar["10"]!,
    'name': Constants.varchar["255"]!,
  };

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nif': nif,
      'name': name,
    };
  }

  factory Driver.fromRawJson(String str) => Driver.fromJson(json.decode(str));

  factory Driver.fromJson(Map<String, dynamic> map) {
    return Driver.all(
      id: map['id'],
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

    return other is Driver &&
        other.nif == nif &&
        other.name == name;
  }

  @override
  int get hashCode => nif.hashCode ^ name.hashCode;

  @override
  String toString() {
    return '$nif\t$name';
  }
}
