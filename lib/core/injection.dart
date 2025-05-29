import 'package:assistify/core/network/dio_client.dart';
import 'package:assistify/core/network/network_service.dart';
import 'package:assistify/data/datasource/add_expences/add_expences_datasource.dart';
import 'package:assistify/data/datasource/add_products/add_products_datasource.dart';
import 'package:assistify/data/datasource/dashboard/all_bills_datasource.dart';
import 'package:assistify/data/datasource/dashboard/all_expences_datasource.dart';
import 'package:assistify/data/datasource/dashboard/inventory_products_datasource.dart';
import 'package:assistify/data/datasource/dashboard/save_bill_datasource.dart';
import 'package:assistify/data/datasource/dashboard/user_profile_datasource.dart';
import 'package:assistify/data/datasource/forgot_password/forgot_password_datasource.dart';
import 'package:assistify/data/datasource/login/login_datasource.dart';
import 'package:assistify/data/datasource/search_pnone_number/search_phone_number_datasource.dart';
import 'package:assistify/data/repoimpl/add_expences/add_expences_repo_impl.dart';
import 'package:assistify/data/repoimpl/add_products/add_products_repo_impl.dart';
import 'package:assistify/data/repoimpl/dashboard/all_bills_repo_impl.dart';
import 'package:assistify/data/repoimpl/dashboard/all_expences_repo_impl.dart';
import 'package:assistify/data/repoimpl/dashboard/inventory_products_repo_impl.dart';
import 'package:assistify/data/repoimpl/dashboard/save_bill_repo_impl.dart';
import 'package:assistify/data/repoimpl/dashboard/user_profile_repo_impl.dart';
import 'package:assistify/data/repoimpl/forgot_password/forgot_password_repo_impl.dart';
import 'package:assistify/data/repoimpl/login/login_repo_impl.dart';
import 'package:assistify/data/repoimpl/search_mobile_number/search_phone_number_repo_impl.dart';
import 'package:assistify/domain/repo/add_expences/add_expences_repository.dart';
import 'package:assistify/domain/repo/add_products/add_products_repository.dart';
import 'package:assistify/domain/repo/dashboard/all_bills_repository.dart';
import 'package:assistify/domain/repo/dashboard/all_expences_repository.dart';
import 'package:assistify/domain/repo/dashboard/inventory_products_repository.dart';
import 'package:assistify/domain/repo/dashboard/save_bill_repository.dart';
import 'package:assistify/domain/repo/dashboard/user_profile_repository.dart';
import 'package:assistify/domain/repo/forgot_password/forgot_password_repositort.dart';
import 'package:assistify/domain/repo/login/login_repository.dart';
import 'package:assistify/domain/repo/search_phone_number/search_phone_numeber_repository.dart';
import 'package:assistify/domain/usecase/add_expences/add_expences_useCase.dart';
import 'package:assistify/domain/usecase/add_products/add_products_useCase.dart';
import 'package:assistify/domain/usecase/dashboard/all_bills_usecase.dart';
import 'package:assistify/domain/usecase/dashboard/all_expences_usecase.dart';
import 'package:assistify/domain/usecase/dashboard/inventory_products_usecase.dart';
import 'package:assistify/domain/usecase/dashboard/save_bill_usecase.dart';
import 'package:assistify/domain/usecase/dashboard/user_profile_usecase.dart';
import 'package:assistify/domain/usecase/forgot_password/forgot_password_usecase.dart';
import 'package:assistify/domain/usecase/login/login_usecase.dart';
import 'package:assistify/domain/usecase/search_phone_number/search_phone_number_usecase.dart';
import 'package:assistify/presentation/cubit/add_expences/add_expences_cubit.dart';
import 'package:assistify/presentation/cubit/add_products/add_products_cubit.dart';
import 'package:assistify/presentation/cubit/dashboard/all_bills/all_bills_cubit.dart';
import 'package:assistify/presentation/cubit/dashboard/all_expences/all_expences_cubit.dart';
import 'package:assistify/presentation/cubit/dashboard/inventory_products/inventory_produts_cubit.dart';
import 'package:assistify/presentation/cubit/dashboard/save_bill/save_bill_cubit.dart';
import 'package:assistify/presentation/cubit/dashboard/user_profile/user_profile_cubit.dart';
import 'package:assistify/presentation/cubit/forgot_password/forgot_password_cubit.dart';
import 'package:assistify/presentation/cubit/login/logIn_cubit.dart';
import 'package:assistify/presentation/cubit/search_phone_number/search_phone_number_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
final GetIt sl = GetIt.instance;

