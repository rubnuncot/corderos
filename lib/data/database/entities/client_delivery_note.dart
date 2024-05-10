import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';
import 'package:sqflite_simple_dao_backend/database/params/constants.dart';
import '!!model_dao.dart';

@reflector
class ClientDeliveryNote extends ModelDao {
  DateTime? date;
  int? clientId;
  int? slaughterhouseId;
  int? idProduct;
  String? series;
  int? number;
  bool? isSend;

  ClientDeliveryNote();

  ClientDeliveryNote.all({
    int? id,
    @required required this.series,
    @required required this.number,
    @required required this.date,
    @required required this.clientId,
    @required required this.slaughterhouseId,
    @required required this.idProduct,
    @required required this.isSend,
  }){
    super.id = id;
  }

  static final Map<String, String> _fields = {
    'id': Constants.bigint,
    'series': Constants.varchar['4']!,
    'number': Constants.integer,
    'date': Constants.datetime,
    'clientId': Constants.bigint,
    'slaughterhouseId': Constants.bigint,
    'idProduct': Constants.bigint,
    'isSend': Constants.boolean,
  };

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date?.toString(),
      'clientId': clientId,
      'slaughterhouseId': slaughterhouseId,
      'idProduct': idProduct,
      'isSend': isSend,
    };
  }

  factory ClientDeliveryNote.fromRawJson(String str) =>
      ClientDeliveryNote.fromJson(json.decode(str));

  factory ClientDeliveryNote.fromJson(Map<String, dynamic> map) {
    return ClientDeliveryNote.all(
      id: map['id'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
      clientId: map['clientId'],
      number: map['number'],
      series: map['series'],
      slaughterhouseId: map['slaughterhouseId'],
      idProduct: map['idProduct'],
      isSend: map['isSend'] == 0 ? false : true,
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
        other.date == date &&
        other.series == series &&
        other.number == number &&
        other.clientId == clientId &&
        other.slaughterhouseId == slaughterhouseId &&
        other.idProduct == idProduct &&
        other.isSend == isSend;
  }

  @override
  int get hashCode {
    return
    date.hashCode ^
    clientId.hashCode ^
    series.hashCode ^
    number.hashCode ^
    slaughterhouseId.hashCode ^
    idProduct.hashCode ^
    isSend.hashCode;
  }

  @override
  String toString() {
    return '$date\t$clientId\t$slaughterhouseId\t$idProduct';
  }
}
