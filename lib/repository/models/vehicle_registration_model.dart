import 'package:corderos_app/data/!data.dart';
import 'package:meta/meta.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';
import '!!model_base.dart';
import '../../data/database/entities/!!model_dao.dart';

@reflector
class VehicleRegistrationModel extends ModelBase{
  int? id;
  String? vehicleRegistrationNum;
  String? clientDeliveryNote;

  VehicleRegistrationModel();

  VehicleRegistrationModel.all({
    @required required this.id,
    @required required this.vehicleRegistrationNum,
    @required required this.clientDeliveryNote,
  });

  @override
  Future<void> fromEntity(ModelDao entity) async {
    id = entity.id;
    final vehicleRegistrationEntity = entity as VehicleRegistration;
    vehicleRegistrationNum = vehicleRegistrationEntity.vehicleRegistrationNum;

    clientDeliveryNote = vehicleRegistrationEntity.deliveryTicket;
  }
}
