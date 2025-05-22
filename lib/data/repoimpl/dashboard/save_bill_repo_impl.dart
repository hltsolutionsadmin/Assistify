import 'package:assistify/data/datasource/dashboard/save_bill_datasource.dart';
import 'package:assistify/data/model/dash_board/save_bill_model.dart';
import 'package:assistify/domain/repo/dashboard/save_bill_repository.dart';

class SaveBillRepoImpl implements SaveBillRepository {
  final SaveBillDatasource remoteDataSource;

  SaveBillRepoImpl({required this.remoteDataSource});

  @override
  Future<SaveBillModel> saveBill(dynamic body) async {
    final model = await remoteDataSource.save_bills( body);
    return SaveBillModel(
      message: model.message,
      status: model.status,  
      // data: model.data,        
    );
  }
}
