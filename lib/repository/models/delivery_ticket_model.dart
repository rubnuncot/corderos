import 'package:corderos_app/data/database/!database.dart';
import 'package:corderos_app/repository/data_conversion/!data_conversion.dart';
import 'package:meta/meta.dart';

import '!models.dart';
import '../../data/!data.dart';

class DeliveryTicketModel {
  String? numTicket;
  String? series;
  String? deliveryTicket;
  DateTime? date;
  DriverModel? driver;
  VehicleRegistrationModel? vehicleRegistration;
  SlaughterhouseModel? slaughterhouse;
  RancherModel? rancher;
  ProductModel? product;

  DeliveryTicketModel();

  DeliveryTicketModel.all({
    @required required this.numTicket,
    @required required this.series,
    @required required this.deliveryTicket,
    @required required this.date,
    @required required this.driver,
    @required required this.vehicleRegistration,
    @required required this.slaughterhouse,
    @required required this.rancher,
    @required required this.product,
  });

  DeliveryTicketModel.fromEntity(DeliveryTicket deliveryTicketEntity) {
    numTicket = deliveryTicketEntity.numTicket;
    series = deliveryTicketEntity.series;
    deliveryTicket = deliveryTicketEntity.deliveryTicket;
    date = deliveryTicketEntity.date;

    driver = DriverModel.fromEntity(DatabaseRepository.getEntityById(
        Driver(), deliveryTicketEntity.idDriver!) as Driver);

    vehicleRegistration = VehicleRegistrationModel.fromEntity(
        DatabaseRepository.getEntityById(VehicleRegistration(),
                deliveryTicketEntity.idVehicleRegistration!)
            as VehicleRegistration);

    slaughterhouse = SlaughterhouseModel.fromEntity(
        DatabaseRepository.getEntityById(
                Slaughterhouse(), deliveryTicketEntity.idSlaughterhouse!)
            as Slaughterhouse);

    rancher = RancherModel.fromEntity(DatabaseRepository.getEntityById(
        Rancher(), deliveryTicketEntity.idRancher!) as Rancher);

    product = ProductModel.fromEntity(DatabaseRepository.getEntityById(
        Product(), deliveryTicketEntity.idProduct!) as Product);
  }
}
