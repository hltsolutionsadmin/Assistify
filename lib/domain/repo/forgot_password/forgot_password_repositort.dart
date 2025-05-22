import 'package:assistify/data/model/forgot_password/forgot_password_model.dart';

abstract class ForgotPasswordRepository {
  Future<ForgotPasswordModel> forgotpassword(String email);
}
