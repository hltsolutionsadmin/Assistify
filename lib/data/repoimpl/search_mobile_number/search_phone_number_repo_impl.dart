import 'package:assistify/data/datasource/search_pnone_number/search_phone_number_datasource.dart';
import 'package:assistify/data/model/dash_board/search_mobile_number_model.dart';
import 'package:assistify/domain/repo/search_phone_number/search_phone_numeber_repository.dart';

class SearchMobileNumberRepoImpl implements SearchPhoneNumeberRepository {
  final SearchPhoneNumberDatasource remoteDataSource;

  SearchMobileNumberRepoImpl({required this.remoteDataSource});

   @override
  Future<SeachMobileNumberModel> search_MobileNumber(String mobileNumber) async {
    final model = await remoteDataSource.search_MobileNumber( mobileNumber);
    return SeachMobileNumberModel(
      message: model.message,
      status: model.status,  
      data: model.data,        
    );
  }

}
