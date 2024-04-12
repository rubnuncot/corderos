import 'dart:convert';

import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';
import 'package:sqflite_simple_dao_backend/database/params/constants.dart';
import '!!model_dao.dart';

@reflector
class Changes extends ModelDao {
  int? id;
  DateTime? date;
  String? tableChanged;
  bool? isRead;

  Changes();

  Changes.all({this.id, this.date, this.tableChanged, this.isRead});

  static final Map<String, String> _fields = {
    'id': Constants.bigint,
    'date': Constants.datetime,
    'tableChanged': Constants.varchar['100']!,
    'isRead': Constants.boolean,
  };

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toString(),
      'tableChanged': tableChanged,
      'isRead': isRead,
    };
  }

  factory Changes.fromRawJson(String str) => Changes.fromMap(json.decode(str));

  static Changes fromMap(Map<String, dynamic> map) {
    return Changes.all(
      id: map['id'],
      date: map['date'],
      tableChanged: map['tableChanged'],
      isRead: map['isRead'],
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

    return other is Changes &&
        other.id == id &&
        other.isRead == isRead &&
        other.date == date &&
        other.tableChanged == tableChanged;
  }

  @override
  int get hashCode =>
      id.hashCode ^ isRead.hashCode ^ date.hashCode ^ tableChanged.hashCode;
}
