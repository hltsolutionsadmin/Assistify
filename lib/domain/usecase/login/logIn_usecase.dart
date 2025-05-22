
import 'package:assistify/data/model/login/login_model.dart';
import 'package:assistify/domain/repo/login/login_repository.dart';

class LoginUsecase {
  final LogInRepository repository;

  LoginUsecase({required this.repository});

  Future<LogInModel> call(String email, String password) async {
    return await repository.logIn(email, password);
  }
}
