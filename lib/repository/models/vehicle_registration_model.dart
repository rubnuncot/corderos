import 'package:corderos_app/data/!data.dart';
import 'package:corderos_app/repository/!repository.dart';
import 'package:corderos_app/repository/data_conversion/!data_conversion.dart';
import 'package:corderos_app/repository/models/!models.dart';
import 'package:meta/meta.dart';

class VehicleRegistrationModel {
  String? id;
  DeliveryTicketModel? clientDeliveryNote;

  VehicleRegistrationModel();

  VehicleRegistrationModel.all({
    @required required this.id,
    @required required this.clientDeliveryNote,
  });

  VehicleRegistrationModel.fromEntity(VehicleRegistration vehicleRegistration) {
    id = vehicleRegistration.id;
    clientDeliveryNote = DeliveryTicketModel.fromEntity(
        DatabaseRepository.getEntityById(
                DeliveryTicket(), vehicleRegistration.deliveryTicket!)
            as DeliveryTicket);
  }
}
