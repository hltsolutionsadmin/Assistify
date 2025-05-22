
import 'package:assistify/data/model/dash_board/all_bills_model.dart';
import 'package:assistify/data/model/dash_board/bill_spares_model.dart';
import 'package:assistify/data/model/dash_board/search_bill_model.dart';
import 'package:assistify/domain/repo/dashboard/all_bills_repository.dart';

class AllBillsUsecase {
  final AllBillsRepository repository;
  AllBillsUsecase({required this.repository});

  Future<AllBillsModel> call(dynamic body) async {
    return await repository.allBills(body);
  }

   Future<SearchBillModel> search_Bills(String jobId, String userId, String customerId) async {
    return await repository.search_Bills(jobId, userId, customerId);
  }

   Future<BillSparesModel> spare_bills(String jobId) async {
    return await repository.spare_bills(jobId);
  }
}
