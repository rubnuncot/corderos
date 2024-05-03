/*
* Estos son los modelos que vamos a usar en las pantallas, es decir,
* los datos que sacamos de la base de datos los tenemos que convertir a
* estos para poder usarlos.
*/

//! Tienes que crear las propiedades que vamos a neceistar en las pantallas

//? Por ejemplo: Si tenemos una relación con otra tabla. No guardamos el id,
//? uardamos el objeto completo

import 'package:corderos_app/data/!data.dart';
import 'package:corderos_app/repository/data_conversion/!data_conversion.dart';
import 'package:corderos_app/repository/models/!models.dart';
import 'package:meta/meta.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';

import '!!model_base.dart';
import '../../data/database/entities/!!model_dao.dart';

@reflector
class ClassificationModel extends ModelBase{
  int? id;
  String? code;
  String? name;
  ProductModel? product;

  ClassificationModel();

  ClassificationModel.all({
    @required required this.id,
    @required required this.code,
    @required required this.name,
    @required required this.product,
  });


  @override
  Future<void> fromEntity(ModelDao entity) async {
    Classification classification = entity as Classification;
    id = classification.id;
    name = classification.name;
    code = classification.code;
    ProductModel productModel = ProductModel();
    await productModel.fromEntity(
        await DatabaseRepository.getEntityById(Product(), classification.productId!)
            as Product);
    product = productModel;
  }

  Classification toEntity() {
    return Classification.all(
      code: code,
      name: name,
      productId: product!.id,
    );
  }
}
