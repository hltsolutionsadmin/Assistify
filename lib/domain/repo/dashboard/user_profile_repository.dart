import 'package:assistify/data/model/dash_board/user_profile_model.dart';

abstract class UserProfileRepository {
  Future<UserProfileModel> user_Profile(String CustomerId);
}
