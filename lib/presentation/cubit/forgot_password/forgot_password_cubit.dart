import 'package:assistify/core/constants/custome_snack_bar.dart';
import 'package:assistify/domain/usecase/forgot_password/forgot_password_usecase.dart';
import 'package:assistify/presentation/cubit/forgot_password/forgot_password_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../core/network/network_service.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordUsecase useCase;
  final NetworkService networkService;

  ForgotPasswordCubit({required this.useCase, required this.networkService})
    : super(ForgotPasswordInitial());

  Future<void> forgotPassword(
    BuildContext context,
    String email,
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
    if (email.isEmpty) {
      _showErrorDialog(context, 'Please enter a user name ');
      return;
    } else if (email.length < 10) {
      _showErrorDialog(context, 'Please enter a valid user name');
      return;
    }
    try {
      emit(ForgotPasswordLoading());
      final forgotPasswordEntity = await useCase(email);
      print('login status::$forgotPasswordEntity');
      emit(ForgotPasswordLoaded(forgotPasswordEntity));
      if (forgotPasswordEntity.status == 'SUCCESS') {
         
       
      } else {
         CustomSnackbars.showErrorSnack(
        context: context,
        title: 'Alert',
        message: 'UnAuthorised',
      );

      }
    } catch (e) {
       CustomSnackbars.showErrorSnack(
        context: context,
        title: 'Error',
        message: 'Invalid User name or Password',
      );
      print('error in login: $e');
      emit(ForgotPasswordError('Failed to load OTP data: ${e.toString()}'));
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
