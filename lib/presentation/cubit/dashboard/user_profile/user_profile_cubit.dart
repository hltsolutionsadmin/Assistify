import 'package:assistify/core/constants/custome_snack_bar.dart';
import 'package:assistify/domain/usecase/dashboard/user_profile_usecase.dart';
import 'package:assistify/presentation/cubit/dashboard/user_profile/user_profile_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../core/network/network_service.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final UserProfileUsecase useCase;
  final NetworkService networkService;

  UserProfileCubit({required this.useCase, required this.networkService})
    : super(UserProfileInitial());

  Future<void> userProfile(BuildContext context, String companyId) async {
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
      emit(UserProfileLoading());
      final userProfileEntity = await useCase.call(companyId);
      print(userProfileEntity);
      emit(UserProfileLoaded(userProfileEntity));
      if (userProfileEntity.status == 'SUCCESS') {
        emit(UserProfileLoaded(userProfileEntity));
      }
    } catch (e) {
      print('error in userProfile: $e');
      emit(
        UserProfileError(
          'Failed to load userProfile data: ${e.toString()}',
        ),
      );
    }
  }
}
