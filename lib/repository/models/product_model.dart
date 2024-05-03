import 'package:corderos_app/data/database/entities/!!model_dao.dart';
import 'package:sqflite_simple_dao_backend/database/database/reflectable.dart';

import '!!model_base.dart';
import 'package:meta/meta.dart';

import '../../data/!data.dart';

@reflector
class ProductModel extends ModelBase{
  int? id;
  String? code;
  String? name;

  ProductModel();

  ProductModel.all({
    @required required this.id,
    @required required this.code,
    @required required this.name,
  });

  @override
  Future<void> fromEntity(ModelDao entity) async {
    final product = entity as Product;
    id = product.id;
    code = product.code;
    name = product.name;
  }

  Product toEntity() {
    return Product.all(
      code: code,
      name: name,
    );
  }
}