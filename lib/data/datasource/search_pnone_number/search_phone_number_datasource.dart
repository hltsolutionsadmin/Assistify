import 'dart:convert';
import 'package:assistify/core/constants/api_constatnts.dart';
import 'package:assistify/data/model/dash_board/search_mobile_number_model.dart';
import 'package:dio/dio.dart';

abstract class SearchPhoneNumberDatasource {
  Future<SeachMobileNumberModel> search_MobileNumber(
    String mobileNumber,
  );
}

class SearchPhoneNumberDataSourceImpl implements SearchPhoneNumberDatasource {
  final Dio client;

  SearchPhoneNumberDataSourceImpl({required this.client});

  @override
  Future<SeachMobileNumberModel> search_MobileNumber(
    String mobileNumber,
   
  ) async {
    try {
      final response = await client.get(
        '$phoneSearch/$mobileNumber',
      );
      print('Response status code of search bills: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Response data search with mobile No: ${response.data}');

        return SeachMobileNumberModel.fromJson(response.data);
      } else if (response.statusCode == 401) {
        print(response);
        throw Exception('Failed to load search with mobile No: ${response.statusCode}');
      } else if (response.statusCode == 400) {
        throw Exception('Failed to load search with mobile No: ${response.statusCode}');
      } else {
        throw Exception('Failed to load search with mobile No: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load search with mobile No: ${e.toString()}');
    }
  }
  
 
}
