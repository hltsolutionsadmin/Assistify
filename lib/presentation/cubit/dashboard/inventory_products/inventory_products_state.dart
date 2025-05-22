import 'package:assistify/data/model/add_product/delete_product_model.dart';
import 'package:assistify/data/model/dash_board/inventory_products_model.dart';

abstract class InventoryProductsState {}

class InventoryProductsInitial extends InventoryProductsState {}
class DeleteProductInitial extends InventoryProductsState {}


class InventoryProductsLoading extends InventoryProductsState {}
class DeleteProductLoading extends InventoryProductsState {}


class InventoryProductsLoaded extends InventoryProductsState {
  final InventroryProductsModel invenoryModel;
  InventoryProductsLoaded(this.invenoryModel);
}

class DeleteProductLoaded extends InventoryProductsState {
  final DeleteProductModel invenoryModel;
  DeleteProductLoaded(this.invenoryModel);
}


class InventoryProductsError extends InventoryProductsState {
  final String message;
 InventoryProductsError(this.message);
}

class DeleteProductError extends InventoryProductsState {
  final String message;
 DeleteProductError(this.message);
}
