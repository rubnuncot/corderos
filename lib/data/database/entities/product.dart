import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';
import 'package:sqflite_simple_dao_backend/database/params/constants.dart';
import '!!model_dao.dart';

@reflector
class Product extends ModelDao {
  String? code;
  String? name;

  Product();

  Product.all(
      {int? id, @required required this.code, @required required this.name}){
    super.id = id;
  }

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

  factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

  factory Product.fromJson(Map<String, dynamic> map) {
    return Product.all(
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

    return other is Product && other.code == code && other.name == name;
  }

  @override
  int get hashCode => code.hashCode ^ name.hashCode;

  @override
  String toString() {
    return '$code\t$name)';
  }
}
