import 'package:assistify/data/model/add_product/add_product_model.dart';
import 'package:assistify/data/model/add_product/edit_product_model.dart';
import 'package:assistify/data/model/add_product/get_products_list_model.dart';

abstract class AddProductsState {}

class AddProductsInitial extends AddProductsState {}
class EditProductsInitial extends AddProductsState {}
class GetProductsInitial extends AddProductsState {}


class AddProductsLoading extends AddProductsState {}
class EditProductsLoading extends AddProductsState {}
class GetProductsLoading extends AddProductsState {}



class AddProductsLoaded extends AddProductsState {
  final AddProductsModel addProductsModel;
  AddProductsLoaded(this.addProductsModel);
}

class EditProductsLoaded extends AddProductsState {
  final EditProductModel editProductModel;
  EditProductsLoaded(this.editProductModel);
}

class GetProductsLoaded extends AddProductsState {
  final GetProductsListModel getProductsListModel;
  GetProductsLoaded(this.getProductsListModel);
}

class AddProductsError extends AddProductsState {
  final String message;
 AddProductsError(this.message);
}

class EditProductsError extends AddProductsState {
  final String message;
 EditProductsError(this.message);
}

class GetProductsError extends AddProductsState {
  final String message;
 GetProductsError(this.message);
}
