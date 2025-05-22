import 'dart:convert';
import 'package:assistify/core/constants/api_constatnts.dart';
import 'package:assistify/data/model/forgot_password/forgot_password_model.dart';
import 'package:dio/dio.dart';

abstract class ForgotPasswordDatasource {
  Future<ForgotPasswordModel> forgotpassword(String email);
}

class ForgotPasswordRemoteDataSourceImpl implements ForgotPasswordDatasource {
  final Dio client;

  ForgotPasswordRemoteDataSourceImpl({required this.client});

  @override
  Future<ForgotPasswordModel> forgotpassword(String email) async {
    final payload = {"email": email};

    try {
      final response = await client.post(
        forgotPassword,
        data: json.encode(payload),
      );
      print('Response of forgotpassword status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Response data: ${response.data}');

        return ForgotPasswordModel.fromJson(response.data);
      } else if (response.statusCode == 401) {
        print(response);
        throw Exception(
          'Failed to load forgotpassword data: ${response.statusCode}',
        );
      } else {
        throw Exception(
          'Failed to forgotpassword  data: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load forgotpassword data: ${e.toString()}');
    }
  }
}
