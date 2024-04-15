import 'dart:convert';

import 'package:corderos_app/data/database/entities/!!model_dao.dart';
import 'package:meta/meta.dart';
import 'package:sqflite_simple_dao_backend/sqflite_simple_dao_backend.dart';

@reflector
class VehicleRegistration extends ModelDao {
  String? id;
  int? deliveryTicket;

  VehicleRegistration();

  VehicleRegistration.all(
      {@required required this.id, @required required this.deliveryTicket});

  static final Map<String, String> _fields = {
    'id': Constants.bigint,
    'deliveryTicketId': Constants.bigint,
  };

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deliveryTicketId': deliveryTicket,
    };
  }

  factory VehicleRegistration.fromRawJson(String str) =>
      VehicleRegistration.fromJson(json.decode(str));

  static VehicleRegistration fromJson(Map<String, dynamic> map) {
    return VehicleRegistration.all(
      id: map['id'],
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
}