void init(){
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => NetworkService());
  sl.registerLazySingleton<DioClient>(
    () => DioClient(sl<Dio>(), secureStorage: sl<FlutterSecureStorage>()),
  );
    //Login

  sl.registerLazySingleton<LoginDatasource>(
    () => LogInRemoteDataSourceImpl(client: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<LogInRepository>(
    () => LoginRepoImpl(remoteDataSource: sl<LoginDatasource>()),
  );
  sl.registerLazySingleton(
    () => LoginUsecase(repository: sl<LogInRepository>()),
  );
  sl.registerFactory(() => LoginCubit(useCase: sl<LoginUsecase>(), networkService: NetworkService()));


    //FORGOT PASSWORD

  sl.registerLazySingleton<ForgotPasswordDatasource>(
    () => ForgotPasswordRemoteDataSourceImpl(client: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<ForgotPasswordRepository>(
    () => ForgotPasswordRepoImpl(remoteDataSource: sl<ForgotPasswordDatasource>()),
  );
  sl.registerLazySingleton(
    () => ForgotPasswordUsecase(repository: sl<ForgotPasswordRepository>()),
  );
  sl.registerFactory(() => ForgotPasswordCubit(useCase: sl<ForgotPasswordUsecase>(), networkService: NetworkService()));


//DASHBOARD
//ALL BILLS

  sl.registerLazySingleton<AllBillsDatasource>(
    () => AllBillsDataSourceImpl(client: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<AllBillsRepository>(
    () => AllBillsRepoImpl(remoteDataSource: sl<AllBillsDatasource>()),
  );
  sl.registerLazySingleton(
    () => AllBillsUsecase(repository: sl<AllBillsRepository>()),
  );
  sl.registerFactory(() => AllBillsCubit(useCase: sl<AllBillsUsecase>(), networkService: NetworkService()));


  //INVENTORY PRODUCTS

  sl.registerLazySingleton<InventoryProductsDatasource>(
    () => InventoryProductsDataSourceImpl(client: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<InventoryProductsRepository>(
    () => InventoryProductsRepoImpl(remoteDataSource: sl<InventoryProductsDatasource>()),
  );
  sl.registerLazySingleton(
    () => InventoryProductsUsecase(repository: sl<InventoryProductsRepository>()),
  );
  sl.registerFactory(() => InventoryProdutsCubit(useCase: sl<InventoryProductsUsecase>(), networkService: NetworkService()));


  //ALL EXPENCES`

  sl.registerLazySingleton<AllExpencesDatasource>(
    () => AllExpencesDataSourceImpl(client: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<AllExpencesRepository>(
    () => AllExpencesRepoImpl(remoteDataSource: sl<AllExpencesDatasource>()),
  );
  sl.registerLazySingleton(
    () => AllExpencesUsecase(repository: sl<AllExpencesRepository>()),
  );
  sl.registerFactory(() => AllExpencesCubit(useCase: sl<AllExpencesUsecase>(), networkService: NetworkService()));


  //ADD PRODUCTS`

  sl.registerLazySingleton<AddProductsDatasource>(
    () => AddProductsDataSourceImpl(client: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<AddProductsRepository>(
    () => AddProductsRepoImpl(remoteDataSource: sl<AddProductsDatasource>()),
  );
  sl.registerLazySingleton(
    () => AddProductsUsecase(repository: sl<AddProductsRepository>()),
  );
  sl.registerFactory(() => AddProductsCubit(useCase: sl<AddProductsUsecase>(), networkService: NetworkService()));


   //SAVE BILL

  sl.registerLazySingleton<SaveBillDatasource>(
    () => SaveBilDataSourceImpl(client: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<SaveBillRepository>(
    () => SaveBillRepoImpl(remoteDataSource: sl<SaveBillDatasource>()),
  );
  sl.registerLazySingleton(
    () => SaveBillUsecase(repository: sl<SaveBillRepository>()),
  );
  sl.registerFactory(() => SaveBillCubit(useCase: sl<SaveBillUsecase>(), networkService: NetworkService()));


  //ADD EXPENCES

  sl.registerLazySingleton<AddExpencesDatasource>(
    () => AddExpencesDataSourceImpl(client: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<AddExpencesRepository>(
    () => AddExpencesRepoImpl(remoteDataSource: sl<AddExpencesDatasource>()),
  );
  sl.registerLazySingleton(
    () => AddExpencesUsecase(repository: sl<AddExpencesRepository>()),
  );
  sl.registerFactory(() => AddExpencesCubit(useCase: sl<AddExpencesUsecase>(), networkService: NetworkService()));

  //USER PROFILE

  sl.registerLazySingleton<UserProfileDatasource>(
    () => UserProfileDataSourceImpl(client: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<UserProfileRepository>(
    () => UserProfileRepoImpl(remoteDataSource: sl<UserProfileDatasource>()),
  );
  sl.registerLazySingleton(
    () => UserProfileUsecase(repository: sl<UserProfileRepository>()),
  );
  sl.registerFactory(() => UserProfileCubit(useCase: sl<UserProfileUsecase>(), networkService: NetworkService()));


  //SEARCH PHONE NUMBER

  sl.registerLazySingleton<SearchPhoneNumberDatasource>(
    () => SearchPhoneNumberDataSourceImpl(client: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<SearchPhoneNumeberRepository>(
    () => SearchMobileNumberRepoImpl(remoteDataSource: sl<SearchPhoneNumberDatasource>()),
  );
  sl.registerLazySingleton(
    () => SearchPhoneNumberUsecase(repository: sl<SearchPhoneNumeberRepository>()),
  );
  sl.registerFactory(() => SearchPhoneNumberCubit(useCase: sl<SearchPhoneNumberUsecase>(), networkService: NetworkService()));
}
