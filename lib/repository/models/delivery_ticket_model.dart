import 'package:corderos_app/data/database/!database.dart';
import 'package:corderos_app/repository/data_conversion/!data_conversion.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';

import '!models.dart';
import '!!model_base.dart';
import '../../data/!data.dart';
import '../../data/database/entities/!!model_dao.dart';

@reflector
class DeliveryTicketModel extends ModelBase{
  int? id;  // Agregado campo id
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
    required this.id,  // Agregado parámetro id en constructor
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
  Future<void> fromEntity(ModelDao entity) async {
    DeliveryTicket deliveryTicketEntity = entity as DeliveryTicket;
    id = deliveryTicketEntity.id;  // Asignación del id desde la entidad
    deliveryTicket = deliveryTicketEntity.deliveryTicket;
    date = deliveryTicketEntity.date;

    DriverModel driverModel = DriverModel();
    await driverModel.fromEntity(await DatabaseRepository.getEntityById(
        Driver(), deliveryTicketEntity.idDriver!) as Driver);

    driver = driverModel;

    VehicleRegistrationModel vehicleRegistrationModel = VehicleRegistrationModel();
    await vehicleRegistrationModel.fromEntity(await DatabaseRepository.getEntityById(
        VehicleRegistration(), deliveryTicketEntity.idVehicleRegistration!) as VehicleRegistration);

    vehicleRegistration = vehicleRegistrationModel;

    SlaughterhouseModel slaughterhouseModel = SlaughterhouseModel();
    await slaughterhouseModel.fromEntity(await DatabaseRepository.getEntityById(
        Slaughterhouse(), deliveryTicketEntity.idSlaughterhouse!) as Slaughterhouse);

    slaughterhouse = slaughterhouseModel;

    RancherModel rancherModel = RancherModel();
    await rancherModel.fromEntity(await DatabaseRepository.getEntityById(
        Rancher(), deliveryTicketEntity.idRancher!) as Rancher);

    rancher = rancherModel;

    ProductModel productModel = ProductModel();
    await productModel.fromEntity(await DatabaseRepository.getEntityById(
        Product(), deliveryTicketEntity.idProduct!) as Product);

    product = productModel;

    number = deliveryTicketEntity.number;

    isSend = deliveryTicketEntity.isSend!;
  }

  @override
  String toString() {
    return '$id\t${vehicleRegistration!.clientDeliveryNote}\t$number\t$date\t ${driver?.nif} \t ${vehicleRegistration?.vehicleRegistrationNum} \t ${slaughterhouse?.code} \t ${rancher?.code} \t ${rancher?.code}'.replaceAll('\r', '');
  }
}
