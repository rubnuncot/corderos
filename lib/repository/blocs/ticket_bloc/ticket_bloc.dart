import 'package:bloc/bloc.dart';
import 'package:corderos_app/!helpers/!helpers.dart';
import 'package:corderos_app/!helpers/print_helper.dart';
import 'package:corderos_app/data/!data.dart';
import 'package:corderos_app/data/database/entities/!!model_dao.dart';
import 'package:corderos_app/repository/!repository.dart';
import 'package:corderos_app/repository/data_conversion/!data_conversion.dart';
import 'package:flutter/cupertino.dart';
import 'package:reflectable/reflectable.dart';
import 'package:sqflite_simple_dao_backend/database/database/sql_builder.dart';
import 'package:sqflite_simple_dao_backend/sqflite_simple_dao_backend.dart';

part 'ticket_event.dart';

part 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  TicketBloc() : super(TicketLoading()) {
    on<FetchTicketsScreen>(_onFetchTicketsScreen);
    on<SelectTicket>(_onSelectTicket);
    on<DeleteTicket>(_onDeleteTicket);
    on<GetTicketInfo>(_onGetTicketInfo);
    on<PrintTicketEvent>(_onPrintTicketEvent);
    on<AddLosses>(_addLosses);
    on<OpenProductTicketList>(_openPanel);
    on<DeleteAllTickets>(_onDeleteAllTickets);
    on<SetIconTicketState>(_onSetIconTicketState);
  }

  Future<void> _onFetchTicketsScreen(
      FetchTicketsScreen event, Emitter<TicketState> emit) async {
    emit(TicketLoading());
    try {
      final tickets = await DeliveryTicket().selectAll<DeliveryTicket>();

      if (tickets.isNotEmpty) {
        final List<Rancher> ranchers = [];
        final List<Product> products = [];

        for (var ticket in tickets) {
          final rancher = await DatabaseRepository.getEntityById(
            Rancher(),
            ticket.idRancher!,
          );
          final product = await DatabaseRepository.getEntityById(
            Product(),
            ticket.idProduct!,
          );
          ranchers.add(rancher);
          products.add(product);
        }

        emit(TicketSuccess(
          message: 'Tickets, rancher y product recibidos con éxito',
          data: [tickets, ranchers, products],
          event: 'FetchTicketsScreen',
        ));
      }
    } catch (e) {
      emit(TicketError(
        'Ha ocurrido un error a la hora de cargar los tickets: $e',
      ));
    }
  }

  Future<void> _onSelectTicket(
      SelectTicket event, Emitter<TicketState> emit) async {
    try {
      final selectedDeliveryTicket =
          await _fetchDeliveryTicketById(event.ticketId);
      if (selectedDeliveryTicket != null) {
        selectedDeliveryTicket.isSend = !selectedDeliveryTicket.isSend!;
        await selectedDeliveryTicket.update();
        emit(TicketSuccess(
          message: 'Ticket seleccionado correctamente',
          data: [selectedDeliveryTicket],
          event: 'SelectTicket',
        ));
      } else {
        throw Exception('No ticket found with id ${event.ticketId}');
      }
    } catch (e) {
      emit(TicketError(
          'Ha habido un error al seleccionar el ticket: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteTicket(
      DeleteTicket event, Emitter<TicketState> emit) async {
    try {
      final selectedDeliveryTicket =
          await _fetchDeliveryTicketById(event.ticketId);
      final selectedProductTicket =
          await _fetchProductTicketByTicketId(event.ticketId);
      await selectedDeliveryTicket?.delete();
      for (var productTicket in selectedProductTicket!) {
        await productTicket.delete();
      }
      emit(TicketSuccess(
        message: 'Ticket borrado correctamente',
        data: [selectedDeliveryTicket],
        event: 'DeleteTicket',
      ));
    } catch (e) {
      emit(TicketError('Ha habido un error al borrar el ticket'));
    }
  }

  Future<void> _onGetTicketInfo(
      GetTicketInfo event, Emitter<TicketState> emit) async {
    emit(TicketLoading());
    try {
      final deliveryTicketModel =
          await _getDeliveryTicketModelById(event.ticketId);
      final productTicketModel =
          await _getProductTicketModelByTicketId(event.ticketId);
      emit(TicketSuccess(
        message: 'Tickets de productos obtenidos correctamente',
        data: [productTicketModel, deliveryTicketModel],
        event: "GetTicketInfo",
      ));
    } catch (e) {
      emit(
          TicketError('Ha ocurrido un error a la hora de obtener los tickets'));
    }
  }

  Future<void> _onPrintTicketEvent(
      PrintTicketEvent event, Emitter<TicketState> emit) async {
    emit(TicketLoading());
    try {
      final printData = await _gatherPrintData(event.deliveryTicket);
      await _printTicket(event.context, printData);
      emit(TicketSuccess(
        message: 'Impresión realizada con éxito',
        data: [200],
        event: 'PrintTicketEvent',
      ));
    } catch (e) {
      LogHelper.logger.d(e);
      emit(TicketError('Ha ocurrido un error a la hora de imprimir el ticket'));
    }
  }

  Future<DeliveryTicket?> _fetchDeliveryTicketById(int ticketId) async {
    final results = await DeliveryTicket().select(
      model: DeliveryTicket(),
      sqlBuilder: SqlBuilder()
          .querySelect(fields: ["*"])
          .queryFrom(table: DeliveryTicket().getTableName(DeliveryTicket()))
          .queryWhere(conditions: [
            'id',
            SqlBuilder.constOperators['equals']!,
            '$ticketId'
          ]),
    );
    return results.isNotEmpty ? results.first as DeliveryTicket : null;
  }

  Future<List<ProductTicket>?> _fetchProductTicketByTicketId(
      int ticketId) async {
    final results = await ProductTicket().getData<ProductTicket>(
        where: ['idTicket', SqlBuilder.constOperators['equals']!, '$ticketId']);
    return results.isNotEmpty ? results : null;
  }

  Future<DeliveryTicketModel> _getDeliveryTicketModelById(int ticketId) async {
    final model = DeliveryTicketModel();
    final entity =
        await DatabaseRepository.getEntityById(DeliveryTicket(), ticketId);
    await model.fromEntity(entity);
    return model;
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
        ticket['classification'].add(productTicket.classification!.name);
        ticket['performance'].add(productTicket.performance!.performance);
        ticket['kilograms'].add(productTicket.weight);
        ticket['color'].add(productTicket.color);
      }
    }

    return ticket;
  }

  Future<void> _printTicket(
      BuildContext context, Map<String, dynamic> printData) async {
    final printHelper = PrintHelper();
    final itemsMap = await printHelper.getBluetooth();
    await printHelper.print(
      context,
      itemsMap.values.toList().first,
      tickets: printData,
    );
  }

  Future<T> _getModelById<T>(ModelDao entity, int id) async {
    final classMirror = reflector.reflectType(T) as ClassMirror;
    final model = classMirror.newInstance('', []) as T;
    final entityData = await DatabaseRepository.getEntityById(entity, id);
    await (model as dynamic).fromEntity(entityData);
    return model;
  }

  Future<void> _openPanel(
      OpenProductTicketList event, Emitter<TicketState> emit) async {
    final productTicketModel =
        await _getProductTicketModelByTicketId(event.ticketId);
    emit(TicketSuccess(
      message: 'Tickets de productos obtenidos correctamente',
      data: [productTicketModel],
      event: "OpenProductTicketList",
    ));
  }

  Future<void> _addLosses(AddLosses event, Emitter<TicketState> emit) async {
    final productTicket = await DatabaseRepository.getEntityById(
        ProductTicket(), event.productTicketId);
    productTicket.losses = event.losses;
    await productTicket.update();
    emit(TicketSuccess(
      message: 'Pérdidas añadidas correctamente',
      data: [productTicket],
      event: 'AddLosses',
    ));
  }

  Future<void> _onDeleteAllTickets(
      DeleteAllTickets event, Emitter<TicketState> emit) async {
    try {
      final allTickets = await DeliveryTicket().selectAll<DeliveryTicket>();

      for (var ticket in allTickets) {
        final allProductTickets = await ProductTicket().getData<ProductTicket>(
            where: [
              'idTicket',
              SqlBuilder.constOperators['equals']!,
              '${ticket.id}'
            ]);

        DeliveryTicket().batchDelete(objectsToDelete: allTickets);
        ProductTicket().batchDelete(objectsToDelete: allProductTickets);
      }

      emit(TicketSuccess(
        message: 'Todos los tickets borrados correctamente',
        data: [],
        event: 'DeleteAllTickets',
      ));
    } catch (e) {
      emit(TicketError('Ha habido un error al borrar todos los tickets'));
    }
  }

  Future<void> _onSetIconTicketState(
      SetIconTicketState event, Emitter<TicketState> emit) async {

    try {
      int deliveryTicketNumber = event.number;
      bool isTicketSend;

      final selectedTicket =  await ClientDeliveryNote().getData<ClientDeliveryNote>(
        where: ['number', SqlBuilder.constOperators['equals']!, '$deliveryTicketNumber']
      );

      if (selectedTicket.isEmpty) {
        isTicketSend = false;
      } else {
        isTicketSend = true;
      }

      emit(TicketSuccess(
          message: 'Icono de ticket establecido correctamente',
          data: [isTicketSend],
          event: 'SetIconTicketState')
      );
    } catch(e) {
      emit(TicketError('Ha habido un error al establecer el estado del icono'));
    }
  }
}
