import 'package:assistify/data/model/dash_board/edit_profile_model.dart';
import 'package:assistify/data/model/dash_board/user_profile_model.dart';
import 'package:assistify/domain/repo/dashboard/user_profile_repository.dart';

class UserProfileUsecase {
  final UserProfileRepository repository;
  UserProfileUsecase({required this.repository});

   Future<UserProfileModel> call(String customerId) async {
    return await repository.user_Profile(customerId);
  }
     Future<EditProfileModel> edit_Profile(String customerId, body) async {
    return await repository.edit_Profile(customerId, body);
  }
}
