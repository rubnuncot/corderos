import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';
import 'package:sqflite_simple_dao_backend/database/params/constants.dart';
import '!!model_dao.dart';

@reflector
class Classification extends ModelDao {
  int? id;
  String? name;
  int? productId;

  Classification();

  Classification.all(
      {@required required this.id,
      @required required this.name,
      @required required this.productId});

  static final Map<String, String> _fields = {
    'id': Constants.bigint,
    'name': Constants.varchar["255"]!,
    'product_id': Constants.bigint,
  };

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'product_id': productId,
    };
  }

  factory Classification.fromRawJson(String str) =>
      Classification.fromMap(json.decode(str));

  static Classification fromMap(Map<String, dynamic> map) {
    return Classification.all(
      id: map['id'],
      name: map['name'],
      productId: map['product_id'],
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

    return other is Classification &&
        other.id == id &&
        other.name == name &&
        other.productId == productId;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ productId.hashCode;
}
