import 'package:assistify/data/model/dash_board/search_mobile_number_model.dart';

abstract class SearchPhoneNumeberRepository {
  Future<SeachMobileNumberModel> search_MobileNumber(String mobileNumber);
  
}
