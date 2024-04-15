import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';
import 'package:sqflite_simple_dao_backend/database/params/constants.dart';
import '!!model_dao.dart';

@reflector
class ProductDeliveryNote extends ModelDao {
  int? id;
  int? idDeliveryNote;
  int? idProduct;
  String? nameClassification;
  int? units;
  double? kilograms;

  ProductDeliveryNote();

  ProductDeliveryNote.all({
    @required required this.id,
    @required required this.idDeliveryNote,
    @required required this.idProduct,
    @required required this.nameClassification,
    @required required this.units,
    @required required this.kilograms,
  });

  static final Map<String, String> _fields = {
    'id': Constants.bigint,
    'idDeliveryNote': Constants.bigint,
    'idProduct': Constants.bigint,
    'nameClassification': Constants.varchar['255']!,
    'units': Constants.bigint,
    'kilograms': Constants.decimal['9,2']!,
  };

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idDeliveryNote': idDeliveryNote,
      'idProduct': idProduct,
      'nameClassification': nameClassification,
      'units': units,
      'kilograms': kilograms,
    };
  }

  factory ProductDeliveryNote.fromRawJson(String str) =>
      ProductDeliveryNote.fromJson(json.decode(str));

  static ProductDeliveryNote fromJson(Map<String, dynamic> map) {
    return ProductDeliveryNote.all(
      id: map['id'],
      idDeliveryNote: map['idDeliveryNote'],
      idProduct: map['idProduct'],
      nameClassification: map['nameClassification'],
      units: map['units'],
      kilograms: map['kilograms'] != null
          ? double.parse(map['kilograms'].toString())
          : null,
    );
  }

  static final Iterable<String> _names = _fields.keys;

  static final List<String> _primary = [
    _names.elementAt(0),
    _names.elementAt(1)
  ];

  static List<String> get primary => _primary;

  static Map<String, String> get fields => _fields;

  static Iterable<String> get names => _names;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductDeliveryNote &&
        other.id == id &&
        other.idDeliveryNote == idDeliveryNote &&
        other.idProduct == idProduct &&
        other.nameClassification == nameClassification &&
        other.units == units &&
        other.kilograms == kilograms;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        idDeliveryNote.hashCode ^
        idProduct.hashCode ^
        nameClassification.hashCode ^
        units.hashCode ^
        kilograms.hashCode;
  }
}
