import 'package:assistify/data/model/dash_board/save_bill_model.dart';

abstract class SaveBillRepository {
  Future<SaveBillModel> saveBill(dynamic body);
}
