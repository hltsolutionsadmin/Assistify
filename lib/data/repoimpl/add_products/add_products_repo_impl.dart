import 'package:assistify/data/datasource/add_products/add_products_datasource.dart';
import 'package:assistify/data/model/add_product/add_product_model.dart';
import 'package:assistify/data/model/add_product/edit_product_model.dart';
import 'package:assistify/data/model/add_product/get_products_list_model.dart';
import 'package:assistify/domain/repo/add_products/add_products_repository.dart';

class AddProductsRepoImpl implements AddProductsRepository {
  final AddProductsDatasource remoteDataSource;

  AddProductsRepoImpl({required this.remoteDataSource});

  @override
  Future<AddProductsModel> add_Products(dynamic body) async {
    final model = await remoteDataSource.add_Products( body);
    return AddProductsModel(
      message: model.message,
      status: model.status,  
      data: model.data,        
    );
  }

   @override
  Future<EditProductModel> edit_Products(dynamic body) async {
    final model = await remoteDataSource.edit_Products( body);
    return EditProductModel(
      message: model.message,
      status: model.status,  
      data: model.data,        
    );
  }

   @override
  Future<GetProductsListModel> get_Products(String companyId) async {
    final model = await remoteDataSource.get_Products( companyId);
    return GetProductsListModel(
      message: model.message,
      status: model.status,  
      data: model.data,        
    );
  }
}
