import 'dart:convert';
import 'dart:ffi';

import 'package:meta/meta.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';
import 'package:sqflite_simple_dao_backend/database/params/constants.dart';
import '!!model_dao.dart';

@reflector
class DeliveryTicket extends ModelDao {
  String? deliveryTicket;
  DateTime? date;
  int? idDriver;
  int? idVehicleRegistration;
  int? idSlaughterhouse;
  int? idRancher;
  int? idProduct;
  int? number;
  bool? isSend;

  DeliveryTicket();

  DeliveryTicket.all({
    int? id,
    @required required this.number,
    @required required this.deliveryTicket,
    @required required this.date,
    @required required this.idDriver,
    @required required this.idVehicleRegistration,
    @required required this.idSlaughterhouse,
    @required required this.idRancher,
    @required required this.idProduct,
    @required required this.isSend,
  }){
    super.id = id;
  }

  static final Map<String, String> _fields = {
    'id': Constants.bigint,
    'number': Constants.integer,
    'date': Constants.datetime,
    'idDriver': Constants.bigint,
    'idVehicleRegistration': Constants.bigint,
    'idSlaughterhouse': Constants.bigint,
    'idRancher': Constants.bigint,
    'idProduct': Constants.bigint,
    'deliveryTicket': Constants.varchar['255']!,
    'isSend': Constants.boolean,
  };

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'deliveryTicket': deliveryTicket,
      'date': date?.toString(),
      'idDriver': idDriver,
      'idVehicleRegistration': idVehicleRegistration,
      'idSlaughterhouse': idSlaughterhouse,
      'idRancher': idRancher,
      'idProduct': idProduct,
      'isSend': isSend,
    };
  }

  factory DeliveryTicket.fromRawJson(String str) =>
      DeliveryTicket.fromJson(json.decode(str));

  factory DeliveryTicket.fromJson(Map<String, dynamic> map) {
    return DeliveryTicket.all(
      id: map['id'],
      number: map['number'],
      deliveryTicket: map['deliveryTicket'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
      idDriver: map['idDriver'],
      idVehicleRegistration: map['idVehicleRegistration'],
      idSlaughterhouse: map['idSlaughterhouse'],
      idRancher: map['idRancher'],
      idProduct: map['idProduct'],
      isSend: map['isSend'] == 0 ? false : true,
    );
  }

  static final Iterable<String> _names = _fields.keys;

  static final List<String> _primary = [
    _names.elementAt(0),
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
        other.id != id &&
        other.deliveryTicket == deliveryTicket &&
        other.number == number &&
        other.date == date &&
        other.idDriver == idDriver &&
        other.idVehicleRegistration == idVehicleRegistration &&
        other.idSlaughterhouse == idSlaughterhouse &&
        other.idRancher == idRancher &&
        other.idProduct == idProduct &&
        other.isSend == isSend;
  }

  @override
  int get hashCode {
    return
        deliveryTicket.hashCode ^
        number.hashCode ^
        number.hashCode ^
        idDriver.hashCode ^
        idVehicleRegistration.hashCode ^
        idSlaughterhouse.hashCode ^
        idRancher.hashCode ^
        idProduct.hashCode ^
        isSend.hashCode;
  }

  @override
  String toString() {
    return '$date\t$idDriver\t$idVehicleRegistration\t$idSlaughterhouse\t$idRancher\t$idProduct';
  }
}
