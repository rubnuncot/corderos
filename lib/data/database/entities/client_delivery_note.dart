import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';
import 'package:sqflite_simple_dao_backend/database/params/constants.dart';
import '!!model_dao.dart';

@reflector
class ClientDeliveryNote extends ModelDao {
  int? idDeliveryNote;
  DateTime? date;
  int? slaughterhouseId;
  int? productId;

  ClientDeliveryNote();

  ClientDeliveryNote.all({
    @required required this.idDeliveryNote,
    @required required this.date,
    @required required this.slaughterhouseId,
    @required required this.productId,
  });

  static final Map<String, String> _fields = {
    'idDeliveryNote': Constants.bigint,
    'date': Constants.datetime,
    'slaughterhouseId': Constants.bigint,
    'productId': Constants.bigint,
  };

  Map<String, dynamic> toMap() {
    return {
      'idDeliveryNote': idDeliveryNote,
      'date': date?.toString(),
      'slaughterhouseId': slaughterhouseId,
      'productId': productId,
    };
  }

  factory ClientDeliveryNote.fromRawJson(String str) =>
      ClientDeliveryNote.fromMap(json.decode(str));

  static ClientDeliveryNote fromMap(Map<String, dynamic> map) {
    return ClientDeliveryNote.all(
      idDeliveryNote: map['idDeliveryNote'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
      slaughterhouseId: map['slaughterhouseId'],
      productId: map['productId'],
    );
  }

  static final Iterable<String> _names = _fields.keys;

  static final List<String> _primary = [_names.elementAt(0)];

  static List<String> get primary => _primary;

  static Map<String, dynamic> get fields => _fields;

  static Iterable<String> get names => _names;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ClientDeliveryNote &&
        other.idDeliveryNote == idDeliveryNote &&
        other.date == date &&
        other.slaughterhouseId == slaughterhouseId &&
        other.productId == productId;
  }

  @override
  int get hashCode {
    return idDeliveryNote.hashCode ^
    date.hashCode ^
    slaughterhouseId.hashCode ^
    productId.hashCode;
  }
}
