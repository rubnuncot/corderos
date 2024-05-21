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
  int? _id;
  ClientDeliveryNoteModel? _clientDeliveryNote;
  ProductModel? _product;
  ClassificationModel? _classification;
  String? _nameClassification;
  int? _units;
  double? _kilograms;
  String? _color;

  ProductDeliveryNoteModel();

  ProductDeliveryNoteModel.all({
    required int? id,
    required ClientDeliveryNoteModel? clientDeliveryNote,
    required ProductModel? product,
    required ClassificationModel? classification,
    required String? nameClassification,
    required int? units,
    required double? kilograms,
    required String? color,
  })  : _id = id,
        _clientDeliveryNote = clientDeliveryNote,
        _product = product,
        _classification = classification,
        _nameClassification = nameClassification,
        _units = units,
        _kilograms = kilograms,
        _color = color;

  int? get id => _id;
  ClientDeliveryNoteModel? get clientDeliveryNote => _clientDeliveryNote;
  ProductModel? get product => _product;
  ClassificationModel? get classification => _classification;
  String? get nameClassification => _nameClassification;
  int? get units => _units;
  double? get kilograms => _kilograms;
  String? get color => _color;

  ProductDeliveryNote toEntity() {
    return ProductDeliveryNote.all(
      idDeliveryNote: clientDeliveryNote!.idDeliveryNote,
      idProduct: product!.id,
      idClassification: classification!.id,
      nameClassification: nameClassification,
      units: units,
      kilograms: kilograms,
      color: color,
    );
  }

  // Setters
  set id(int? id) => _id = id;
  set clientDeliveryNote(ClientDeliveryNoteModel? clientDeliveryNote) => _clientDeliveryNote = clientDeliveryNote;
  set product(ProductModel? product) => _product = product;
  set classification(ClassificationModel? classification) => _classification = classification;
  set nameClassification(String? nameClassification) => _nameClassification = nameClassification;
  set units(int? units) => _units = units;
  set kilograms(double? kilograms) => _kilograms = kilograms;
  set color(String? color) => _color = color;

  @override
  Future<void> fromEntity(ModelDao entity) async {
    ProductDeliveryNote productDeliveryNote = entity as ProductDeliveryNote;
    id = productDeliveryNote.id;

    ClientDeliveryNoteModel clientDeliveryNoteModel = ClientDeliveryNoteModel();
    await clientDeliveryNoteModel.fromEntity(
        await DatabaseRepository.getEntityById(ClientDeliveryNoteModel(), productDeliveryNote.idDeliveryNote!) as ClientDeliveryNote
    );
    clientDeliveryNote = clientDeliveryNoteModel;

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
    return '$id\t${clientDeliveryNote!.idDeliveryNote}\t${product!.code}\t${classification!.code}\t$nameClassification\t$units\t$kilograms\t$color'.replaceAll('\r', '');
  }
}
