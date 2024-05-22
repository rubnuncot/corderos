import 'package:corderos_app/data/!data.dart';
import 'package:corderos_app/repository/!repository.dart';
import 'package:meta/meta.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';

import '!models.dart';
import '!!model_base.dart';
import '../../data/database/entities/!!model_dao.dart';
import '../../data/preferences/preferences.dart';
import '../data_conversion/!data_conversion.dart';

@reflector
class ClientDeliveryNoteModel extends ModelBase {
  int? idDeliveryNote;
  ClientModel? client;
  DateTime? date;
  SlaughterhouseModel? slaughterhouse;
  ProductModel? product;
  String? vehicleRegistration;
  DriverModel? driver;
  String? series;
  int? number;
  bool? isSend;

  ClientDeliveryNoteModel();

  ClientDeliveryNoteModel.all(
      {@required required this.idDeliveryNote,
      @required required this.client,
      @required required this.series,
      @required required this.number,
      @required required this.date,
      @required required this.slaughterhouse,
      @required required this.product});

  ClientDeliveryNote toEntity() {
    return ClientDeliveryNote.all(
      series: series,
      number: number,
      clientId: client!.id,
      date: date,
      slaughterhouseId: slaughterhouse!.id,
      idProduct: product!.id,
      isSend: isSend ?? false,
    );
  }

  @override
  Future<void> fromEntity(ModelDao entity) async {
    ClientDeliveryNote clientDeliveryNote = entity as ClientDeliveryNote;
    idDeliveryNote = clientDeliveryNote.id;

    ClientModel clientModel = ClientModel();
    await clientModel.fromEntity(await DatabaseRepository.getEntityById(
        Client(), clientDeliveryNote.clientId!) as Client);
    client = clientModel;

    date = clientDeliveryNote.date;

    SlaughterhouseModel slaughterhouseModel = SlaughterhouseModel();
    await slaughterhouseModel.fromEntity(await DatabaseRepository.getEntityById(
            Slaughterhouse(), clientDeliveryNote.slaughterhouseId!)
        as Slaughterhouse);

    slaughterhouse = slaughterhouseModel;

    ProductModel productModel = ProductModel();
    await productModel.fromEntity(await DatabaseRepository.getEntityById(
        Product(), clientDeliveryNote.idProduct!) as Product);

    product = productModel;

    vehicleRegistration = await Preferences.getValue('vehicle_registration');
    String driverName = await Preferences.getValue('name');

    DriverModel driverModel = DriverModel();
    await driverModel.fromEntity(
        await DatabaseRepository.getEntityByName(Driver(), driverName));

    driver = driverModel;

    series = clientDeliveryNote.series;
    number = clientDeliveryNote.number;
    isSend = clientDeliveryNote.isSend;
  }

  @override
  String toString() {
    return '$idDeliveryNote\t$series\t$number\t$date\t${client!.nif}\t${slaughterhouse!.code}\t$vehicleRegistration\t${driver!.id}';
  }
}
