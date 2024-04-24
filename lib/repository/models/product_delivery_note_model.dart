import 'package:corderos_app/data/!data.dart';
import 'package:corderos_app/data/database/entities/product_delivery_note.dart';
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
  String? nameClassification;
  int? units;
  double? kilograms;

  ProductDeliveryNoteModel();

  ProductDeliveryNoteModel.all({
    @required required this.id,
    @required required this.deliveryTicket,
    @required required this.product,
    @required required this.nameClassification,
    @required required this.units,
    @required required this.kilograms,
  });

  ProductDeliveryNote toEntity() {
    return ProductDeliveryNote.all(
      idDeliveryNote: deliveryTicket!.id,
      idProduct: product!.id,
      nameClassification: nameClassification,
      units: units,
      kilograms: kilograms,
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

    nameClassification = productDeliveryNote.nameClassification;
    units = productDeliveryNote.units;
    kilograms = productDeliveryNote.kilograms;
  }

  @override
  String toString() {
    return '${product!.name}\t$nameClassification\t$units\t$kilograms';
  }
}
