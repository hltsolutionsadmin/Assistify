import 'package:assistify/data/model/dash_board/edit_profile_model.dart';
import 'package:assistify/data/model/dash_board/user_profile_model.dart';

abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}
class EditProfileInitial extends UserProfileState {}


class UserProfileLoading extends UserProfileState {}
class EditProfileLoading extends UserProfileState {}


class UserProfileLoaded extends UserProfileState {
  final UserProfileModel userProfileModel;
  UserProfileLoaded(this.userProfileModel);
}

class EditProfileLoaded extends UserProfileState {
  final EditProfileModel editProfileModel;
  EditProfileLoaded(this.editProfileModel);
}

class UserProfileError extends UserProfileState {
  final String message;
 UserProfileError(this.message);
}

class EditProfileError extends UserProfileState {
  final String message;
 EditProfileError(this.message);
}
