import 'package:corderos_app/data/!data.dart';
import 'package:corderos_app/repository/data_conversion/!data_conversion.dart';
import 'package:meta/meta.dart';

import '!models.dart';

class ProductTicketModel {
  int? id;
  DeliveryTicketModel? deliveryTicket;
  ProductModel? product;
  String? nameClassification;
  int? numAnimals;
  double? weight;
  int? idPerformance;
  int? losses;

  ProductTicketModel();

  ProductTicketModel.all({
    @required required this.id,
    @required required this.deliveryTicket,
    @required required this.product,
    @required required this.nameClassification,
    @required required this.numAnimals,
    @required required this.weight,
    @required required this.idPerformance,
    @required required this.losses,
  });

  ProductTicketModel.fromEntity(ProductTicket productTicket) {
    id = productTicket.id;

    deliveryTicket = DeliveryTicketModel.fromEntity(
        DatabaseRepository.getEntityById(
            DeliveryTicket(), productTicket.idTicket!) as DeliveryTicket);

    product = ProductModel.fromEntity(
        DatabaseRepository.getEntityById(Product(), productTicket.idProduct!)
            as Product);

    nameClassification = productTicket.nameClassification;
    numAnimals = productTicket.numAnimals;
    weight = productTicket.weight;
    idPerformance = productTicket.idPerformance;
    losses = productTicket.losses;
  }
}
