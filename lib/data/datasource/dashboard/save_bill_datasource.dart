import 'dart:convert';
import 'package:assistify/core/constants/api_constatnts.dart';
import 'package:assistify/data/model/dash_board/save_bill_model.dart';
import 'package:dio/dio.dart';


abstract class SaveBillDatasource {
  Future<SaveBillModel> save_bills(dynamic body);

}

class SaveBilDataSourceImpl implements SaveBillDatasource {
  final Dio client;

  SaveBilDataSourceImpl({required this.client});

  @override
  Future<SaveBillModel> save_bills(dynamic body) async {
    print(body);
    try {
      final response = await client.post(
        saveBill,
        data: jsonEncode(body),
      );
      print('Response status code of SaveBillModel: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Response data add_Products: ${response.data}');
        
        return SaveBillModel.fromJson(response.data);
      } else if(response.statusCode == 401) {
        print(response);
        throw Exception('Failed to load SaveBillModel: ${response.statusCode}');
      } else  {
        throw Exception('Failed to load SaveBillModel: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load SaveBillModel: ${e.toString()}');
    }
  }

  // @override
  // Future<EditProductModel> edit_Products(dynamic body) async {
  //   print(body);
  //   try {
  //     final response = await client.post(
  //       editProduct,
  //       data: jsonEncode(body),
  //     );
  //     print('Response status code of editProduct: ${response.statusCode}');
  //     if (response.statusCode == 200) {
  //       print('Response data editProduct: ${response.data}');
        
  //       return EditProductModel.fromJson(response.data);
  //     } else if(response.statusCode == 401) {
  //       print(response);
  //       throw Exception('Failed to load editProduct: ${response.statusCode}');
  //     } else  {
  //       throw Exception('Failed to load editProduct: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to load editProduct: ${e.toString()}');
  //   }
  // }
}
