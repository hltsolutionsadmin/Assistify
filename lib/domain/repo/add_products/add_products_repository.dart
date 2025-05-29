import 'package:assistify/data/model/add_product/add_product_model.dart';
import 'package:assistify/data/model/add_product/edit_product_model.dart';
import 'package:assistify/data/model/add_product/get_products_list_model.dart';

abstract class AddProductsRepository {
  Future<AddProductsModel> add_Products(dynamic body);
  Future<EditProductModel> edit_Products(dynamic body);
  Future<GetProductsListModel> get_Products(String companyId);
}
