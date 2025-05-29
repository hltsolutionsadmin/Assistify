import 'package:assistify/data/model/dash_board/search_mobile_number_model.dart';

abstract class SearchPhoneNumberState {}

class SearchPhoneNumberInitial extends SearchPhoneNumberState {}

class SearchPhoneNumberLoading extends SearchPhoneNumberState {}

class SearchPhoneNumberLoaded extends SearchPhoneNumberState {
  final SeachMobileNumberModel seachMobileNumberModel;
  SearchPhoneNumberLoaded(this.seachMobileNumberModel);
}

class SearchPhoneNumberError extends SearchPhoneNumberState {
  final String message;
 SearchPhoneNumberError(this.message);
}

