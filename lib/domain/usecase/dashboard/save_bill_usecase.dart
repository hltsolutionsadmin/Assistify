import 'package:assistify/data/model/dash_board/save_bill_model.dart';
import 'package:assistify/domain/repo/dashboard/save_bill_repository.dart';

class SaveBillUsecase {
  final SaveBillRepository repository;
  SaveBillUsecase({required this.repository});

  Future<SaveBillModel> call(dynamic body) async {
    return await repository.saveBill(body);
  }
}
