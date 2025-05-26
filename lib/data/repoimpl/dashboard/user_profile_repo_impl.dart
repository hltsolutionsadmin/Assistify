import 'package:assistify/data/datasource/dashboard/user_profile_datasource.dart';
import 'package:assistify/data/model/dash_board/user_profile_model.dart';
import 'package:assistify/domain/repo/dashboard/user_profile_repository.dart';

class UserProfileRepoImpl implements UserProfileRepository {
  final UserProfileDatasource remoteDataSource;

  UserProfileRepoImpl({required this.remoteDataSource});

    @override
  Future<UserProfileModel> user_Profile(String customerId) async {
    final model = await remoteDataSource.user_Profile( customerId);
    return UserProfileModel(
      message: model.message,
      status: model.status,  
      data: model.data != null
          ? Data(
              id: model.data!.id,
              name: model.data!.name,
              email: model.data!.email,
              address: model.data!.address,
              phoneNumber: model.data!.phoneNumber,
              logo: model.data!.logo,
              bannerImage: model.data!.bannerImage,
              initialJOBID: model.data!.initialJOBID,
              registeredIdentity: model.data!.registeredIdentity,
              termsAndConditions: model.data!.termsAndConditions,
              category: model.data!.category,
              jobIdFormat: model.data!.jobIdFormat,
              validityDate: model.data!.validityDate,
              createdAt: model.data!.createdAt,
              updatedAt: model.data!.updatedAt,
              products: model.data!.products,
              bills: model.data!.bills,
            )
          : null,
    );
  }
}
