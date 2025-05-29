import 'dart:convert';
import 'package:assistify/core/constants/api_constatnts.dart';
import 'package:assistify/data/model/dash_board/all_bills_model.dart';
import 'package:assistify/data/model/dash_board/bill_spares_model.dart';
import 'package:assistify/data/model/dash_board/search_bill_model.dart';
import 'package:dio/dio.dart';

abstract class AllBillsDatasource {
  Future<AllBillsModel> allBills(dynamic body);
  Future<SearchBillModel> search_Bills(
    String jobId,
    String userId,
    String companyId,
  );
    Future<BillSparesModel> spare_bills(String jobId);
}

class AllBillsDataSourceImpl implements AllBillsDatasource {
  final Dio client;

  AllBillsDataSourceImpl({required this.client});

  @override
  Future<AllBillsModel> allBills(dynamic body) async {
    print(body);
    try {
      final response = await client.post(allBill, data: jsonEncode(body));
      print('Response status code of all bills: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Response data all bills: ${response.data}');

        return AllBillsModel.fromJson(response.data);
      } else if (response.statusCode == 401) {
        print(response);
        throw Exception('Failed to load all bills: ${response.statusCode}');
      } else {
        throw Exception('Failed to load all bills: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load all bills: ${e.toString()}');
    }
  }

  @override
  Future<SearchBillModel> search_Bills(
    String jobId,
    String userId,
    String companyId,
  ) async {
    print('$jobId, $userId, $companyId');
    try {
      final response = await client.get(
        '$searchBills?searchKey=$jobId&userId=$userId&companyId=$companyId',
      );
      print('Response status code of search bills: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Response data search bills: ${response.data}');

        return SearchBillModel.fromJson(response.data);
      } else if (response.statusCode == 401) {
        print(response);
        throw Exception('Failed to load search bills: ${response.statusCode}');
      } else if (response.statusCode == 400) {
        throw Exception('Failed to load search bills: ${response.statusCode}');
      } else {
        throw Exception('Failed to load search bills: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load search bills: ${e.toString()}');
    }
  }
  
  @override
  Future<BillSparesModel> spare_bills(
    String jobId,
  ) async {
    try {
      final response = await client.get(
        '$spareBills?billId=$jobId',
      );
      print('Response status code of BillSparesModel bills: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Response data BillSparesModel bills: ${response.data}');
        return BillSparesModel.fromJson(response.data);
      } else if (response.statusCode == 401) {
        print(response);
        throw Exception('Failed to load BillSparesModel bills: ${response.statusCode}');
      } else if (response.statusCode == 400) {
        throw Exception('Failed to load BillSparesModel bills: ${response.statusCode}');
      } else {
        throw Exception('Failed to load BillSparesModel bills: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load BillSparesModel bills: ${e.toString()}');
    }
  }
}
