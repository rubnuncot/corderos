import 'package:corderos_app/data/!data.dart';
import 'package:corderos_app/repository/!repository.dart';
import 'package:corderos_app/repository/data_conversion/!data_conversion.dart';
import 'package:corderos_app/repository/models/!models.dart';
import 'package:meta/meta.dart';

class VehicleRegistrationModel {
  String? vehicleRegistrationNum;
  DeliveryTicketModel? clientDeliveryNote;

  VehicleRegistrationModel();

  VehicleRegistrationModel.all({
    @required required this.vehicleRegistrationNum,
    @required required this.clientDeliveryNote,
  });

  VehicleRegistrationModel.fromEntity(VehicleRegistration vehicleRegistrationEntity) {
    vehicleRegistrationNum = vehicleRegistrationEntity.vehicleRegistrationNum;
    clientDeliveryNote = DeliveryTicketModel.fromEntity(
        DatabaseRepository.getEntityById(
                DeliveryTicket(), vehicleRegistrationEntity.id!)
            as DeliveryTicket);
  }
}
