import 'package:assistify/data/model/forgot_password/forgot_password_model.dart';

abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordLoaded extends ForgotPasswordState {
  final ForgotPasswordModel logInModel;
  ForgotPasswordLoaded(this.logInModel);
}



class ForgotPasswordError extends ForgotPasswordState {
  final String message;
  ForgotPasswordError(this.message);
}
