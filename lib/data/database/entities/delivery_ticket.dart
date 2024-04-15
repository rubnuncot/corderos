import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';
import 'package:sqflite_simple_dao_backend/database/params/constants.dart';
import '!!model_dao.dart';

@reflector
class DeliveryTicket extends ModelDao {
  int? id;
  String? numTicket;
  String? series;
  String? deliveryTicket;
  DateTime? date;
  int? idDriver;
  int? idVehicleRegistration;
  int? idSlaughterhouse;
  int? idRancher;
  int? idProduct;

  DeliveryTicket();

  DeliveryTicket.all({
    @required required this.id,
    @required required this.numTicket,
    @required required this.series,
    @required required this.deliveryTicket,
    @required required this.date,
    @required required this.idDriver,
    @required required this.idVehicleRegistration,
    @required required this.idSlaughterhouse,
    @required required this.idRancher,
    @required required this.idProduct,
  });

  static final Map<String, String> _fields = {
    'id': Constants.bigint,
    'numTicket': Constants.bigint,
    'series': Constants.varchar['4']!,
    'deliveryTicket': Constants.varchar['255']!,
    'date': Constants.datetime,
    'idDriver': Constants.bigint,
    'idVehicleRegistration': Constants.bigint,
    'idSlaughterhouse': Constants.bigint,
    'idRancher': Constants.bigint,
    'idProduct': Constants.bigint,
  };

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numTicket': numTicket,
      'series': series,
      'deliveryTicket': deliveryTicket,
      'date': date?.toString(),
      'idDriver': idDriver,
      'idVehicleRegistration': idVehicleRegistration,
      'idSlaughterhouse': idSlaughterhouse,
      'idRancher': idRancher,
      'idProduct': idProduct,
    };
  }

  factory DeliveryTicket.fromRawJson(String str) =>
      DeliveryTicket.fromMap(json.decode(str));

  static DeliveryTicket fromMap(Map<String, dynamic> map) {
    return DeliveryTicket.all(
      id: map['id'],
      numTicket: map['numTicket'],
      series: map['series'],
      deliveryTicket: map['deliveryTicket'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
      idDriver: map['idDriver'],
      idVehicleRegistration: map['idVehicleRegistration'],
      idSlaughterhouse: map['idSlaughterhouse'],
      idRancher: map['idRancher'],
      idProduct: map['idProduct'],
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

    return other is DeliveryTicket &&
        other.id == id &&
        other.numTicket == numTicket &&
        other.series == series &&
        other.deliveryTicket == deliveryTicket &&
        other.date == date &&
        other.idDriver == idDriver &&
        other.idVehicleRegistration == idVehicleRegistration &&
        other.idSlaughterhouse == idSlaughterhouse &&
        other.idRancher == idRancher &&
        other.idProduct == idProduct;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        numTicket.hashCode ^
        series.hashCode ^
        deliveryTicket.hashCode ^
        date.hashCode ^
        idDriver.hashCode ^
        idVehicleRegistration.hashCode ^
        idSlaughterhouse.hashCode ^
        idRancher.hashCode ^
        idProduct.hashCode;
  }
}
