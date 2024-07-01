import 'package:corderos_app/data/!data.dart';
import 'package:corderos_app/data/database/!database.dart';
import 'package:corderos_app/data/database/entities/!entities.dart';
import 'package:corderos_app/repository/!repository.dart';
import 'package:corderos_app/repository/data_conversion/!data_conversion.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';
import 'package:sqflite_simple_dao_backend/database/database/sql_builder.dart';

import '!models.dart';
import '!!model_base.dart';
import '../../data/database/entities/!!model_dao.dart';

@reflector
class ProductTicketModel extends ModelBase {
  int? id;
  DeliveryTicketModel? deliveryTicket;
  ProductModel? product;
  ClassificationModel? classification;
  int? numAnimals;
  double? weight;
  PerformanceModel? performance;
  String? color;
  int? losses;
  ClientDeliveryNoteModel? outDelivery;
  double? weightLosses;

  ProductTicketModel();

  ProductTicketModel.all({
    required this.id,
    required this.deliveryTicket,
    required this.product,
    required this.classification,
    required this.numAnimals,
    required this.weight,
    required this.performance,
    required this.color,
    required this.losses,
    required this.weightLosses,
    required this.outDelivery,
  });

  // Getters
  int? get getId => id;

  DeliveryTicketModel? get getDeliveryTicket => deliveryTicket;

  ProductModel? get getProduct => product;

  ClassificationModel? get getClassification => classification;

  int? get getNumAnimals => numAnimals;

  double? get getWeight => weight;

  PerformanceModel? get getPerformance => performance;

  String? get getColor => color;

  int? get getLosses => losses;

  double? get getWeightLosses => weightLosses;

  ClientDeliveryNoteModel? get getOutDelivery => outDelivery;

  // Setters
  set setId(int? id) => this.id = id;

  set setDeliveryTicket(DeliveryTicketModel? deliveryTicket) =>
      this.deliveryTicket = deliveryTicket;

  set setProduct(ProductModel? product) => this.product = product;

  set setClassification(ClassificationModel? classification) =>
      this.classification = classification;

  set setNumAnimals(int? numAnimals) => this.numAnimals = numAnimals;

  set setWeight(double? weight) => this.weight = weight;

  set setPerformance(PerformanceModel? performance) =>
      this.performance = performance;

  set setColor(String? color) => this.color = color;

  set setLosses(int? losses) => this.losses = losses;

  set setWeightLosses(double? weihtLosses) => this.weightLosses = weihtLosses;

  set setOutDelivery(ClientDeliveryNoteModel? outDelivery) => this.outDelivery = outDelivery;

  @override
  Future<ProductTicketModel> fromEntity(ModelDao entity) async {
    ProductTicket productTicket = entity as ProductTicket;
    Classification classificationEntity = Classification();
    id = productTicket.id;
    DeliveryTicketModel deliveryTicketModel = DeliveryTicketModel();
    await deliveryTicketModel.fromEntity(await DatabaseRepository.getEntityById(
        DeliveryTicket(), productTicket.idTicket!) as DeliveryTicket);

    deliveryTicket = deliveryTicketModel;

    ProductModel productModel = ProductModel();
    await productModel.fromEntity(await DatabaseRepository.getEntityById(
        Product(), productTicket.idProduct!) as Product);
    product = productModel;

    final classifications = await classificationEntity.getData<Classification>(
      where: [
        'name',
        SqlBuilder.constOperators['like']!,
        "'%${productTicket.nameClassification!.replaceAll('\r', '')}%'",
        SqlBuilder.constOperators['and']!,
        'productId',
        SqlBuilder.constOperators['equals']!,
        '${productTicket.idProduct}'
      ],
    );

    ClassificationModel classificationModel = ClassificationModel();
    await classificationModel.fromEntity(
        classifications[0]);

    classification = classificationModel;

    numAnimals = productTicket.numAnimals;
    weight = productTicket.weight;

    PerformanceModel performanceModel = PerformanceModel();
    await performanceModel.fromEntity(await DatabaseRepository.getEntityById(
        Performance(), productTicket.idPerformance!) as Performance);

    performance = performanceModel;

    color = productTicket.color;

    losses = productTicket.losses;

    weightLosses = productTicket.weightLosses;

    if(productTicket.idOutDelivery == null) return this;

    ClientDeliveryNoteModel clientDeliveryNoteModel = ClientDeliveryNoteModel();
    await clientDeliveryNoteModel.fromEntity(await DatabaseRepository.getEntityById(
        ClientDeliveryNote(), productTicket.idOutDelivery!) as ClientDeliveryNote);
    outDelivery = clientDeliveryNoteModel;
    return this;
  }

  @override
  String toString() {
    return '$id\t${product!.id}\t${product!.name}\t${classification!.id}\t${classification!.name}\t$numAnimals\t$weight\t${performance?.performance}\t$color\t${losses ?? 0}'
        .replaceAll('\r', '');
  }
}
