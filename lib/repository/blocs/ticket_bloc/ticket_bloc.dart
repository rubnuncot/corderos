import 'package:bloc/bloc.dart';
import 'package:corderos_app/!helpers/!helpers.dart';
import 'package:corderos_app/!helpers/print_helper.dart';
import 'package:corderos_app/data/!data.dart';
import 'package:corderos_app/repository/!repository.dart';
import 'package:corderos_app/repository/data_conversion/!data_conversion.dart';
import 'package:flutter/cupertino.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
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
        var selectedProductTicket = ProductTicket();

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

        selectedProductTicket = (await ProductTicket().select(
            model: ProductTicket(),
            sqlBuilder: SqlBuilder()
                .querySelect(fields: ["*"])
                .queryFrom(
                table: selectedProductTicket
                    .getTableName(selectedProductTicket))
                .queryWhere(conditions: [
              'idTicket',
              SqlBuilder.constOperators['equals']!,
              '$selectedId'
            ])))
            .first as ProductTicket;

        selectedDeliveryTicket.delete();
        selectedProductTicket.delete();

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
        var selectedProductTicket = ProductTicket();
        ProductTicketModel productTicketModel =
        ProductTicketModel();

        await deliveryTicketModel.fromEntity(
            await DatabaseRepository.getEntityById(
                DeliveryTicket(), selectedId));

        selectedProductTicket = (await ProductTicket().select(
            model: ProductTicket(),
            sqlBuilder: SqlBuilder()
                .querySelect(fields: ["*"])
                .queryFrom(
                table: selectedProductTicket
                    .getTableName(selectedProductTicket))
                .queryWhere(conditions: [
              'idTicket',
              SqlBuilder.constOperators['equals']!,
              '$selectedId'
            ])))
            .first as ProductTicket;

        await productTicketModel
            .fromEntity(await selectedProductTicket.selectLast());

        emit(TicketSuccess(
          message: 'Tickets de productos obtenidos correctamente',
          data: [productTicketModel, deliveryTicketModel],
          event: "GetTicketInfo",
        ));
      } catch (e) {
        emit(TicketError(
            'Ha ocurrido un error a la hora de obtener los tickets'));
      }
    });

    on<PrintTicketEvent>((event, emit) async {
      emit(TicketLoading());
      PrintHelper printHelper = PrintHelper();
      var selectedProductTicket = ProductTicket();
      ProductTicketModel productTicketModel =
      ProductTicketModel();
      VehicleRegistrationModel vehicleRegistrationModel =
      VehicleRegistrationModel();
      DriverModel driverModel = DriverModel();
      SlaughterhouseModel slaughterhouseModel = SlaughterhouseModel();
      RancherModel rancherModel = RancherModel();
      ProductModel productModel = ProductModel();
      PerformanceModel performanceModel = PerformanceModel();

      Map<String, List<BluetoothInfo>> itemsMap =
      await printHelper.getBluetooth();

      //! ProductTicket
      selectedProductTicket = (await ProductTicket().select(
          model: ProductTicket(),
          sqlBuilder: SqlBuilder()
              .querySelect(fields: ["*"])
              .queryFrom(
              table: selectedProductTicket
                  .getTableName(selectedProductTicket))
              .queryWhere(conditions: [
            'idTicket',
            SqlBuilder.constOperators['equals']!,
            '${event.deliveryTicket.id}'
          ])))
          .first as ProductTicket;
      await productTicketModel
          .fromEntity(await selectedProductTicket.selectLast());

      //! VehicleRegistrationNum
      await vehicleRegistrationModel.fromEntity(
          await DatabaseRepository.getEntityById(VehicleRegistration(),
              event.deliveryTicket.idVehicleRegistration!));

      //! Driver (name)
      await driverModel.fromEntity(await DatabaseRepository.getEntityById(
          Driver(), event.deliveryTicket.idDriver!));

      //! Slaughterhouse (name)
      await rancherModel.fromEntity(await DatabaseRepository.getEntityById(
          Rancher(), event.deliveryTicket.idRancher!));

      //! Rancher (name)
      await slaughterhouseModel.fromEntity(
          await DatabaseRepository.getEntityById(
              Slaughterhouse(), event.deliveryTicket.idSlaughterhouse!));

      //! Product (name)
      await productModel.fromEntity(await DatabaseRepository.getEntityById(
          Product(), event.deliveryTicket.idProduct!));

      //! Performance (num)
      await performanceModel.fromEntity(
          await DatabaseRepository.getEntityById(Performance(),selectedProductTicket.idPerformance!));


      try {
        await printHelper.print(event.context, itemsMap.values
            .toList()
            .first,
            date: event.deliveryTicket.date.toString(),
            vehicleRegistrationNum:
            '${vehicleRegistrationModel.vehicleRegistrationNum}',
            driver: '${driverModel.name}',
            slaughterHouse: '${slaughterhouseModel.name}',
            rancher: '${rancherModel.name}',
            deliveryTicketNumber:
            '${event.deliveryTicket.deliveryTicket!} - ${event.deliveryTicket
                .number}',
            product: '${productModel.name}',
            number: '${selectedProductTicket.numAnimals}',
            classification: '${selectedProductTicket.nameClassification}',
            performance: '${performanceModel.performance}',
            kilograms: '${selectedProductTicket.weight}',
            color: '${selectedProductTicket.color}');

        emit(TicketSuccess(
            message: 'Impresión realizada con éxito',
            data: [200],
            event: 'PrintTicketEvent'));
      } catch (e) {
        LogHelper.logger.d(e);
        emit(TicketError(
            'Ha ocurrido un error a la hora de imprimir el ticket'));
      }
    });
  }
}
