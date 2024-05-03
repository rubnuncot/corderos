import 'package:bloc/bloc.dart';
import 'package:corderos_app/!helpers/print_helper.dart';
import 'package:corderos_app/data/!data.dart';
import 'package:corderos_app/data/preferences/preferences.dart';
import 'package:sqflite_simple_dao_backend/database/database/sql_builder.dart';

import '../../../data/database/entities/changes.dart';

part 'burden_state.dart';

part 'burden_event.dart';

class BurdenBloc extends Bloc<BurdenEvent, BurdenState> {
  BurdenBloc() : super(BurdenLoading()) {
    on<GetChanges>((event, emit) async {
      emit(BurdenLoading());

      try {
        String and = SqlBuilder.constOperators['and']!;

        Changes change = Changes();
        List<String> whereClause = [];
        List<Change> changes = [];

        Map<String, Iterable<String>> eventData = {
          "date_${event.date}": ["date LIKE '%${event.date}%'", and],
          "tableChanged_${event.tableChanged}": [
            "tableChanged LIKE '%${event.tableChanged}%'",
            and
          ],
          "isRead${event.isRead}": ["isRead LIKE '%${event.isRead}%'", and],
        };

        getConditions(eventData);

        changes = whereClause.isEmpty
            ? await change.selectAll() as List<Change>
            : await change.select(
                sqlBuilder: SqlBuilder()
                    .querySelect(fields: ["*"])
                    .queryFrom(table: change.getTableName(change))
                    .queryWhere(conditions: whereClause)) as List<Change>;

        emit(BurdenSuccess('Cambios de tabla obtenidos correctamente.',
            [changes], "GetChanges"));
      } catch (e) {
        print(e);
      }
    });

    on<GetProductTickets>((event, emit) async {
      emit(BurdenLoading());

      try {
        ProductTicket productTicket = ProductTicket();
        List<String> whereClause = [];
        List<ProductTicket> productTickets = [];

        Map<String, Iterable<String>> eventData = {};

        getConditions(eventData);

        productTickets = whereClause.isEmpty
            ? await productTicket.selectAll() as List<ProductTicket>
            : await productTicket.select(
                sqlBuilder: SqlBuilder()
                    .querySelect(fields: ["*"])
                    .queryFrom(table: productTicket.getTableName(productTicket))
                    .queryWhere(
                        conditions: whereClause)) as List<ProductTicket>;

        emit(BurdenSuccess('Albarán de productos obtenidos correctamente.',
            [productTickets], "GetProductTickets"));
      } catch (e) {
        print(e);
      }
    });

    on<GetTableIndex>((event, emit) async {
      emit(BurdenLoading());

      try {
        final tableIndex = await Preferences.getValue('last_saved_tablet_id');

        emit(BurdenSuccess(
            'Índice de tabla obtenido correctamente',
            [
              [tableIndex]
            ],
            "GetTableIndex"));
      } catch (e) {
        print(e);
      }
    });

    on<IncrementTableIndex>((event, emit) async {
      emit(BurdenLoading());
      const key = 'last_saved_tablet_id';
      dynamic currentTableIndex;

      try {
        currentTableIndex = await Preferences.getValue(key);
        currentTableIndex += 1;
        await Preferences.setValue(key, currentTableIndex);

        emit(BurdenSuccess(
            'índice de tabla actualizado correctamente',
            [
              [currentTableIndex]
            ],
            "IncrementTableIndex"));
      } catch (e) {
        print(e);
      }
    });

    on<UploadData>((event, emit) async {
      emit(BurdenLoading());

      PrintHelper printHelper = PrintHelper();

      try {
        event.deliveryTicket!.insert();
        event.productDeliveryNote!.insert();

        emit(BurdenSuccess(
            'Carga guardada correctamente. Imprimiendo ticket...', [[200]],
            "UploadData"));
      } catch (e) {
        emit(BurdenError('Ha ocurrido un error a la hora de crear la carga.'));
      }
    });
  }

  List<String> getConditions(Map<String, Iterable<String>> eventData) {
    List<String> conditions = [];
    for (String key in eventData.keys) {
      if (key.contains("none")) {
        for (var condition in eventData[key]!) {
          conditions.add(condition);
        }
      }
    }
    conditions.removeLast();
    return conditions;
  }
}
