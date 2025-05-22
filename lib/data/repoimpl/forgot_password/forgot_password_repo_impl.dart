import 'package:assistify/data/datasource/forgot_password/forgot_password_datasource.dart';
import 'package:assistify/data/model/forgot_password/forgot_password_model.dart';
import 'package:assistify/domain/repo/forgot_password/forgot_password_repositort.dart';

class ForgotPasswordRepoImpl implements ForgotPasswordRepository {
  final ForgotPasswordDatasource remoteDataSource;

  ForgotPasswordRepoImpl({required this.remoteDataSource});

  @override
  Future<ForgotPasswordModel> forgotpassword(String email) async {
    final model = await remoteDataSource.forgotpassword(email);
    return ForgotPasswordModel(
      message: model.message,
      status: model.status,
    );
  }
}
