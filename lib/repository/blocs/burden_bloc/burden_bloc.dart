import 'package:bloc/bloc.dart';
import 'package:corderos_app/!helpers/!helpers.dart';
import 'package:corderos_app/!helpers/print_helper.dart';
import 'package:corderos_app/data/!data.dart';
import 'package:corderos_app/data/database/!database.dart';
import 'package:corderos_app/data/preferences/preferences.dart';
import 'package:corderos_app/repository/data_conversion/!data_conversion.dart';
import 'package:flutter/cupertino.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:sqflite_simple_dao_backend/database/database/sql_builder.dart';

import '../../../data/database/entities/changes.dart';
import '../../models/!models.dart';

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
        LogHelper.logger.d(e);
        emit(BurdenError(
            'Ha ocurrido un error a la hora de obtener los cambios de tabla.'));
      }
    });

    on<GetProductTicketsBurden>((event, emit) async {
      emit(BurdenLoading());

      try {
        ProductDeliveryNote productTicket = ProductDeliveryNote();
        List<String> whereClause = [];
        List<ProductDeliveryNote> productTickets = [];

        Map<String, Iterable<String>> eventData = {};

        getConditions(eventData);

        productTickets = whereClause.isEmpty
            ? await productTicket.selectAll() as List<ProductDeliveryNote>
            : await productTicket.select(
            sqlBuilder: SqlBuilder()
                .querySelect(fields: ["*"])
                .queryFrom(table: productTicket.getTableName(productTicket))
                .queryWhere(
                conditions: whereClause)) as List<ProductDeliveryNote>;

        emit(BurdenSuccess('Albarán de productos obtenidos correctamente.',
            [productTickets], "GetProductTickets"));
      } catch (e) {
        LogHelper.logger.d(e);
        emit(BurdenError(
            'Ha ocurrido un error a la hora de obtener los albaranes de productos.'));
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
        LogHelper.logger.d(e);
        emit(BurdenError(
            'Ha ocurrido un error a la hora de obtener la última carga.'));
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
        LogHelper.logger.d(e);
        emit(BurdenError(
            'Ha ocurrido un error a la hora de crear una nueva carga.'));
      }
    });

    on<UploadData>((event, emit) async {
      emit(BurdenLoading());
      PrintHelper printHelper = PrintHelper();

      Map<String, List<BluetoothInfo>> itemsMap =
      await printHelper.getBluetooth();

      try {
        DeliveryTicket lastDeliveryTicket = DeliveryTicket();
        ProductTicket lastProductTicket = ProductTicket();
        lastDeliveryTicket =
        await lastDeliveryTicket.isTableEmpty() ? DeliveryTicket() : await event
            .deliveryTicket!.selectLast();
        lastProductTicket =
        await lastProductTicket.isTableEmpty() ? ProductTicket() : await event
            .productTicket!.selectLast();
        VehicleRegistrationModel vehicleRegistrationModel =
        VehicleRegistrationModel();
        DriverModel driverModel = DriverModel();
        SlaughterhouseModel slaughterhouseModel = SlaughterhouseModel();
        RancherModel rancherModel = RancherModel();
        ProductModel productModel = ProductModel();
        PerformanceModel performanceModel = PerformanceModel();

        if (event.deliveryTicket != lastDeliveryTicket &&
            event.productTicket != lastProductTicket) {
          await event.deliveryTicket!.insert();
          event.productTicket!.idTicket = event.deliveryTicket!.id;
          await event.productTicket!.insert();
        }

        //! VehicleRegistrationNum
        await vehicleRegistrationModel.fromEntity(
            await DatabaseRepository.getEntityById(VehicleRegistration(),
                event.deliveryTicket!.idVehicleRegistration!));

        //! Driver (name)
        await driverModel.fromEntity(await DatabaseRepository.getEntityById(
            Driver(), event.deliveryTicket!.idDriver!));

        //! Slaughterhouse (name)
        await rancherModel.fromEntity(await DatabaseRepository.getEntityById(
            Rancher(), event.deliveryTicket!.idRancher!));

        //! Rancher (name)
        await slaughterhouseModel.fromEntity(
            await DatabaseRepository.getEntityById(
                Slaughterhouse(), event.deliveryTicket!.idSlaughterhouse!));

        //! Product (name)
        await productModel.fromEntity(await DatabaseRepository.getEntityById(
            Product(), event.deliveryTicket!.idProduct!));

        //! Performance (num)
        await performanceModel.fromEntity(
            await DatabaseRepository.getEntityById(Performance(),lastProductTicket.idPerformance!));


        await printHelper.print(event.context!, itemsMap.values
            .toList()
            .first,
            date: event.deliveryTicket!.date.toString(),
            vehicleRegistrationNum:
            '${vehicleRegistrationModel.vehicleRegistrationNum}',
            driver: '${driverModel.name}',
            slaughterHouse: '${slaughterhouseModel.name}',
            rancher: '${rancherModel.name}',
            deliveryTicketNumber:
            '${event.deliveryTicket!.deliveryTicket!} - ${event.deliveryTicket!
                .number}',
            product: '${productModel.name}',
            number: '${event.productTicket!.numAnimals}',
            classification: '${event.productTicket!.nameClassification}',
            performance: '${performanceModel.performance}',
            kilograms: '${event.productTicket!.weight}',
            color: '${event.productTicket!.color}');

        emit(BurdenSuccess(
            'Carga guardada correctamente.',
            [
              [200]
            ],
            "UploadData"));
      } catch (e) {
        LogHelper.logger.d(e);
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
