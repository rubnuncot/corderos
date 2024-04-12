
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../data/!data.dart';

class ProductModel {
  int? id;
  String? name;

  ProductModel();

  ProductModel.all({
      @required required this.id,
    @required required this.name,
  });

  ProductModel.fromEntity(Product product) {
    id = product.id;
    name = product.name;
  }

  Product toEntity() {
    return Product.all(
      id: id,
      name: name,
    );
  }
}