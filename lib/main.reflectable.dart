// This file has been generated by the reflectable package.
// https://github.com/dart-lang/reflectable.

import 'dart:core';
import 'package:corderos_app/data/database/entities/category.dart' as prefix1;
import 'package:corderos_app/data/database/entities/client.dart' as prefix2;
import 'package:corderos_app/data/database/entities/driver.dart' as prefix3;
import 'package:corderos_app/data/database/entities/product.dart' as prefix4;
import 'package:corderos_app/data/database/entities/rancher.dart' as prefix5;
import 'package:corderos_app/data/database/entities/slaughterhouse.dart'
    as prefix6;
import 'package:corderos_app/data/database/entities/ticket.dart' as prefix7;
import 'package:corderos_app/data/database/entities/vehicle_registration.dart'
    as prefix8;
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart'
    as prefix0;

// ignore_for_file: camel_case_types
// ignore_for_file: implementation_imports
// ignore_for_file: prefer_adjacent_string_concatenation
// ignore_for_file: prefer_collection_literals
// ignore_for_file: unnecessary_const
// ignore_for_file: unused_import

import 'package:reflectable/mirrors.dart' as m;
import 'package:reflectable/src/reflectable_builder_based.dart' as r;
import 'package:reflectable/reflectable.dart' as r show Reflectable;

