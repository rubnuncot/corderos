import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';

import '!!model_base.dart';
import '!models.dart';
import '../../data/!data.dart';
import '../../data/database/entities/!!model_dao.dart';
import '../data_conversion/!data_conversion.dart';

@reflector
class DeliveryTicketModel extends ModelBase {
  int? id;
  String? deliveryTicket;
  DateTime? date;
  DriverModel? driver;
  VehicleRegistrationModel? vehicleRegistration;
  SlaughterhouseModel? slaughterhouse;
  RancherModel? rancher;
  ProductModel? product;
  int? number;
  bool? isSend;

  DeliveryTicketModel();

  DeliveryTicketModel.all({
    required this.id,
    required this.number,
    required this.deliveryTicket,
    required this.date,
    required this.driver,
    required this.vehicleRegistration,
    required this.slaughterhouse,
    required this.rancher,
    required this.product,
    required this.isSend,
  });

  @override
  Future<DeliveryTicketModel> fromEntity(ModelDao entity) async {
    DeliveryTicket deliveryTicketEntity = entity as DeliveryTicket;
    id = deliveryTicketEntity.id;
    deliveryTicket = deliveryTicketEntity.deliveryTicket;
    date = deliveryTicketEntity.date;

    driver = await _loadModel<Driver, DriverModel>(
      deliveryTicketEntity.idDriver!,
          () => DriverModel(),
      Driver(),
    );

    vehicleRegistration = await _loadModel<VehicleRegistration, VehicleRegistrationModel>(
      deliveryTicketEntity.idVehicleRegistration!,
          () => VehicleRegistrationModel(),
      VehicleRegistration(),
    );

    slaughterhouse = await _loadModel<Slaughterhouse, SlaughterhouseModel>(
      deliveryTicketEntity.idSlaughterhouse!,
          () => SlaughterhouseModel(),
      Slaughterhouse(),
    );

    rancher = await _loadModel<Rancher, RancherModel>(
      deliveryTicketEntity.idRancher!,
          () => RancherModel(),
      Rancher(),
    );

    product = await _loadModel<Product, ProductModel>(
      deliveryTicketEntity.idProduct!,
          () => ProductModel(),
      Product(),
    );

    number = deliveryTicketEntity.number;
    isSend = deliveryTicketEntity.isSend!;

    return this;
  }

  Future<TModel?> _loadModel<TEntity extends ModelDao, TModel extends ModelBase>(
      int id, TModel Function() modelConstructor, TEntity entity) async {
    final model = modelConstructor();
    final dbEntity = await DatabaseRepository.getEntityById(entity, id) as TEntity;
    await model.fromEntity(dbEntity);
    return model;
  }

  @override
  String toString() {
    return '$id\t${vehicleRegistration?.clientDeliveryNote}\t$number\t$date\t'
        '${driver?.nif}\t${driver?.name}\t${vehicleRegistration?.vehicleRegistrationNum}\t'
        '${slaughterhouse?.code}\t${rancher?.code}\t${rancher?.name}'.replaceAll('\r', '');
  }
}
