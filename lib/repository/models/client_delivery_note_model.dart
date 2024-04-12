import 'package:corderos_app/data/!data.dart';
import 'package:meta/meta.dart';

import '!models.dart';
import '../data_conversion/!data_conversion.dart';

class ClientDeliveryNoteModel {
  int? idDeliveryNote;
  DateTime? date;
  SlaughterhouseModel? slaughterhouse;
  ProductModel? product;

  ClientDeliveryNoteModel();

  ClientDeliveryNoteModel.all({
    @required required this.idDeliveryNote,
    @required required this.date,
    @required required this.slaughterhouse,
    @required required this.product
  });

  ClientDeliveryNoteModel.fromEntity(ClientDeliveryNote clientDeliveryNote) {
    idDeliveryNote = clientDeliveryNote.idDeliveryNote;
    date = clientDeliveryNote.date;
    slaughterhouse = SlaughterhouseModel.fromEntity(DatabaseRepository.getEntityById(Slaughterhouse(), clientDeliveryNote.slaughterhouseId!) as Slaughterhouse);
    product = ProductModel.fromEntity(DatabaseRepository.getEntityById(Product(), clientDeliveryNote.productId!) as Product);
  }

  ClientDeliveryNote toEntity() {
    return ClientDeliveryNote.all(
      idDeliveryNote: idDeliveryNote,
      date: date,
      slaughterhouseId: slaughterhouse!.id,
      productId: product!.id,
    );
  }
}