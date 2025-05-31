import 'package:assistify/data/model/dash_board/all_bills_model.dart';
import 'package:assistify/data/model/dash_board/bill_spares_model.dart';
import 'package:assistify/data/model/dash_board/search_bill_model.dart';

abstract class AllBillsState {}

class AllBillsInitial extends AllBillsState {}
class SearchBillsInitial extends AllBillsState {}
class SpareBillsInitial extends AllBillsState {}
class FilterBillsInitial extends AllBillsState {}

class AllBillsLoading extends AllBillsState {}
class SearchBillsLoading extends AllBillsState {}
class SpareBillsLoading extends AllBillsState {}
class FilterBillsLoading extends AllBillsState {}


class AllBillsLoaded extends AllBillsState {
  final AllBillsModel allBillsModel;
  AllBillsLoaded(this.allBillsModel);
}

class SearchBillsLoaded extends AllBillsState {
  final SearchBillModel searchBillModel;
  SearchBillsLoaded(this.searchBillModel);
}

class SpareBillsLoaded extends AllBillsState {
  final BillSparesModel billSparesModel;
  SpareBillsLoaded(this.billSparesModel);
}
class FilterBillsLoaded extends AllBillsState {
  final AllBillsModel allBillsModel;
FilterBillsLoaded(this.allBillsModel);
}

class AllBillsError extends AllBillsState {
  final String message;
 AllBillsError(this.message);
}

class SearchBillsError extends AllBillsState {
  final String message;
 SearchBillsError(this.message);
}

class SpareBillsError extends AllBillsState {
  final String message;
 SpareBillsError(this.message);
}
class FilterBillsError extends AllBillsState {
  final String message;
 FilterBillsError(this.message);
}