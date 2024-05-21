import 'package:bloc/bloc.dart';
import 'package:corderos_app/!helpers/!helpers.dart';
import 'package:corderos_app/!helpers/print_helper.dart';
import 'package:corderos_app/data/!data.dart';
import 'package:corderos_app/data/database/!database.dart';
import 'package:corderos_app/data/database/entities/!!model_dao.dart';
import 'package:corderos_app/data/preferences/preferences.dart';
import 'package:corderos_app/repository/data_conversion/!data_conversion.dart';
import 'package:flutter/cupertino.dart';
import 'package:reflectable/mirrors.dart';
import 'package:sqflite_simple_dao_backend/database/database/sql_builder.dart';
import 'package:sqflite_simple_dao_backend/sqflite_simple_dao_backend.dart';

import '../../../data/database/entities/changes.dart';
import '../../models/!models.dart';

part 'burden_state.dart';

part 'burden_event.dart';

class BurdenBloc extends Bloc<BurdenEvent, BurdenState> {
  BurdenBloc() : super(BurdenLoading()) {
    on<GetChanges>(_onGetChanges);
    on<GetProductTicketsBurden>(_onGetProductTicketsBurden);
    on<GetTableIndex>(_onGetTableIndex);
    on<IncrementTableIndex>(_onIncrementTableIndex);
    on<UploadData>(_onUploadData);
  }

  Future<void> _onGetChanges(
      GetChanges event, Emitter<BurdenState> emit) async {
    emit(BurdenLoading());
    try {
      final changes = await _fetchChanges(event);
      emit(BurdenSuccess('Cambios de tabla obtenidos correctamente.', [changes],
          "GetChanges"));
    } catch (e) {
      LogHelper.logger.d(e);
      emit(BurdenError(
          'Ha ocurrido un error a la hora de obtener los cambios de tabla.'));
    }
  }

  Future<List<Change>> _fetchChanges(GetChanges event) async {
    Changes change = Changes();
    Map<String, Iterable<String>> eventData = {
      "date_${event.date}": [
        "date LIKE '%${event.date}%'",
        SqlBuilder.constOperators['and']!
      ],
      "tableChanged_${event.tableChanged}": [
        "tableChanged LIKE '%${event.tableChanged}%'",
        SqlBuilder.constOperators['and']!
      ],
      "isRead${event.isRead}": [
        "isRead LIKE '%${event.isRead}%'",
        SqlBuilder.constOperators['and']!
      ],
    };

    final whereClause = _buildConditions(eventData);
    return whereClause.isEmpty
        ? await change.selectAll() as List<Change>
        : await change.select(
            sqlBuilder: SqlBuilder()
                .querySelect(fields: ["*"])
                .queryFrom(table: change.getTableName(change))
                .queryWhere(conditions: whereClause)) as List<Change>;
  }

  Future<void> _onGetProductTicketsBurden(
      GetProductTicketsBurden event, Emitter<BurdenState> emit) async {
    emit(BurdenLoading());
    try {
      final productTickets = await _fetchProductTickets(event);
      emit(BurdenSuccess('Albarán de productos obtenidos correctamente.',
          [productTickets], "GetProductTickets"));
    } catch (e) {
      LogHelper.logger.d(e);
      emit(BurdenError(
          'Ha ocurrido un error a la hora de obtener los albaranes de productos.'));
    }
  }

  Future<List<ProductTicket>> _fetchProductTickets(
      GetProductTicketsBurden event) async {
    List<ProductTicket> productTicket = [];
    final whereClause = _buildConditions({});

    productTicket =
        (await ProductTicket().getData<ProductTicket>(where: whereClause));

    return productTicket;
  }

  Future<void> _onGetTableIndex(
      GetTableIndex event, Emitter<BurdenState> emit) async {
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
  }

  Future<void> _onIncrementTableIndex(
      IncrementTableIndex event, Emitter<BurdenState> emit) async {
    emit(BurdenLoading());
    const key = 'last_saved_tablet_id';
    try {
      var currentTableIndex = await Preferences.getValue(key);
      currentTableIndex += 1;
      await Preferences.setValue(key, currentTableIndex);
      emit(BurdenSuccess(
          'Índice de tabla actualizado correctamente',
          [
            [currentTableIndex]
          ],
          "IncrementTableIndex"));
    } catch (e) {
      LogHelper.logger.d(e);
      emit(BurdenError(
          'Ha ocurrido un error a la hora de crear una nueva carga.'));
    }
  }

