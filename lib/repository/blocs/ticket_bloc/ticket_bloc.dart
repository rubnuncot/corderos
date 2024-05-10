import 'package:bloc/bloc.dart';
import 'package:corderos_app/data/!data.dart';
import 'package:corderos_app/repository/!repository.dart';
import 'package:corderos_app/repository/data_conversion/!data_conversion.dart';
import 'package:sqflite_simple_dao_backend/database/database/sql_builder.dart';

part 'ticket_event.dart';

part 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  TicketBloc() : super(TicketLoading()) {
    List<DeliveryTicket> tickets = [];

    on<FetchTicketsScreen>((event, emit) async {
      emit(TicketLoading());
      try {
        tickets = await DeliveryTicket().selectAll<DeliveryTicket>();
        emit(TicketSuccess(
            message: 'Tickets recibidos con éxito',
            data: tickets,
            event: 'FetchTicketsScreen'));
      } catch (e) {
        emit(TicketError(
            'Ha ocurrido un error a la hora de cargar los tickets.'));
      }
    });

    on<SelectTicket>((event, emit) async {
      try {
        int selectedId = event.ticketId;
        var selectedDeliveryTicket = DeliveryTicket();

        var results = await DeliveryTicket().select(
            model: DeliveryTicket(),
            sqlBuilder: SqlBuilder()
                .querySelect(fields: ["*"])
                .queryFrom(
                    table: selectedDeliveryTicket
                        .getTableName(selectedDeliveryTicket))
                .queryWhere(conditions: [
                  'id',
                  SqlBuilder.constOperators['equals']!,
                  '$selectedId'
                ]));

        if (results.isNotEmpty) {
          selectedDeliveryTicket = results.first as DeliveryTicket;
          selectedDeliveryTicket.isSend = !selectedDeliveryTicket.isSend!;
          selectedDeliveryTicket.update();

          emit(TicketSuccess(
              message: 'Ticket seleccionado correctamente',
              data: [selectedDeliveryTicket],
              event: 'SelectTicket'));
        } else {
          throw Exception('No ticket found with id $selectedId');
        }
      } catch (e) {
        emit(TicketError(
            'Ha habido un error al seleccionar el ticket: ${e.toString()}'));
      }
    });

    on<DeleteTicket>((event, emit) async {
      try {
        int selectedId = event.ticketId;
        var selectedDeliveryTicket = DeliveryTicket();
        var selectedProductDeliveryNote = ProductDeliveryNote();

        selectedDeliveryTicket = (await DeliveryTicket().select(
                model: DeliveryTicket(),
                sqlBuilder: SqlBuilder()
                    .querySelect(fields: ["*"])
                    .queryFrom(
                        table: selectedDeliveryTicket
                            .getTableName(selectedDeliveryTicket))
                    .queryWhere(conditions: [
                      'id',
                      SqlBuilder.constOperators['equals']!,
                      '$selectedId'
                    ])))
            .first as DeliveryTicket;

        selectedProductDeliveryNote = (await ProductDeliveryNote().select(
                model: ProductDeliveryNote(),
                sqlBuilder: SqlBuilder()
                    .querySelect(fields: ["*"])
                    .queryFrom(
                        table: selectedProductDeliveryNote
                            .getTableName(selectedProductDeliveryNote))
                    .queryWhere(conditions: [
                      'idDeliveryNote',
                      SqlBuilder.constOperators['equals']!,
                      '$selectedId'
                    ])))
            .first as ProductDeliveryNote;

        selectedDeliveryTicket.delete();
        selectedProductDeliveryNote.delete();

        emit(TicketSuccess(
            message: 'Ticket borrado correctamente',
            data: [selectedDeliveryTicket],
            event: 'DeleteTicket'));

      } catch (e) {
        emit(TicketError('Ha habido un error al borrar el ticket'));
      }
    });

    /*
        !  ProductDeliveryNote:   DeliveryTicket:
        !  - Producto (nombre)    - number (para utilizarlo como identificador)
        !  - units                - date
        !  - nameClassification   - vehicleregistration
        !  - kilograms            - driver (name)
        !  - color                - rancher (name)
        */
    on<GetTicketInfo>((event, emit) async {
      emit(TicketLoading());

      try {

        int selectedId = event.ticketId;
        DeliveryTicketModel deliveryTicketModel = DeliveryTicketModel();
        var selectedProductDeliveryNote = ProductDeliveryNote();
        ProductDeliveryNoteModel productDeliveryNoteModel = ProductDeliveryNoteModel();

        await deliveryTicketModel.fromEntity(await DatabaseRepository.getEntityById(DeliveryTicket(), selectedId));

        selectedProductDeliveryNote = (await ProductDeliveryNote().select(
            model: ProductDeliveryNote(),
            sqlBuilder: SqlBuilder()
                .querySelect(fields: ["*"])
                .queryFrom(
                table: selectedProductDeliveryNote
                    .getTableName(selectedProductDeliveryNote))
                .queryWhere(conditions: [
              'idDeliveryNote',
              SqlBuilder.constOperators['equals']!,
              '$selectedId'
            ])))
            .first as ProductDeliveryNote;

        await productDeliveryNoteModel.fromEntity(await selectedProductDeliveryNote.selectLast());

        emit(TicketSuccess(
          message: 'Tickets de productos obtenidos correctamente',
          data: [productDeliveryNoteModel, deliveryTicketModel],
          event: "GetTicketInfo",
        ));
      } catch (e) {
        emit(TicketError(
            'Ha ocurrido un error a la hora de obtener los tickets'));
      }
    });
  }
}
