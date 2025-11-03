
import 'package:assistify/core/constants/custome_snack_bar.dart';
import 'package:assistify/data/model/dash_board/all_bills_model.dart';
import 'package:assistify/domain/usecase/dashboard/all_bills_usecase.dart';
import 'package:assistify/presentation/cubit/dashboard/all_bills/all_bills_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../core/network/network_service.dart';

class AllBillsCubit extends Cubit<AllBillsState> {
  final AllBillsUsecase useCase;
  final NetworkService networkService;

  AllBillsCubit({required this.useCase, required this.networkService})
    : super(AllBillsInitial());

List<Bills>? _allBills = [];
    
bool _isFilterApplied = false;
  Future<void> all_bills(BuildContext context, dynamic body, {bool isFilter = false}) async {
  bool isConnected = await networkService.hasInternetConnection();
  if (!isConnected) {
    CustomSnackbars.showErrorSnack(
      context: context,
      title: 'Alert',
      message: 'Please check Internet Connection',
    );
    return;
  }

  try {
    if (body["pageNumber"] == "1") {
      _allBills = [];
      _isFilterApplied = isFilter;
      emit(AllBillsLoading());
    }

    final allBillsEntity = await useCase.call(body);

    if (allBillsEntity.status == 'SUCCESS') {
      final newBills = allBillsEntity.data?.bills ?? [];
      _allBills!.addAll(newBills);
      emit(AllBillsLoaded(
        AllBillsModel(
          status: allBillsEntity.status,
          message: allBillsEntity.message,
          data: Data(bills: _allBills),
        ),
      ));
    }
  } catch (e) {
    emit(AllBillsError('Failed to load bills: ${e.toString()}'));
  }
}

  
  
  Future<void> searchBills({
    required BuildContext context,
    required String jobId,
    required String userId,
    required String companyId,
  }) async {
    bool isConnected = await networkService.hasInternetConnection();
    print(isConnected);

    if (!isConnected) {
      print("No Internet Connection");
      CustomSnackbars.showErrorSnack(
        context: context,
        title: 'Alert',
        message: 'Please check Internet Connection',
      );
      return;
    }
    try {
      emit(SearchBillsLoading());
      final searchBillsEntity = await useCase.search_Bills(jobId, userId, companyId);
      print(searchBillsEntity);
      if (searchBillsEntity.status == 'SUCCESS') {
        emit(SearchBillsLoaded(searchBillsEntity));
      } else {
        emit(SearchBillsError('Failed to load searchBillsEntity data'));
      }
    } catch (e) {
      print('error in allbills: $e');
      emit(SearchBillsError('Failed to load searchBillsEntity data: ${e.toString()}'));
    }
  }
  
   Future<void> spareBills({
    required BuildContext context,
    required String jobId,
  }) async {
    bool isConnected = await networkService.hasInternetConnection();
    print(isConnected);

    if (!isConnected) {
      print("No Internet Connection");
      CustomSnackbars.showErrorSnack(
        context: context,
        title: 'Alert',
        message: 'Please check Internet Connection',
      );
      return;
    }
    try {
      emit(SpareBillsLoading());
      final spareBillsEntity = await useCase.spare_bills(jobId);
      print(spareBillsEntity);
      if (spareBillsEntity.status == 'SUCCESS') {
        emit(SpareBillsLoaded(spareBillsEntity));
      } else {
        emit(SpareBillsError('Failed to load spareBillsEntity data'));
      }
    } catch (e) {
      print('error in allbills: $e');
      emit(SpareBillsError('Failed to load spareBillsEntity data: ${e.toString()}'));
    }
  }

}
