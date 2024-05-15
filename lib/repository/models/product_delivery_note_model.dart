import 'package:corderos_app/data/!data.dart';
import 'package:corderos_app/data/database/!database.dart';
import 'package:corderos_app/repository/!repository.dart';
import 'package:corderos_app/repository/data_conversion/!data_conversion.dart';
import 'package:meta/meta.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';

import '!models.dart';
import '!!model_base.dart';
import '../../data/database/entities/!!model_dao.dart';

@reflector
class ProductDeliveryNoteModel extends ModelBase{
  int? id;
  DeliveryTicketModel? deliveryTicket;
  ProductModel? product;
  ClassificationModel? classification;
  String? nameClassification;
  int? units;
  double? kilograms;
  String? color;

  ProductDeliveryNoteModel();

  ProductDeliveryNoteModel.all({
    @required required this.id,
    @required required this.deliveryTicket,
    @required required this.product,
    @required required this.classification,
    @required required this.nameClassification,
    @required required this.units,
    @required required this.kilograms,
    @required required this.color,
  });

  ProductDeliveryNote toEntity() {
    return ProductDeliveryNote.all(
      idDeliveryNote: deliveryTicket!.id,
      idProduct: product!.id,
      idClassification: classification!.id,
      nameClassification: nameClassification,
      units: units,
      kilograms: kilograms,
      color: color,
    );
  }

  @override
  Future<void> fromEntity(ModelDao entity) async {
    ProductDeliveryNote productDeliveryNote = entity as ProductDeliveryNote;
    id = productDeliveryNote.id;

    DeliveryTicketModel deliveryTicketModel = DeliveryTicketModel();
    await deliveryTicketModel.fromEntity(
        await DatabaseRepository.getEntityById(DeliveryTicket(), productDeliveryNote.idDeliveryNote!) as DeliveryTicket
    );
    deliveryTicket = deliveryTicketModel;

    ProductModel productModel = ProductModel();
    await productModel.fromEntity(
        await DatabaseRepository.getEntityById(Product(), productDeliveryNote.idProduct!) as Product
    );
    product = productModel;

    ClassificationModel classificationModel = ClassificationModel();
    await classificationModel.fromEntity(
      await DatabaseRepository.getEntityById(Classification(), productDeliveryNote.idClassification!) as Classification
    );
    classification = classificationModel;

    nameClassification = productDeliveryNote.nameClassification;
    units = productDeliveryNote.units;
    kilograms = productDeliveryNote.kilograms;
    color = productDeliveryNote.color;
  }

  @override
  String toString() {
    return '${product!.code}\t${product!.name}\t${classification!.code}\t$nameClassification\t$units\t$kilograms\t$color'.replaceAll('\r', '');
  }
}
