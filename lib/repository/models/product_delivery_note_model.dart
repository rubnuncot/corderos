import 'package:corderos_app/data/!data.dart';
import 'package:corderos_app/data/database/entities/product_delivery_note.dart';
import 'package:corderos_app/repository/data_conversion/!data_conversion.dart';
import 'package:meta/meta.dart';

import '!models.dart';

class ProductDeliveryNoteModel {
  int? id;
  DeliveryTicketModel? deliveryTicket;
  ProductModel? product;
  String? nameClassification;
  int? units;
  double? kilograms;

  ProductDeliveryNoteModel();

  ProductDeliveryNoteModel.all({
    @required required this.deliveryTicket,
    @required required this.product,
    @required required this.nameClassification,
    @required required this.units,
    @required required this.kilograms,
  });

  ProductDeliveryNoteModel.fromEntity(ProductDeliveryNote productDeliveryNote) {
    id = productDeliveryNote.id;
    deliveryTicket = DeliveryTicketModel.fromEntity(
      DatabaseRepository.getEntityById(DeliveryTicket(), productDeliveryNote.idDeliveryNote!) as DeliveryTicket
    );
    product = ProductModel.fromEntity(
      DatabaseRepository.getEntityById(Product(), productDeliveryNote.idProduct!) as Product
    );
    nameClassification = productDeliveryNote.nameClassification;
    units = productDeliveryNote.units;
    kilograms = productDeliveryNote.kilograms;
  }
}