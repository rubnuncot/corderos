import 'package:bloc/bloc.dart';
import 'package:corderos_app/data/!data.dart';
import 'package:sqflite_simple_dao_backend/database/database/sql_builder.dart';

part 'ticket_event.dart';

part 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  TicketBloc() : super(TicketLoading()) {
    on<GetAllProductDeliveryNotes>((event, emit) async {
      emit(TicketLoading());

      try {
        ProductDeliveryNote productDeliveryNote = ProductDeliveryNote();
        List<String> whereClause = [];
        List<ProductDeliveryNote> productDeliveryNotes = [];

        productDeliveryNotes = whereClause.isEmpty
            ? await productDeliveryNote.selectAll() as List<ProductDeliveryNote>
            : await productDeliveryNote.select(
                    sqlBuilder: SqlBuilder()
                        .querySelect(fields: ["*"])
                        .queryFrom(table: productDeliveryNote.getTableName(productDeliveryNote))
                        .queryWhere(conditions: whereClause)) as List<ProductDeliveryNote>;

        emit(TicketSuccess('Tickets de productos obtenidos correctamente', [productDeliveryNotes], "GetAllProductDeliveryNotes"));
      } catch (e) {
        emit(TicketError(
            'Ha ocurrido un error a la hora de obtener los tickets'));
      }
    });
  }
}
