import 'package:assistify/core/constants/api_constatnts.dart';
import 'package:assistify/data/model/add_product/delete_product_model.dart';
import 'package:assistify/data/model/dash_board/inventory_products_model.dart';
import 'package:dio/dio.dart';


abstract class InventoryProductsDatasource {
  Future<InventroryProductsModel> InventoryProducts(String companyId);
    Future<DeleteProductModel> delete_Product(dynamic id);

}

class InventoryProductsDataSourceImpl implements InventoryProductsDatasource {
  final Dio client;

  InventoryProductsDataSourceImpl({required this.client});

  @override
  Future<InventroryProductsModel> InventoryProducts(dynamic companyId) async {
    print(companyId);
    try {
      final response = await client.get(
        '$inventoryProducts/$companyId',
      );
      print('Response status code of InventoryProducts: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Response data InventoryProducts: ${response.data}');
        return InventroryProductsModel.fromJson(response.data);
      } else if(response.statusCode == 401) {
        print(response);
        throw Exception('Failed to load InventoryProducts: ${response.statusCode}');
      } else  {
        throw Exception('Failed to load InventoryProducts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load InventoryProducts: ${e.toString()}');
    }
  }


   @override
  Future<DeleteProductModel> delete_Product(dynamic id) async {
    print(id.runtimeType);
    try {
      final response = await client.get(
        '$deleteProduct/$id',
      );
      print('Response status code of delete_Product: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Response data delete_Product: ${response.data}');
        return DeleteProductModel.fromJson(response.data);
      } else if(response.statusCode == 401) {
        print(response);
        throw Exception('Failed to load delete_Product: ${response.statusCode}');
      } else  {
        throw Exception('Failed to load delete_Product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load delete_Product: ${e.toString()}');
    }
  }
}
