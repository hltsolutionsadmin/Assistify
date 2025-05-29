import 'package:assistify/data/model/dash_board/search_mobile_number_model.dart';
import 'package:assistify/domain/repo/search_phone_number/search_phone_numeber_repository.dart';

class SearchPhoneNumberUsecase {
  final SearchPhoneNumeberRepository repository;
  SearchPhoneNumberUsecase({required this.repository});

   Future<SeachMobileNumberModel> call(String mobileNumber) async {
    return await repository.search_MobileNumber(mobileNumber);
  }

}
