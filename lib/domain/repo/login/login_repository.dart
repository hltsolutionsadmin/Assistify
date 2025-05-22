import 'package:assistify/data/model/login/login_model.dart';

abstract class LogInRepository {
  Future<LogInModel> logIn(String email, String password);
}
