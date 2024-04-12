import 'package:corderos_app/repository/data_conversion/!data_conversion.dart';
import 'package:meta/meta.dart';

import '!models.dart';
import '../../data/!data.dart';

class PerformanceModel {
  int? id;
  ProductModel? product;
  ClassificationModel? classification;
  int? performance;

  PerformanceModel();

  PerformanceModel.all(
      {@required required this.id,
      @required required this.product,
      @required required this.classification,
      @required required this.performance});

  PerformanceModel.fromEntity(Performance performanceEntity) {
    id = performanceEntity.id;

    product = ProductModel.fromEntity(DatabaseRepository.getEntityById(
        Product(), performanceEntity.idProduct!) as Product);

    classification = ClassificationModel.fromEntity(
        DatabaseRepository.getEntityById(
                Classification(), performanceEntity.idClassification!)
            as Classification);

    performance = performanceEntity.performance;
  }
}
