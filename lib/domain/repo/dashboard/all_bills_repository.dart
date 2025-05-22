import 'package:assistify/data/model/dash_board/all_bills_model.dart';
import 'package:assistify/data/model/dash_board/bill_spares_model.dart';
import 'package:assistify/data/model/dash_board/search_bill_model.dart';

abstract class AllBillsRepository {
  Future<AllBillsModel> allBills(dynamic body);
  Future<SearchBillModel> search_Bills(String jobId, String userId, String customerId);
  Future<BillSparesModel> spare_bills(String jobId);
}
