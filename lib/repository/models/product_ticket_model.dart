import 'package:corderos_app/data/!data.dart';
import 'package:corderos_app/repository/!repository.dart';
import 'package:corderos_app/repository/data_conversion/!data_conversion.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';

import '!models.dart';
import '!!model_base.dart';
import '../../data/database/entities/!!model_dao.dart';

@reflector
class ProductTicketModel extends ModelBase{
  int? id;
  DeliveryTicketModel? deliveryTicket;
  ProductModel? product;
  String? nameClassification;
  int? numAnimals;
  double? weight;
  PerformanceModel? performance;
  String? color;
  int? losses;

  ProductTicketModel();

  ProductTicketModel.all({
    required this.id,
    required this.deliveryTicket,
    required this.product,
    required this.nameClassification,
    required this.numAnimals,
    required this.weight,
    required this.performance,
    required this.color,
    required this.losses,
  });

  // Getters
  int? get getId => id;
  DeliveryTicketModel? get getDeliveryTicket => deliveryTicket;
  ProductModel? get getProduct => product;
  String? get getNameClassification => nameClassification;
  int? get getNumAnimals => numAnimals;
  double? get getWeight => weight;
  PerformanceModel? get getPerformance => performance;
  String? get getColor => color;
  int? get getLosses => losses;

  // Setters
  set setId(int? id) => this.id = id;
  set setDeliveryTicket(DeliveryTicketModel? deliveryTicket) => this.deliveryTicket = deliveryTicket;
  set setProduct(ProductModel? product) => this.product = product;
  set setNameClassification(String? nameClassification) => this.nameClassification = nameClassification;
  set setNumAnimals(int? numAnimals) => this.numAnimals = numAnimals;
  set setWeight(double? weight) => this.weight = weight;
  set setPerformance(PerformanceModel? performance) => this.performance = performance;
  set setColor(String? color) => this.color = color;
  set setLosses(int? losses) => this.losses = losses;

  @override
  Future<void> fromEntity(ModelDao entity) async {
    ProductTicket productTicket = entity as ProductTicket;
    id = productTicket.id;
    DeliveryTicketModel deliveryTicketModel = DeliveryTicketModel();
    await deliveryTicketModel.fromEntity(
        await DatabaseRepository.getEntityById(
            DeliveryTicket(), productTicket.idTicket!) as DeliveryTicket);

    deliveryTicket = deliveryTicketModel;

    ProductModel productModel = ProductModel();
    await productModel.fromEntity(
        await DatabaseRepository.getEntityById(
            Product(), productTicket.idProduct!) as Product);
    product = productModel;

    nameClassification = productTicket.nameClassification;
    numAnimals = productTicket.numAnimals;
    weight = productTicket.weight;

    PerformanceModel performanceModel = PerformanceModel();
    await performanceModel.fromEntity(
        await DatabaseRepository.getEntityById(
            Performance(), productTicket.idPerformance!) as Performance);

    performance = performanceModel;

    color = productTicket.color;

    losses = productTicket.losses;
  }

  @override
  String toString() {
    return '$id\t${deliveryTicket!.id}\t${product!.code}\t$nameClassification\t$numAnimals\t$weight\t${performance?.performance}\t$color\t$losses'.replaceAll('\r', '');
  }
}
