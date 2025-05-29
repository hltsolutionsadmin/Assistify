import 'package:assistify/data/model/add_product/add_product_model.dart';
import 'package:assistify/data/model/add_product/edit_product_model.dart';
import 'package:assistify/data/model/add_product/get_products_list_model.dart';
import 'package:assistify/domain/repo/add_products/add_products_repository.dart';

class AddProductsUsecase {
  final AddProductsRepository repository;
  AddProductsUsecase({required this.repository});

  Future<AddProductsModel> call(dynamic body) async {
    return await repository.add_Products(body);
  }

  Future<EditProductModel> edit_products(dynamic body) async {
    return await repository.edit_Products(body);
  }

  Future<GetProductsListModel> get_products(String companyId) async {
    return await repository.get_Products(companyId);
  }
}