  Future<void> _onUploadData(
      UploadData event, Emitter<BurdenState> emit) async {
    emit(BurdenLoading());
    try {
      await _handleUploadData(event);
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
  }

  Future<void> _handleUploadData(UploadData event) async {
    try {
      PrintHelper printHelper = PrintHelper();
      var itemsMap = await printHelper.getBluetooth();

      DeliveryTicket lastDeliveryTicket =
          await _getLastOrNewDeliveryTicket(event.deliveryTicket);
      if (event.deliveryTicket != null &&
          event.deliveryTicket != lastDeliveryTicket) {
        await event.deliveryTicket!.insert();
      }

      List<ProductTicket> productTicket = [];
      for (var product in event.productTicket) {
        productTicket.add(ProductTicket()
          ..idTicket = event.deliveryTicket?.id ?? lastDeliveryTicket.id
          ..idProduct = product.product!.id
          ..nameClassification = product.nameClassification
          ..numAnimals = product.numAnimals
          ..weight = product.weight
          ..idPerformance = product.performance!.id
          ..color = product.color
          ..losses = product.losses);
      }

      for (var x in productTicket) {
        if (x.numAnimals! > 0) {
          x.idTicket = event.deliveryTicket?.id ?? lastDeliveryTicket.id;
          await x.insert();
        }
      }

      final data =
          await _gatherPrintData(event.deliveryTicket ?? lastDeliveryTicket);
      await printHelper.print(event.context!, itemsMap.values.toList().first,
          tickets: data);
    } catch (e) {
      LogHelper.logger.d(e);
    }
  }

  Future<DeliveryTicket> _getLastOrNewDeliveryTicket(
      DeliveryTicket? deliveryTicket) async {
    DeliveryTicket lastDeliveryTicket = DeliveryTicket();
    return await lastDeliveryTicket.isTableEmpty()
        ? DeliveryTicket()
        : await deliveryTicket?.selectLast() ?? DeliveryTicket();
  }

  Future<List<ProductTicket>?> _fetchProductTicketByTicketId(
      int ticketId) async {
    final results = await ProductTicket().getData<ProductTicket>(
        where: ['idTicket', SqlBuilder.constOperators['equals']!, '$ticketId']);
    return results.isNotEmpty ? results : null;
  }

  Future<List<ProductTicketModel>> _getProductTicketModelByTicketId(
      int ticketId) async {
    final selectedProductTicket = await _fetchProductTicketByTicketId(ticketId);
    List<ProductTicketModel> model = [];
    if (selectedProductTicket != null) {
      for (var productTicket in selectedProductTicket) {
        ProductTicketModel product = ProductTicketModel();
        await product.fromEntity(productTicket);
        model.add(product);
      }
    }
    return model;
  }

  Future<Map<String, dynamic>> _gatherPrintData(
      DeliveryTicket deliveryTicket) async {
    final productTicketModel =
        await _getProductTicketModelByTicketId(deliveryTicket.id!);
    final vehicleRegistrationModel =
        await _getModelById<VehicleRegistrationModel>(
            VehicleRegistration(), deliveryTicket.idVehicleRegistration!);
    final driverModel =
        await _getModelById<DriverModel>(Driver(), deliveryTicket.idDriver!);
    final rancherModel =
        await _getModelById<RancherModel>(Rancher(), deliveryTicket.idRancher!);
    final slaughterhouseModel = await _getModelById<SlaughterhouseModel>(
        Slaughterhouse(), deliveryTicket.idSlaughterhouse!);

    Map<String, dynamic> ticket = {
      'date': deliveryTicket.date.toString(),
      'deliveryTicketNumber': deliveryTicket.deliveryTicket,
      'vehicleRegistrationNum': vehicleRegistrationModel.vehicleRegistrationNum,
      'driver': driverModel.name,
      'slaughterHouse': slaughterhouseModel.name,
      'rancher': rancherModel.name,
      'product': productTicketModel.first.product!.name,
      'number': [],
      'classification': [],
      'performance': [],
      'kilograms': [],
      'color': [],
    };

    for (final productTicket in productTicketModel) {
      if (productTicket.losses != 0) {
        ticket['number'].add(productTicket.numAnimals);
        ticket['classification'].add(productTicket.nameClassification);
        ticket['performance'].add(productTicket.performance!.performance);
        ticket['kilograms'].add(productTicket.weight);
        ticket['color'].add(productTicket.color);
      }
    }

    return ticket;
  }

  Future<T> _getModelById<T>(ModelDao entity, int id) async {
    var classMirror = reflector.reflectType(T) as ClassMirror;
    final model = classMirror.newInstance('', []) as T;
    final entityData = await DatabaseRepository.getEntityById(entity, id);
    await (model as dynamic).fromEntity(entityData);
    return model;
  }

  List<String> _buildConditions(Map<String, Iterable<String>> eventData) {
    List<String> conditions = [];
    for (var entry in eventData.entries) {
      if (entry.key.contains("none")) {
        conditions.addAll(entry.value);
      }
    }
    if (conditions.isNotEmpty) conditions.removeLast();
    return conditions;
  }
}
