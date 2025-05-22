

import 'package:assistify/data/datasource/login/login_datasource.dart';
import 'package:assistify/data/model/login/login_model.dart';
import 'package:assistify/domain/repo/login/login_repository.dart';

class LoginRepoImpl implements LogInRepository {
  final LoginDatasource remoteDataSource;

  LoginRepoImpl({required this.remoteDataSource});

  @override
  Future<LogInModel> logIn(String email, String password) async {
    final model = await remoteDataSource.logIn(email, password);
    return LogInModel(
      message: model.message,
      status: model.status,
      data: model.data != null
          ? Data(
              token: model.data!.token,
              user: model.data?.user != null ? User(
                userId: model.data?.user?.userId,
                email: model.data?.user?.email,
                companyId: model.data?.user?.companyId,
                firstName: model.data?.user?.firstName,
                lastName: model.data?.user?.lastName,
              ): null
             )
          : null,
    );
  }
}
