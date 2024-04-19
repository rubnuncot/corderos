import 'dart:convert';

import 'package:corderos_app/data/database/entities/!!model_dao.dart';
import 'package:meta/meta.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';
import 'package:sqflite_simple_dao_backend/database/params/constants.dart';

@reflector
class VehicleRegistration extends ModelDao {
  int? id;
  String? vehicleRegistrationNum;
  String? deliveryTicket;

  VehicleRegistration();

  VehicleRegistration.all(
      {@required required this.id,
      @required required this.vehicleRegistrationNum,
      @required required this.deliveryTicket});

  static final Map<String, String> _fields = {
    'id': Constants.bigint,
    'vehicleRegistrationNum': Constants.varchar["255"]!,
    'deliveryTicket': Constants.varchar["255"]!,
  };

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleRegistrationNum': vehicleRegistrationNum,
      'deliveryTicket': deliveryTicket,
    };
  }

  factory VehicleRegistration.fromRawJson(String str) =>
      VehicleRegistration.fromJson(json.decode(str));

  factory VehicleRegistration.fromJson(Map<String, dynamic> map) {
    return VehicleRegistration.all(
      id: map['id'],
      vehicleRegistrationNum: map['vehicleRegistrationNum'],
      deliveryTicket: map['deliveryTicket'],
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
  String toString() {
    return '$vehicleRegistrationNum\t$deliveryTicket';
  }
}
