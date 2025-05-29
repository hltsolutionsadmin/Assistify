import 'dart:convert';

import 'package:assistify/core/constants/api_constatnts.dart';
import 'package:assistify/data/model/dash_board/edit_profile_model.dart';
import 'package:assistify/data/model/dash_board/user_profile_model.dart';
import 'package:dio/dio.dart';

abstract class UserProfileDatasource {
  Future<UserProfileModel> user_Profile(String companyId);
  Future<EditProfileModel> edit_Profile(String companyId, dynamic body);
}

class UserProfileDataSourceImpl implements UserProfileDatasource {
  final Dio client;

  UserProfileDataSourceImpl({required this.client});

  @override
  Future<UserProfileModel> user_Profile(String companyId) async {
    try {
      final response = await client.get('$userProfile/$companyId');
      print('Response status code of user_Profile: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Response data user_Profile: ${response.data}');

        return UserProfileModel.fromJson(response.data);
      } else if (response.statusCode == 401) {
        print(response);
        throw Exception('Failed to load user_Profile: ${response.statusCode}');
      } else {
        throw Exception('Failed to load user_Profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load user_Profile: ${e.toString()}');
    }
  }

  @override
  Future<EditProfileModel> edit_Profile(String companyId, dynamic body) async {
    try {
      final response = await client.put(
        '$userProfile/$companyId',
        data: jsonEncode(body),
      );
      print('Response status code of edit_Profile: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Response data edit_Profile: ${response.data}');

        return EditProfileModel.fromJson(response.data);
      } else if (response.statusCode == 401) {
        print(response);
        throw Exception('Failed to load edit_Profile: ${response.statusCode}');
      } else {
        throw Exception('Failed to load edit_Profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load edit_Profile: ${e.toString()}');
    }
  }
}
