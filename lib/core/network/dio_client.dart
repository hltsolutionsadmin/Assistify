import 'dart:developer';
import 'package:assistify/core/constants/api_constatnts.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

 
enum Method { post, get, put, delete, patch }
 
class DioClient {
  final Dio dio;
  final FlutterSecureStorage secureStorage;
 
  DioClient(this.dio, {required this.secureStorage}) {
    dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = const Duration(seconds: 30)
      ..options.receiveTimeout = const Duration(seconds: 30)
      ..options.headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        print('options:: ${options.baseUrl}');
 
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('TOKEN');
 
        options.headers["Authorization"] = "Bearer $token";
       
        log('REQUEST[${options.method}] => PATH: ${options.path} '
            '=> Request Values: ${options.queryParameters}, => HEADERS: ${options.headers}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        log('RESPONSE[${response.statusCode}] => DATA: ${response.data}');
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        final statusCode = error.response?.statusCode;
        final errorMessage =
            error.response?.data['message'] ?? 'Unknown error occurred';
 
        log('ERROR[$statusCode] => MESSAGE: $errorMessage');
        if (statusCode == 400) {
          log("Error: Resource not found");
        } else if (statusCode == 404) {
          log("Error: Resource not found");
        } else if (statusCode == 500) {
          log("Error: Server error");
        } else if (statusCode == 401) {
          log("Error: Unauthorized access - token may have expired");
        }
 
        return handler.next(error);
      },
    ));
  }
 
  void init() {}
}
 
 