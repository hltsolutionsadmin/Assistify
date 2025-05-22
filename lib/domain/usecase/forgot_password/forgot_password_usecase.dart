import 'package:assistify/data/model/forgot_password/forgot_password_model.dart';
import 'package:assistify/domain/repo/forgot_password/forgot_password_repositort.dart';

class ForgotPasswordUsecase {
  final ForgotPasswordRepository repository;

  ForgotPasswordUsecase({required this.repository});

  Future<ForgotPasswordModel> call(String email) async {
    return await repository.forgotpassword(email);
  }
}
