import 'package:assistify/core/constants/custome_snack_bar.dart';
import 'package:assistify/domain/usecase/dashboard/inventory_products_usecase.dart';
import 'package:assistify/presentation/cubit/dashboard/inventory_products/inventory_products_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../core/network/network_service.dart';

class InventoryProdutsCubit extends Cubit<InventoryProductsState> {
  final InventoryProductsUsecase useCase;
  final NetworkService networkService;

  InventoryProdutsCubit({required this.useCase, required this.networkService})
    : super(InventoryProductsInitial());

  Future<void> inventory_products(
    BuildContext context,
    String companyId,
  ) async {
    bool isConnected = await networkService.hasInternetConnection();
    print(isConnected);

    if (!isConnected) {
      print("No Internet Connection");
      CustomSnackbars.showErrorSnack(
        context: context,
        title: 'Alert',
        message: 'Please check Internet Connection',
      );
      return;
    }
    try {
      emit(InventoryProductsLoading());
      final products = await useCase.call(companyId);
      print(products);
      emit(InventoryProductsLoaded(products));
      if (products.status == 'SUCCESS') {
        emit(InventoryProductsLoaded(products));
      }
    } catch (e) {
      print('error in inventory_products: $e');
      emit(InventoryProductsError('Failed to load inventory_products data: ${e.toString()}'));
    }
  }
  
  Future<void> delete_product(
    BuildContext context,
    dynamic id,
    String companyId,
  ) async {
    print(id.runtimeType);
    bool isConnected = await networkService.hasInternetConnection();
    print(isConnected);

    if (!isConnected) {
      print("No Internet Connection");
      CustomSnackbars.showErrorSnack(
        context: context,
        title: 'Alert',
        message: 'Please check Internet Connection',
      );
      return;
    }
    try {
      emit(DeleteProductLoading());
      final delProduct = await useCase.delete_Product(id);
      print(delProduct);
      if (delProduct.status == 'SUCCESS') {
        emit(DeleteProductLoaded(delProduct));
        await inventory_products(context, companyId);
      } else{
        CustomSnackbars.showErrorSnack(
        context: context,
        title: 'Alert',
        message: 'Unable to delete product',
      );
      }
    } catch (e) {
      print('error in delete product: $e');
      emit(DeleteProductError('Failed to load delete product data: ${e.toString()}'));
    }
  }
}
