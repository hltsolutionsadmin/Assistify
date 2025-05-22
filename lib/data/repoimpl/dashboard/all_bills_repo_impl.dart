import 'package:assistify/data/datasource/dashboard/all_bills_datasource.dart';
import 'package:assistify/data/model/dash_board/all_bills_model.dart';
import 'package:assistify/data/model/dash_board/bill_spares_model.dart';
import 'package:assistify/data/model/dash_board/search_bill_model.dart';
import 'package:assistify/domain/repo/dashboard/all_bills_repository.dart';

class AllBillsRepoImpl implements AllBillsRepository {
  final AllBillsDatasource remoteDataSource;

  AllBillsRepoImpl({required this.remoteDataSource});

  @override
  Future<AllBillsModel> allBills(dynamic body) async {
    final model = await remoteDataSource.allBills( body);
    return AllBillsModel(
      message: model.message,
      status: model.status,  
      data: model.data,        
    );
  }

   @override
  Future<SearchBillModel> search_Bills(String jobId, String userId, String customerId) async {
    final model = await remoteDataSource.search_Bills( jobId, userId, customerId);
    return SearchBillModel(
      message: model.message,
      status: model.status,  
      data: model.data,        
    );
  }

    @override
  Future<BillSparesModel> spare_bills(String jobId) async {
    final model = await remoteDataSource.spare_bills( jobId);
    return BillSparesModel(
      message: model.message,
      status: model.status,  
      data: model.data,        
    );
  }
}
