import 'package:corderos_app/data/!data.dart';
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
  String? driverName;
  String? series;
  int? number;

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
    );
  }

  @override
  Future<void> fromEntity(ModelDao entity) async {
    ClientDeliveryNote clientDeliveryNote = entity as ClientDeliveryNote;
    idDeliveryNote = clientDeliveryNote.id;

    // Esperamos el resultado del Future antes de hacer el cast.
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
    driverName = await Preferences.getValue('name');

    series = clientDeliveryNote.series;
    number = clientDeliveryNote.number;
  }

  @override
  String toString() {
    return '$series\t$number\t$date\t${client!.nif}\t${slaughterhouse!.name}\t$vehicleRegistration\t$driverName';
  }
}
