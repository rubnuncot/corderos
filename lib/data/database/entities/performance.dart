import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';
import 'package:sqflite_simple_dao_backend/database/params/constants.dart';
import '!!model_dao.dart';

@reflector
class Performance extends ModelDao {
    int? id;
    int? idProduct;
    int? idClassification;
    int? performance;

    Performance();

    Performance.all({
        @required required this.id,
        @required required this.idProduct,
        @required required this.idClassification,
        @required required this.performance
    });

  static final Map<String, String> _fields = {
    'id': Constants.bigint,
    'idProduct': Constants.bigint,
    'idClassification': Constants.bigint,
    'performance': Constants.bigint,
  };

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idProduct': idProduct,
      'idClassification': idClassification,
      'performance': performance,
    };
  }

  factory Performance.fromRawJson(String str) =>
      Performance.fromJson(json.decode(str));

  factory Performance.fromJson(Map<String, dynamic> map) {
    return Performance.all(
      id: map['id'],
      idProduct: map['idProduct'],
      idClassification: map['idClassification'],
      performance: map['performance'],
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

    return other is Performance &&
        other.id == id &&
        other.idProduct == idProduct &&
        other.idClassification == idClassification &&
        other.performance == performance;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      idProduct.hashCode ^
      idClassification.hashCode ^
      performance.hashCode;

    @override
  String toString() {
    return '$idProduct\t$idClassification\t$performance';
  }
}
