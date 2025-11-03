import 'package:assistify/core/constants/custome_snack_bar.dart';
import 'package:assistify/domain/usecase/add_expences/add_expences_useCase.dart';
import 'package:assistify/presentation/cubit/add_expences/add_expences_state.dart';
import 'package:assistify/presentation/cubit/dashboard/all_expences/all_expences_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_service.dart';

class AddExpencesCubit extends Cubit<AddExpencesState> {
  final AddExpencesUsecase useCase;
  final NetworkService networkService;

  AddExpencesCubit({required this.useCase, required this.networkService})
    : super(AddExpencesInitial());

  Future<void> add_Expences(
    BuildContext context,
  dynamic body,
  String companyId,
  ) async {
    print(body);
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
      emit(AddExpencesLoading());
      final addExpencesEntity = await useCase.call(body);
      print(addExpencesEntity);
      emit(AddExpencesLoaded(addExpencesEntity));
      if (addExpencesEntity.status == 'SUCCESS') {
        Navigator.pop(context);
       context.read<AllExpencesCubit>().all_expences(
      context,
      companyId,
    );
        emit(AddExpencesLoaded(addExpencesEntity));
      }
    } catch (e) {
      print('error in add expences: $e');
      emit(AddExpencesError('Failed to load add expences data: ${e.toString()}'));
    }
  }
  
  Future<void> edit_expences(
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
      emit(EditExpencesLoading());
      final editExpencesEntity = await useCase.edit_Expences(body);
      print(editExpencesEntity);
      emit(EditExpencesLoaded(editExpencesEntity));
      if (editExpencesEntity.status == 'SUCCESS') {
        Navigator.pop(context);
       context.read<AllExpencesCubit>().all_expences(
      context,
      companyId,
    );
        emit(EditExpencesLoaded(editExpencesEntity));
      }
    } catch (e) {
      print('error in edit expences: $e');
      emit(EditExpencesError('Failed to load edit expences data: ${e.toString()}'));
    }
  }
  
Future<void> delete_Expence(
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
      emit(DeleteExpencesLoading());
      final delExpence = await useCase.delete_Expences(id);
      print(delExpence);
      if (delExpence.status == 'SUCCESS') {
        emit(DeleteExpencesLoaded(delExpence));
        await context.read<AllExpencesCubit>().all_expences(context, companyId);
      } else{
        CustomSnackbars.showErrorSnack(
        context: context,
        title: 'Alert',
        message: 'Unable to delete item',
      );
      }
    } catch (e) {
      print('error in delete expence: $e');
      emit(DeleteExpencesError('Failed to load delete expence data: ${e.toString()}'));
    }
  }
}
