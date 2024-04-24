import 'package:corderos_app/data/!data.dart';
import 'package:meta/meta.dart';
import '!!model_base.dart';
import '../../data/database/entities/!!model_dao.dart';

class VehicleRegistrationModel extends ModelBase{
  String? vehicleRegistrationNum;
  String? clientDeliveryNote;

  VehicleRegistrationModel();

  VehicleRegistrationModel.all({
    @required required this.vehicleRegistrationNum,
    @required required this.clientDeliveryNote,
  });

  @override
  Future<void> fromEntity(ModelDao entity) async {
    final vehicleRegistrationEntity = entity as VehicleRegistration;
    vehicleRegistrationNum = vehicleRegistrationEntity.vehicleRegistrationNum;

    clientDeliveryNote = vehicleRegistrationEntity.deliveryTicket;
  }
}
