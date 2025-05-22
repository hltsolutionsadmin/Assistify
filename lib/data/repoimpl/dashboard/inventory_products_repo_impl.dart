import 'package:assistify/data/datasource/dashboard/inventory_products_datasource.dart';
import 'package:assistify/data/model/add_product/delete_product_model.dart';
import 'package:assistify/data/model/dash_board/inventory_products_model.dart';
import 'package:assistify/domain/repo/dashboard/inventory_products_repository.dart';

class InventoryProductsRepoImpl implements InventoryProductsRepository {
  final InventoryProductsDatasource remoteDataSource;

  InventoryProductsRepoImpl({required this.remoteDataSource});

  @override
  Future<InventroryProductsModel> InventoryProducts(String companyId) async {
    final model = await remoteDataSource.InventoryProducts( companyId);
    return InventroryProductsModel(
      message: model.message,
      status: model.status,  
      data: model.data,
    );
  }

  @override
  Future<DeleteProductModel> delete_Product(dynamic id) async {
    final model = await remoteDataSource.delete_Product( id);
    return DeleteProductModel(
      message: model.message,
      status: model.status, 
      data: model.data, 
    );
  }
}
