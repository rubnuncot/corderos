import 'package:corderos_app/repository/data_conversion/!data_conversion.dart';
import 'package:meta/meta.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';

import '!models.dart';
import '!!model_base.dart';
import '../../data/!data.dart';
import '../../data/database/entities/!!model_dao.dart';

@reflector
class PerformanceModel extends ModelBase{
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

  @override
  Future<void> fromEntity(ModelDao entity) async{
    final performanceEntity = entity as Performance;
    id = performanceEntity.id;
    ProductModel productModel = ProductModel();
    await productModel.fromEntity(await DatabaseRepository.getEntityById(
        Product(), performanceEntity.idProduct!) as Product);

    product = productModel;

    ClassificationModel classificationModel = ClassificationModel();
    await classificationModel.fromEntity(await DatabaseRepository.getEntityById(
        Classification(), performanceEntity.idClassification!) as Classification);

    classification = classificationModel;

    performance = performanceEntity.performance;
  }
}
