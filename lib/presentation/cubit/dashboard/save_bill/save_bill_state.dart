import 'package:assistify/data/model/dash_board/save_bill_model.dart';

abstract class SaveBillState {}

class SaveBillInitial extends SaveBillState {}

class SaveBillLoading extends SaveBillState {}

class SaveBillLoaded extends SaveBillState {
  final SaveBillModel saveBillModel;
  SaveBillLoaded(this.saveBillModel);
}

class SaveBillError extends SaveBillState {
  final String message;
 SaveBillError(this.message);
}