final _data = <r.Reflectable, r.ReflectorData>{
  const prefix0.MyReflectable(): r.ReflectorData(
      <m.TypeMirror>[
        r.NonGenericClassMirrorImpl(
            r'Category',
            r'.Category',
            134217735,
            0,
            const prefix0.MyReflectable(),
            const <int>[4],
            const <int>[
              5,
              6,
              7,
              8,
              9,
              10,
              11,
              12,
              13,
              14,
              15,
              16,
              17,
              18,
              19,
              20,
              21,
              22,
              23,
              24
            ],
            const <int>[],
            -1,
            {},
            {},
            {r'': (bool b) => () => b ? prefix1.Category() : null},
            -1,
            -1,
            const <int>[-1],
            null,
            null),
        r.NonGenericClassMirrorImpl(
            r'Client',
            r'.Client',
            134217735,
            1,
            const prefix0.MyReflectable(),
            const <int>[25],
            const <int>[
              5,
              6,
              7,
              8,
              9,
              10,
              11,
              12,
              13,
              14,
              15,
              16,
              17,
              18,
              19,
              20,
              21,
              22,
              23,
              24
            ],
            const <int>[],
            -1,
            {},
            {},
            {r'': (bool b) => () => b ? prefix2.Client() : null},
            -1,
            -1,
            const <int>[-1],
            null,
            null),
        r.NonGenericClassMirrorImpl(
            r'Driver',
            r'.Driver',
            134217735,
            2,
            const prefix0.MyReflectable(),
            const <int>[26],
            const <int>[
              5,
              6,
              7,
              8,
              9,
              10,
              11,
              12,
              13,
              14,
              15,
              16,
              17,
              18,
              19,
              20,
              21,
              22,
              23,
              24
            ],
            const <int>[],
            -1,
            {},
            {},
            {r'': (bool b) => () => b ? prefix3.Driver() : null},
            -1,
            -1,
            const <int>[-1],
            null,
            null),
        r.NonGenericClassMirrorImpl(
            r'Product',
            r'.Product',
            134217735,
            3,
            const prefix0.MyReflectable(),
            const <int>[27],
            const <int>[
              5,
              6,
              7,
              8,
              9,
              10,
              11,
              12,
              13,
              14,
              15,
              16,
              17,
              18,
              19,
              20,
              21,
              22,
              23,
              24
            ],
            const <int>[],
            -1,
            {},
            {},
            {r'': (bool b) => () => b ? prefix4.Product() : null},
            -1,
            -1,
            const <int>[-1],
            null,
            null),
        r.NonGenericClassMirrorImpl(
            r'Rancher',
            r'.Rancher',
            134217735,
            4,
            const prefix0.MyReflectable(),
            const <int>[28],
            const <int>[
              5,
              6,
              7,
              8,
              9,
              10,
              11,
              12,
              13,
              14,
              15,
              16,
              17,
              18,
              19,
              20,
              21,
              22,
              23,
              24
            ],
            const <int>[],
            -1,
            {},
            {},
            {r'': (bool b) => () => b ? prefix5.Rancher() : null},
            -1,
            -1,
            const <int>[-1],
            null,
            null),
        r.NonGenericClassMirrorImpl(
            r'Slaughterhouse',
            r'.Slaughterhouse',
            134217735,
            5,
            const prefix0.MyReflectable(),
            const <int>[0, 1, 29, 30, 31, 36, 37, 38, 39, 40, 41, 42, 43, 44],
            const <int>[
              31,
              6,
              7,
              41,
              9,
              10,
              11,
              12,
              13,
              14,
              15,
              16,
              17,
              18,
              19,
              20,
              21,
              22,
              23,
              24,
              29,
              32,
              33,
              34,
              35
            ],
            const <int>[30, 36, 37, 38, 39, 40],
            -1,
            {
              r'fromMap': () => prefix6.Slaughterhouse.fromMap,
              r'foreign': () => prefix6.Slaughterhouse.foreign,
              r'fields': () => prefix6.Slaughterhouse.fields,
              r'names': () => prefix6.Slaughterhouse.names,
              r'primary': () => prefix6.Slaughterhouse.primary,
              r'exception': () => prefix6.Slaughterhouse.exception
            },
            {},
            {
              r'': (bool b) => () => b ? prefix6.Slaughterhouse() : null,
              r'all': (bool b) => ({id, name}) =>
                  b ? prefix6.Slaughterhouse.all(id: id, name: name) : null,
              r'fromRawJson': (bool b) =>
                  (str) => b ? prefix6.Slaughterhouse.fromRawJson(str) : null
            },
            -1,
            -1,
            const <int>[-1],
            null,
            null),
        r.NonGenericClassMirrorImpl(
            r'Ticket',
            r'.Ticket',
            134217735,
            6,
            const prefix0.MyReflectable(),
            const <int>[45],
            const <int>[
              5,
              6,
              7,
              8,
              9,
              10,
              11,
              12,
              13,
              14,
              15,
              16,
              17,
              18,
              19,
              20,
              21,
              22,
              23,
              24
            ],
            const <int>[],
            -1,
            {},
            {},
            {r'': (bool b) => () => b ? prefix7.Ticket() : null},
            -1,
            -1,
            const <int>[-1],
            null,
            null),
        r.NonGenericClassMirrorImpl(
            r'VehicleRegistration',
            r'.VehicleRegistration',
            134217735,
            7,
            const prefix0.MyReflectable(),
            const <int>[2, 3, 46, 47, 52, 53, 54, 55, 56, 57, 58, 59],
            const <int>[
              5,
              6,
              7,
              8,
              9,
              10,
              11,
              12,
              13,
              14,
              15,
              16,
              17,
              18,
              19,
              20,
              21,
              22,
              23,
              24,
              46,
              48,
              49,
              50,
              51
            ],
            const <int>[47, 52, 53, 54, 55, 56],
            -1,
            {
              r'fromMap': () => prefix8.VehicleRegistration.fromMap,
              r'foreign': () => prefix8.VehicleRegistration.foreign,
              r'fields': () => prefix8.VehicleRegistration.fields,
              r'names': () => prefix8.VehicleRegistration.names,
              r'primary': () => prefix8.VehicleRegistration.primary,
              r'exception': () => prefix8.VehicleRegistration.exception
            },
            {},
            {
              r'': (bool b) => () => b ? prefix8.VehicleRegistration() : null,
              r'all': (bool b) => ({id, registrationId}) => b
                  ? prefix8.VehicleRegistration.all(
                      id: id, registrationId: registrationId)
                  : null,
              r'fromRawJson': (bool b) => (str) =>
                  b ? prefix8.VehicleRegistration.fromRawJson(str) : null
            },
            -1,
            -1,
            const <int>[-1],
            null,
            null)
      ],
      <m.DeclarationMirror>[
        r.VariableMirrorImpl(r'id', 67239941, 5, const prefix0.MyReflectable(),
            -1, -1, -1, null, null),
        r.VariableMirrorImpl(r'name', 67239941, 5,
            const prefix0.MyReflectable(), -1, -1, -1, null, null),
        r.VariableMirrorImpl(r'id', 67239941, 7, const prefix0.MyReflectable(),
            -1, -1, -1, null, null),
        r.VariableMirrorImpl(r'registrationId', 67239941, 7,
            const prefix0.MyReflectable(), -1, -1, -1, null, null),
        r.MethodMirrorImpl(r'', 64, 0, -1, -1, -1, null, const <int>[],
            const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'==', 2097154, -1, -1, -1, -1, null, const <int>[0],
            const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'toString', 2097154, -1, -1, -1, -1, null,
            const <int>[], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'noSuchMethod', 524290, -1, -1, -1, -1, null,
            const <int>[1], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'hashCode', 2097155, -1, -1, -1, -1, null,
            const <int>[], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'runtimeType', 2097155, -1, -1, -1, -1, null,
            const <int>[], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'getDatabase', 35651586, -1, -1, -1, -1, null,
            const <int>[], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'getTableName', 2097154, -1, -1, -1, -1, null,
            const <int>[2], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'makeWhere', 2097154, -1, -1, -1, -1, null,
            const <int>[3, 4, 5], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'batchInsert', 35651586, -1, -1, -1, -1, null,
            const <int>[6, 7], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'batchInsertOrUpdate', 35651586, -1, -1, -1, -1,
            null, const <int>[8], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'batchInsertOrDelete', 35651586, -1, -1, -1, -1,
            null, const <int>[9], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'insertSingle', 35651586, -1, -1, -1, -1, null,
            const <int>[10], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'batchUpdate', 35651586, -1, -1, -1, -1, null,
            const <int>[11], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'updateSingle', 35651586, -1, -1, -1, -1, null,
            const <int>[12], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'batchDelete', 35651586, -1, -1, -1, -1, null,
            const <int>[13], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'deleteSingle', 35651586, -1, -1, -1, -1, null,
            const <int>[14], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'select', 35651586, -1, -1, -1, -1, null,
            const <int>[15, 16, 17], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'insert', 35651586, -1, -1, -1, -1, null,
            const <int>[], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'update', 35651586, -1, -1, -1, -1, null,
            const <int>[], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'delete', 35651586, -1, -1, -1, -1, null,
            const <int>[], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'', 64, 1, -1, -1, -1, null, const <int>[],
            const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'', 64, 2, -1, -1, -1, null, const <int>[],
            const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'', 64, 3, -1, -1, -1, null, const <int>[],
            const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'', 64, 4, -1, -1, -1, null, const <int>[],
            const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'toMap', 35651586, 5, -1, -1, -1, null,
            const <int>[], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'fromMap', 2097170, 5, 5, -1, -1, null,
            const <int>[18], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'==', 2097154, 5, -1, -1, -1, null, const <int>[19],
            const prefix0.MyReflectable(), null),
        r.ImplicitGetterMirrorImpl(const prefix0.MyReflectable(), 0, 32),
        r.ImplicitSetterMirrorImpl(const prefix0.MyReflectable(), 0, 33),
        r.ImplicitGetterMirrorImpl(const prefix0.MyReflectable(), 1, 34),
        r.ImplicitSetterMirrorImpl(const prefix0.MyReflectable(), 1, 35),
        r.MethodMirrorImpl(r'foreign', 35651603, 5, -1, -1, -1, null,
            const <int>[], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'fields', 35651603, 5, -1, -1, -1, null,
            const <int>[], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'names', 35651603, 5, -1, -1, -1, null,
            const <int>[], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'primary', 35651603, 5, -1, -1, -1, null,
            const <int>[], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'exception', 35651603, 5, -1, -1, -1, null,
            const <int>[], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'hashCode', 2097155, 5, -1, -1, -1, null,
            const <int>[], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'', 0, 5, -1, -1, -1, null, const <int>[],
            const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'all', 0, 5, -1, -1, -1, null, const <int>[20, 21],
            const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'fromRawJson', 1, 5, -1, -1, -1, null,
            const <int>[22], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'', 64, 6, -1, -1, -1, null, const <int>[],
            const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'toMap', 35651586, 7, -1, -1, -1, null,
            const <int>[], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'fromMap', 2097170, 7, 7, -1, -1, null,
            const <int>[25], const prefix0.MyReflectable(), null),
        r.ImplicitGetterMirrorImpl(const prefix0.MyReflectable(), 2, 48),
        r.ImplicitSetterMirrorImpl(const prefix0.MyReflectable(), 2, 49),
        r.ImplicitGetterMirrorImpl(const prefix0.MyReflectable(), 3, 50),
        r.ImplicitSetterMirrorImpl(const prefix0.MyReflectable(), 3, 51),
        r.MethodMirrorImpl(r'foreign', 35651603, 7, -1, -1, -1, null,
            const <int>[], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'fields', 35651603, 7, -1, -1, -1, null,
            const <int>[], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'names', 35651603, 7, -1, -1, -1, null,
            const <int>[], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'primary', 35651603, 7, -1, -1, -1, null,
            const <int>[], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'exception', 35651603, 7, -1, -1, -1, null,
            const <int>[], const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'', 0, 7, -1, -1, -1, null, const <int>[],
            const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'all', 0, 7, -1, -1, -1, null, const <int>[26, 27],
            const prefix0.MyReflectable(), null),
        r.MethodMirrorImpl(r'fromRawJson', 1, 7, -1, -1, -1, null,
            const <int>[28], const prefix0.MyReflectable(), null)
      ],
      <m.ParameterMirror>[
        r.ParameterMirrorImpl(r'other', 134348806, 5,
            const prefix0.MyReflectable(), -1, -1, -1, null, null, null, null),
        r.ParameterMirrorImpl(r'invocation', 134348806, 7,
            const prefix0.MyReflectable(), -1, -1, -1, null, null, null, null),
        r.ParameterMirrorImpl(r'obj', 67141638, 11,
            const prefix0.MyReflectable(), -1, -1, -1, null, null, null, null),
        r.ParameterMirrorImpl(r'where', 134348806, 12,
            const prefix0.MyReflectable(), -1, -1, -1, null, null, null, null),
        r.ParameterMirrorImpl(r'x', 134348806, 12,
            const prefix0.MyReflectable(), -1, -1, -1, null, null, null, null),
        r.ParameterMirrorImpl(r'primary', 151126022, 12,
            const prefix0.MyReflectable(), -1, -1, -1, null, null, null, null),
        r.ParameterMirrorImpl(
            r'objectsToInsert',
            151134214,
            13,
            const prefix0.MyReflectable(),
            -1,
            -1,
            -1,
            null,
            null,
            null,
            #objectsToInsert),
        r.ParameterMirrorImpl(
            r'orUpdate',
            134363142,
            13,
            const prefix0.MyReflectable(),
            -1,
            -1,
            -1,
            null,
            null,
            false,
            #orUpdate),
        r.ParameterMirrorImpl(
            r'objects',
            151134214,
            14,
            const prefix0.MyReflectable(),
            -1,
            -1,
            -1,
            null,
            null,
            null,
            #objects),
        r.ParameterMirrorImpl(
            r'objects',
            151134214,
            15,
            const prefix0.MyReflectable(),
            -1,
            -1,
            -1,
            null,
            null,
            null,
            #objects),
        r.ParameterMirrorImpl(
            r'objectToInsert',
            67149830,
            16,
            const prefix0.MyReflectable(),
            -1,
            -1,
            -1,
            null,
            null,
            null,
            #objectToInsert),
        r.ParameterMirrorImpl(
            r'objectsToUpdate',
            151134214,
            17,
            const prefix0.MyReflectable(),
            -1,
            -1,
            -1,
            null,
            null,
            null,
            #objectsToUpdate),
        r.ParameterMirrorImpl(
            r'objectToUpdate',
            67149830,
            18,
            const prefix0.MyReflectable(),
            -1,
            -1,
            -1,
            null,
            null,
            null,
            #objectToUpdate),
        r.ParameterMirrorImpl(
            r'objectsToDelete',
            151134214,
            19,
            const prefix0.MyReflectable(),
            -1,
            -1,
            -1,
            null,
            null,
            null,
            #objectsToDelete),
        r.ParameterMirrorImpl(
            r'objectToDelete',
            67149830,
            20,
            const prefix0.MyReflectable(),
            -1,
            -1,
            -1,
            null,
            null,
            null,
            #objectToDelete),
        r.ParameterMirrorImpl(
            r'sqlBuilder',
            134356998,
            21,
            const prefix0.MyReflectable(),
            -1,
            -1,
            -1,
            null,
            null,
            null,
            #sqlBuilder),
        r.ParameterMirrorImpl(
            r'print',
            134363142,
            21,
            const prefix0.MyReflectable(),
            -1,
            -1,
            -1,
            null,
            null,
            false,
            #print),
        r.ParameterMirrorImpl(
            r'model',
            67153926,
            21,
            const prefix0.MyReflectable(),
            -1,
            -1,
            -1,
            null,
            null,
            null,
            #model),
        r.ParameterMirrorImpl(r'map', 151126022, 30,
            const prefix0.MyReflectable(), -1, -1, -1, null, null, null, null),
        r.ParameterMirrorImpl(r'other', 134348806, 31,
            const prefix0.MyReflectable(), -1, -1, -1, null, null, null, null),
        r.ParameterMirrorImpl(r'id', 67253254, 43,
            const prefix0.MyReflectable(), -1, -1, -1, null, null, null, #id),
        r.ParameterMirrorImpl(r'name', 67253254, 43,
            const prefix0.MyReflectable(), -1, -1, -1, null, null, null, #name),
        r.ParameterMirrorImpl(r'str', 134348806, 44,
            const prefix0.MyReflectable(), -1, -1, -1, null, null, null, null),
        r.ParameterMirrorImpl(r'_id', 67240038, 33,
            const prefix0.MyReflectable(), -1, -1, -1, null, null, null, null),
        r.ParameterMirrorImpl(r'_name', 67240038, 35,
            const prefix0.MyReflectable(), -1, -1, -1, null, null, null, null),
        r.ParameterMirrorImpl(r'map', 151126022, 47,
            const prefix0.MyReflectable(), -1, -1, -1, null, null, null, null),
        r.ParameterMirrorImpl(r'id', 67249158, 58,
            const prefix0.MyReflectable(), -1, -1, -1, null, null, null, #id),
        r.ParameterMirrorImpl(
            r'registrationId',
            67249158,
            58,
            const prefix0.MyReflectable(),
            -1,
            -1,
            -1,
            null,
            null,
            null,
            #registrationId),
        r.ParameterMirrorImpl(r'str', 134348806, 59,
            const prefix0.MyReflectable(), -1, -1, -1, null, null, null, null),
        r.ParameterMirrorImpl(r'_id', 67240038, 49,
            const prefix0.MyReflectable(), -1, -1, -1, null, null, null, null),
        r.ParameterMirrorImpl(r'_registrationId', 67240038, 51,
            const prefix0.MyReflectable(), -1, -1, -1, null, null, null, null)
      ],
      <Type>[
        prefix1.Category,
        prefix2.Client,
        prefix3.Driver,
        prefix4.Product,
        prefix5.Rancher,
        prefix6.Slaughterhouse,
        prefix7.Ticket,
        prefix8.VehicleRegistration
      ],
      8,
      {
        r'==': (dynamic instance) => (x) => instance == x,
        r'toString': (dynamic instance) => instance.toString,
        r'noSuchMethod': (dynamic instance) => instance.noSuchMethod,
        r'hashCode': (dynamic instance) => instance.hashCode,
        r'runtimeType': (dynamic instance) => instance.runtimeType,
        r'getDatabase': (dynamic instance) => instance.getDatabase,
        r'getTableName': (dynamic instance) => instance.getTableName,
        r'makeWhere': (dynamic instance) => instance.makeWhere,
        r'batchInsert': (dynamic instance) => instance.batchInsert,
        r'batchInsertOrUpdate': (dynamic instance) =>
            instance.batchInsertOrUpdate,
        r'batchInsertOrDelete': (dynamic instance) =>
            instance.batchInsertOrDelete,
        r'insertSingle': (dynamic instance) => instance.insertSingle,
        r'batchUpdate': (dynamic instance) => instance.batchUpdate,
        r'updateSingle': (dynamic instance) => instance.updateSingle,
        r'batchDelete': (dynamic instance) => instance.batchDelete,
        r'deleteSingle': (dynamic instance) => instance.deleteSingle,
        r'select': (dynamic instance) => instance.select,
        r'insert': (dynamic instance) => instance.insert,
        r'update': (dynamic instance) => instance.update,
        r'delete': (dynamic instance) => instance.delete,
        r'toMap': (dynamic instance) => instance.toMap,
        r'id': (dynamic instance) => instance.id,
        r'name': (dynamic instance) => instance.name,
        r'registrationId': (dynamic instance) => instance.registrationId
      },
      {
        r'id=': (dynamic instance, value) => instance.id = value,
        r'name=': (dynamic instance, value) => instance.name = value,
        r'registrationId=': (dynamic instance, value) =>
            instance.registrationId = value
      },
      null,
      [])
};

const _memberSymbolMap = null;

void initializeReflectable() {
  r.data = _data;
  r.memberSymbolMap = _memberSymbolMap;
}
