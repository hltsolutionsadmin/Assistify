import 'package:assistify/data/model/add_product/delete_product_model.dart';
import 'package:assistify/data/model/dash_board/inventory_products_model.dart';

abstract class InventoryProductsRepository {
  Future<InventroryProductsModel> InventoryProducts(String companyId);
    Future<DeleteProductModel> delete_Product(dynamic id);

}
