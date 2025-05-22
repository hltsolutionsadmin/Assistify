import 'package:assistify/core/constants/custome_snack_bar.dart';
import 'package:assistify/domain/usecase/add_products/add_products_useCase.dart';
import 'package:assistify/presentation/cubit/add_products/add_products_state.dart';
import 'package:assistify/presentation/cubit/dashboard/inventory_products/inventory_produts_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_service.dart';

class AddProductsCubit extends Cubit<AddProductsState> {
  final AddProductsUsecase useCase;
  final NetworkService networkService;

  AddProductsCubit({required this.useCase, required this.networkService})
    : super(AddProductsInitial());

  Future<void> add_products(
    BuildContext context,
  dynamic body,
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
      emit(AddProductsLoading());
      final addProductsEntity = await useCase.call(body);
      print(addProductsEntity);
      emit(AddProductsLoaded(addProductsEntity));
      if (addProductsEntity.status == 'SUCCESS') {
        Navigator.pop(context);
       context.read<InventoryProdutsCubit>().inventory_products(
      context,
      companyId,
    );
        emit(AddProductsLoaded(addProductsEntity));
      }
    } catch (e) {
      print('error in allbills: $e');
      emit(AddProductsError('Failed to load add_products data: ${e.toString()}'));
    }
  }
  
  Future<void> edit_product(
    BuildContext context,
  dynamic body,
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
      emit(EditProductsLoading());
      final editProductsEntity = await useCase.edit_products(body);
      print(editProductsEntity);
      emit(EditProductsLoaded(editProductsEntity));
      if (editProductsEntity.status == 'SUCCESS') {
        Navigator.pop(context);
       context.read<InventoryProdutsCubit>().inventory_products(
      context,
      companyId,
    );
        emit(EditProductsLoaded(editProductsEntity));
      }
    } catch (e) {
      print('error in allbills: $e');
      emit(EditProductsError('Failed to load editProductsEntity data: ${e.toString()}'));
    }
  }
}
