import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';
import 'package:sqflite_simple_dao_backend/database/params/constants.dart';
import '!!model_dao.dart';

@reflector
class ProductDeliveryNote extends ModelDao {
  int? idDeliveryNote;
  int? idProduct;
  int? idClassification;
  String? nameClassification;
  int? units;
  double? kilograms;
  String? color;

  ProductDeliveryNote();

  ProductDeliveryNote.all({
    int? id,
    @required required this.idDeliveryNote,
    @required required this.idProduct,
    @required required this.idClassification,
    @required required this.nameClassification,
    @required required this.units,
    @required required this.kilograms,
    @required required this.color,
  }){
    super.id = id;
  }

  static final Map<String, String> _fields = {
    'id': Constants.bigint,
    'idDeliveryNote': Constants.bigint,
    'idProduct': Constants.bigint,
    'idClassification': Constants.varchar['255']!,
    'nameClassification': Constants.varchar['255']!,
    'units': Constants.bigint,
    'kilograms': Constants.decimal['9,2']!,
    'color': Constants.varchar['255']!,
  };

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idDeliveryNote': idDeliveryNote,
      'idProduct': idProduct,
      'idClassification': idClassification,
      'nameClassification': nameClassification,
      'units': units,
      'kilograms': kilograms,
      'color': color,
    };
  }

  factory ProductDeliveryNote.fromRawJson(String str) =>
      ProductDeliveryNote.fromJson(json.decode(str));

  factory ProductDeliveryNote.fromJson(Map<String, dynamic> map) {
    return ProductDeliveryNote.all(
      id: map['id'],
      idDeliveryNote: map['idDeliveryNote'],
      idProduct: map['idProduct'],
      idClassification: int.parse(map['idClassification']),
      nameClassification: map['nameClassification'],
      units: map['units'],
      kilograms: map['kilograms'] != null
          ? double.parse(map['kilograms'].toString())
          : null,
      color: map['color'],
    );
  }

  static final Iterable<String> _names = _fields.keys;

  static final List<String> _primary = [
    _names.elementAt(0),
    _names.elementAt(1)
  ];

  static final List<String> _exception = [];

  static final List<String> _foreign = [];

  static List<String> get foreign => _foreign;

  static List<String> get primary => _primary;

  static Map<String, String> get fields => _fields;

  static Iterable<String> get names => _names;

  static List<String> get exception => _exception;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductDeliveryNote &&
        other.idDeliveryNote == idDeliveryNote &&
        other.idProduct == idProduct &&
        other.idClassification == idClassification &&
        other.nameClassification == nameClassification &&
        other.units == units &&
        other.kilograms == kilograms &&
        other.color == color;
  }

  @override
  int get hashCode {
    return
        idDeliveryNote.hashCode ^
        idProduct.hashCode ^
        idClassification.hashCode ^
        nameClassification.hashCode ^
        units.hashCode ^
        kilograms.hashCode ^
        color.hashCode;
  }

  @override
  String toString() {
    return '$idClassification\t$nameClassification\t$units\t$kilograms\t$color';
  }
}
