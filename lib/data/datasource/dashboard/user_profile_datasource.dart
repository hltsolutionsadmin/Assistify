import 'package:assistify/core/constants/api_constatnts.dart';
import 'package:assistify/data/model/dash_board/user_profile_model.dart';
import 'package:dio/dio.dart';

abstract class UserProfileDatasource {
    Future<UserProfileModel> user_Profile(String companyId);
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

}
