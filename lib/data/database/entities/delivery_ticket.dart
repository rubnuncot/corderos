import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';
import 'package:sqflite_simple_dao_backend/database/params/constants.dart';
import '!!model_dao.dart';

@reflector
class DeliveryTicker extends ModelDao {
  String? numTicket;
  String? serie;
  String? deliveryTicket;
  DateTime? date;
  int? idDriver;
  int? idVehicleRegistration;
  int? idSlaughterhouse;
  int? idRancher;
  int? idProduct;

  DeliveryTicker();

  DeliveryTicker.all({
    @required required this.numTicket,
    @required required this.serie,
    @required required this.deliveryTicket,
    @required required this.date,
    @required required this.idDriver,
    @required required this.idVehicleRegistration,
    @required required this.idSlaughterhouse,
    @required required this.idRancher,
    @required required this.idProduct,
  });

  static final Map<String, String> _fields = {
    'numTicket': Constants.bigint,
    'serie': Constants.varchar['4']!,
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
      'serie': serie,
      'deliveryTicket': deliveryTicket,
      'date': date?.toString(),
      'idDriver': idDriver,
      'idVehicleRegistration': idVehicleRegistration,
      'idSlaughterhouse': idSlaughterhouse,
      'idRancher': idRancher,
      'idProduct': idProduct,
    };
  }

  factory DeliveryTicker.fromRawJson(String str) =>
      DeliveryTicker.fromMap(json.decode(str));

  static DeliveryTicker fromMap(Map<String, dynamic> map) {
    return DeliveryTicker.all(
      numTicket: map['numTicket'],
      serie: map['serie'],
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

  static final List<String> _primary = [_names.elementAt(0), _names.elementAt(1)];

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

    return other is DeliveryTicker &&
        other.numTicket == numTicket &&
        other.serie == serie &&
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
    return numTicket.hashCode ^
    serie.hashCode ^
    deliveryTicket.hashCode ^
    date.hashCode ^
    idDriver.hashCode ^
    idVehicleRegistration.hashCode ^
    idSlaughterhouse.hashCode ^
    idRancher.hashCode ^
    idProduct.hashCode;
  }
}
