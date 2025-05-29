import 'package:assistify/core/constants/custome_snack_bar.dart';
import 'package:assistify/domain/usecase/search_phone_number/search_phone_number_usecase.dart';
import 'package:assistify/presentation/cubit/search_phone_number/search_phone_number_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../core/network/network_service.dart';

class SearchPhoneNumberCubit extends Cubit<SearchPhoneNumberState> {
  final SearchPhoneNumberUsecase useCase;
  final NetworkService networkService;

  SearchPhoneNumberCubit({required this.useCase, required this.networkService})
    : super(SearchPhoneNumberInitial());

  Future<void> searchPhoneNumber({
    required BuildContext context,
    required String mobileNumber,
  }) async {
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
      emit(SearchPhoneNumberLoading());
      final searchBillsEntity = await useCase.call(mobileNumber);
      print(searchBillsEntity);
      if (searchBillsEntity.status == 'SUCCESS') {
        emit(SearchPhoneNumberLoaded(searchBillsEntity));
      } else {
        emit(SearchPhoneNumberError('Failed to load search mobile number data'));
      }
    } catch (e) {
      print('error in allbills: $e');
      emit(SearchPhoneNumberError('Failed to load search mobile number data: ${e.toString()}'));
    }
  }

}
