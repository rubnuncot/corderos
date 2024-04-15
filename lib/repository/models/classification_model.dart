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

class ClassificationModel {
  int? id;
  String? name;
  ProductModel? product;

  ClassificationModel();

  ClassificationModel.all({
    @required required this.id,
    @required required this.name,
    @required required this.product,
  });

  ClassificationModel.fromEntity(Classification classification) {
    id = classification.id;
    name = classification.name;
    product = ProductModel.fromEntity(
        DatabaseRepository.getEntityById(Product(), classification.productId!)
            as Product);
  }

  Classification toEntity() {
    return Classification.all(
      id: id,
      name: name,
      productId: product!.id,
    );
  }
}
