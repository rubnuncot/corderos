import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';
import 'package:sqflite_simple_dao_backend/database/params/constants.dart';
import '!!model_dao.dart';

@reflector
class ProductTicket extends ModelDao {
  int? idTicket;
  int? idProduct;
  String? nameClassification;
  int? numAnimals;
  double? weight;
  int? idPerformance;
  String? color;
  int? losses;
  int? idOutDelivery;

  ProductTicket();

  ProductTicket.all({
    int? id,
    @required required this.idTicket,
    @required required this.idProduct,
    @required required this.nameClassification,
    @required required this.numAnimals,
    @required required this.weight,
    @required required this.idPerformance,
    @required required this.color,
    @required required this.losses,
    @required required this.idOutDelivery,
  }){
    super.id = id;
  }

  static final Map<String, String> _fields = {
    'id': Constants.bigint,
    'idTicket': Constants.bigint,
    'idProduct': Constants.bigint,
    'nameClassification': Constants.varchar['255']!,
    'numAnimals': Constants.bigint,
    'weight': Constants.decimal['9,2']!,
    'idPerformance': Constants.bigint,
    'color': Constants.varchar['255']!,
    'losses': Constants.bigint,
    'idOutDelivery': Constants.bigint,
  };

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idTicket': idTicket,
      'idProduct': idProduct,
      'nameClassification': nameClassification,
      'numAnimals': numAnimals,
      'weight': weight,
      'idPerformance': idPerformance,
      'color': color,
      'losses': losses,
      'idOutDelivery': idOutDelivery,
    };
  }

  factory ProductTicket.fromRawJson(String str) =>
      ProductTicket.fromJson(json.decode(str));

  factory ProductTicket.fromJson(Map<String, dynamic> map) {
    return ProductTicket.all(
      id: map['id'],
      idTicket: map['idTicket'],
      idProduct: map['idProduct'],
      nameClassification: map['nameClassification'],
      numAnimals: map['numAnimals'],
      weight: map['weight']?.toDouble(),
      idPerformance: map['idPerformance'],
      color: map['color'],
      losses: map['losses'],
      idOutDelivery: map['idOutDelivery'],
    );
  }

  static final Iterable<String> _names = _fields.keys;

  static final List<String> _primary = [
    _names.elementAt(0),
    _names.elementAt(1),
    _names.elementAt(2)
  ];

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

    return other is ProductTicket &&
        other.idTicket == idTicket &&
        other.idProduct == idProduct &&
        other.nameClassification == nameClassification &&
        other.numAnimals == numAnimals &&
        other.weight == weight &&
        other.idPerformance == idPerformance &&
        other.color == color &&
        other.idOutDelivery == idOutDelivery &&
        other.losses == losses;
  }

  @override
  int get hashCode {
    return
        idTicket.hashCode ^
        idProduct.hashCode ^
        nameClassification.hashCode ^
        numAnimals.hashCode ^
        weight.hashCode ^
        idPerformance.hashCode ^
        color.hashCode ^
        idOutDelivery.hashCode ^
        losses.hashCode;
  }

  @override
  String toString() {
    return '$nameClassification\t$numAnimals\t$weight\t$idPerformance\t$color\t$losses';
  }
}
