import 'package:assistify/core/constants/api_constatnts.dart';
import 'package:assistify/data/model/login/login_model.dart';
import 'package:dio/dio.dart';


abstract class LoginDatasource {
  Future<LogInModel> logIn(String email, String password);
}

class LogInRemoteDataSourceImpl implements LoginDatasource {
  final Dio client;

  LogInRemoteDataSourceImpl({required this.client});

  @override
  Future<LogInModel> logIn(String email, String password) async {
    try {
      final response = await client.post(
        '$login?username=$email&password=$password',
      );
      print('Response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Response data: ${response.data}');
        
        return LogInModel.fromJson(response.data);
      } else if(response.statusCode == 401) {
        print(response);
        throw Exception('Failed to load login: ${response.statusCode}');
      } else  {
        throw Exception('Failed to load login: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load Login: ${e.toString()}');
    }
  }
}
