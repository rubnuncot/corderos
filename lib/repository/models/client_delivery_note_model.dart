import 'package:corderos_app/data/!data.dart';
import 'package:meta/meta.dart';

import '!models.dart';
import '../data_conversion/!data_conversion.dart';

class ClientDeliveryNoteModel {
  int? idDeliveryNote;
  int? idClient;
  DateTime? date;
  SlaughterhouseModel? slaughterhouse;
  ProductModel? product;

  ClientDeliveryNoteModel();

  ClientDeliveryNoteModel.all({
    @required required this.idDeliveryNote,
    @required required this.idClient,
    @required required this.date,
    @required required this.slaughterhouse,
    @required required this.product
  });

  ClientDeliveryNoteModel.fromEntity(ClientDeliveryNote clientDeliveryNote) {
    idDeliveryNote = clientDeliveryNote.id;
    idClient = clientDeliveryNote.clientId;
    date = clientDeliveryNote.date;
    slaughterhouse = SlaughterhouseModel.fromEntity(DatabaseRepository.getEntityById(Slaughterhouse(), clientDeliveryNote.slaughterhouseId!) as Slaughterhouse);
    product = ProductModel.fromEntity(DatabaseRepository.getEntityById(Product(), clientDeliveryNote.idProduct!) as Product);
  }

  ClientDeliveryNote toEntity() {
    return ClientDeliveryNote.all(
      id: idDeliveryNote,
      clientId: idClient,
      date: date,
      slaughterhouseId: slaughterhouse!.id,
      idProduct: product!.id,
    );
  }
}