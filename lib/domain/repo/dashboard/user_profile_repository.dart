import 'package:assistify/data/model/dash_board/edit_profile_model.dart';
import 'package:assistify/data/model/dash_board/user_profile_model.dart';

abstract class UserProfileRepository {
  Future<UserProfileModel> user_Profile(String CustomerId);
    Future<EditProfileModel> edit_Profile(String CustomerId, dynamic body);
}
