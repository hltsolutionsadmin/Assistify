import 'package:assistify/data/model/login/login_model.dart';

abstract class LoginState {}

class LogInInitial extends LoginState {}

class LogInLoading extends LoginState {}

class LogInLoaded extends LoginState {
  final LogInModel logInModel;
  LogInLoaded(this.logInModel);
}



class LogInError extends LoginState {
  final String message;
  LogInError(this.message);
}
