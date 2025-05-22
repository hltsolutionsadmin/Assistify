import 'package:assistify/core/constants/custome_snack_bar.dart';
import 'package:assistify/domain/usecase/dashboard/all_expences_usecase.dart';
import 'package:assistify/presentation/cubit/dashboard/all_expences/all_expences_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../core/network/network_service.dart';

class AllExpencesCubit extends Cubit<AllExpencesState> {
  final AllExpencesUsecase useCase;
  final NetworkService networkService;

  AllExpencesCubit({required this.useCase, required this.networkService})
    : super(AllExpencesInitial());

  Future<void> all_expences(
    BuildContext context,
  dynamic id,
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
      emit(AllExpencesLoading());
      final allExpencesEntity = await useCase.call(id);
      print(allExpencesEntity);
      emit(AllExpencesLoaded(allExpencesEntity));
      if (allExpencesEntity.status == 'SUCCESS') {
        emit(AllExpencesLoaded(allExpencesEntity));
      }
    } catch (e) {
      print('error in allExpencesEntity: $e');
      emit(AllExpencesError('Failed to load allExpencesEntity data: ${e.toString()}'));
    }
  }

}
