import 'package:assistify/core/constants/custome_snack_bar.dart';
import 'package:assistify/domain/usecase/login/login_usecase.dart';
import 'package:assistify/presentation/cubit/login/logIn_state.dart';
import 'package:assistify/presentation/screen/dashboard/dash_board_screen.dart';
import 'package:assistify/presentation/screen/homescreen/home_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/network_service.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUsecase useCase;
  final NetworkService networkService;

  LoginCubit({required this.useCase, required this.networkService})
    : super(LogInInitial());

  Future<void> logIn(
    BuildContext context,
    String email,
    String password,
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
      emit(LogInLoading());
      final otpEntity = await useCase(email, password);
      print('login status::$otpEntity');
      emit(LogInLoaded(otpEntity));
      if (otpEntity.status == 'SUCCESS') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('TOKEN', otpEntity.data?.token ?? '');
        prefs.setString("email", otpEntity.data?.user?.email ?? '');
        prefs.setString("userId", otpEntity.data?.user?.userId ?? '');
        prefs.setString("companyId", otpEntity.data?.user?.companyId ?? '');
        prefs.setString("firstName", otpEntity.data?.user?.firstName ?? '');
        prefs.setString("lastName", otpEntity.data?.user?.lastName ?? '');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
        );
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
      emit(LogInError('Failed to load OTP data: ${e.toString()}'));
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
