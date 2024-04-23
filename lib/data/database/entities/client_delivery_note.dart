import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';
import 'package:sqflite_simple_dao_backend/database/params/constants.dart';
import '!!model_dao.dart';

@reflector
class ClientDeliveryNote extends ModelDao {
  int? idDeliveryNote;
  DateTime? date;
  int? clientId;
  int? slaughterhouseId;
  int? productId;

  ClientDeliveryNote();

  ClientDeliveryNote.all({
    @required required this.idDeliveryNote,
    @required required this.date,
    @required required this.clientId,
    @required required this.slaughterhouseId,
    @required required this.productId,
  });

  static final Map<String, String> _fields = {
    'idDeliveryNote': Constants.bigint,
    'date': Constants.datetime,
    'clientId': Constants.bigint,
    'slaughterhouseId': Constants.bigint,
    'productId': Constants.bigint,
  };

  Map<String, dynamic> toJson() {
    return {
      'idDeliveryNote': idDeliveryNote,
      'date': date?.toString(),
      'clientId': clientId,
      'slaughterhouseId': slaughterhouseId,
      'productId': productId,
    };
  }

  factory ClientDeliveryNote.fromRawJson(String str) =>
      ClientDeliveryNote.fromJson(json.decode(str));

  factory ClientDeliveryNote.fromJson(Map<String, dynamic> map) {
    return ClientDeliveryNote.all(
      idDeliveryNote: map['idDeliveryNote'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
      clientId: map['clientId'],
      slaughterhouseId: map['slaughterhouseId'],
      productId: map['productId'],
    );
  }

  static final Iterable<String> _names = _fields.keys;

  static final List<String> _primary = [_names.elementAt(0)];

  static final List<String> _exception = [];

  static final List<String> _foreign = [];

  static List<String> get primary => _primary;

  static List<String> get foreign => _foreign;

  static List<String> get exception => _exception;

  static Map<String, dynamic> get fields => _fields;

  static Iterable<String> get names => _names;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ClientDeliveryNote &&
        other.idDeliveryNote == idDeliveryNote &&
        other.date == date &&
        other.clientId == clientId &&
        other.slaughterhouseId == slaughterhouseId &&
        other.productId == productId;
  }

  @override
  int get hashCode {
    return idDeliveryNote.hashCode ^
    date.hashCode ^
    clientId.hashCode ^
    slaughterhouseId.hashCode ^
    productId.hashCode;
  }

  @override
  String toString() {
    return '$date\t$clientId\t$slaughterhouseId\t$productId';
  }
}
