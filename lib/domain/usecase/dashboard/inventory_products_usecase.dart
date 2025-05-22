
import 'package:assistify/data/model/add_product/delete_product_model.dart';
import 'package:assistify/data/model/dash_board/inventory_products_model.dart';
import 'package:assistify/domain/repo/dashboard/inventory_products_repository.dart';

class InventoryProductsUsecase {
  final InventoryProductsRepository repository;
  InventoryProductsUsecase({required this.repository});

  Future<InventroryProductsModel> call(String companyId) async {
    return await repository.InventoryProducts(companyId);
  }

    Future<DeleteProductModel> delete_Product(dynamic id) async {
    return await repository.delete_Product(id);
  }
}
