import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';
import 'package:sqflite_simple_dao_backend/database/params/constants.dart';
import '!!model_dao.dart';

@reflector
class ProductTicket extends ModelDao {
  int? idProductTicket;
  String? nameClassification;
  int? numAnimals;
  double? weight;
  int? idPerformance;
  int? losses;

  ProductTicket();

  ProductTicket.all({
    @required required this.idProductTicket,
    @required required this.nameClassification,
    @required required this.numAnimals,
    @required required this.weight,
    @required required this.idPerformance,
    @required required this.losses,
  });

  static final Map<String, String> _fields = {
    'idProductTicket': Constants.bigint,
    'nameClassification': Constants.varchar['255']!,
    'numAnimals': Constants.bigint,
    'weight': Constants.decimal['9,2']!,
    'idPerformance': Constants.bigint,
    'losses': Constants.bigint,
  };

  Map<String, dynamic> toMap() {
    return {
      'idProductTicket': idProductTicket,
      'nameClassification': nameClassification,
      'numAnimals': numAnimals,
      'weight': weight,
      'idPerformance': idPerformance,
      'losses': losses,
    };
  }

  factory ProductTicket.fromRawJson(String str) =>
      ProductTicket.fromMap(json.decode(str));

  static ProductTicket fromMap(Map<String, dynamic> map) {
    return ProductTicket.all(
      idProductTicket: map['idProductTicket'],
      nameClassification: map['nameClassification'],
      numAnimals: map['numAnimals'],
      weight: map['weight']?.toDouble(),
      idPerformance: map['idPerformance'],
      losses: map['losses'],
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

    return other is ProductTicket &&
        other.idProductTicket == idProductTicket &&
        other.nameClassification == nameClassification &&
        other.numAnimals == numAnimals &&
        other.weight == weight &&
        other.idPerformance == idPerformance &&
        other.losses == losses;
  }

  @override
  int get hashCode {
    return idProductTicket.hashCode ^
    nameClassification.hashCode ^
    numAnimals.hashCode ^
    weight.hashCode ^
    idPerformance.hashCode ^
    losses.hashCode;
  }
}
