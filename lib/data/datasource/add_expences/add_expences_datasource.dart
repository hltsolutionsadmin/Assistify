import 'dart:convert';
import 'package:assistify/core/constants/api_constatnts.dart';
import 'package:assistify/data/model/add_expences/add_expence_model.dart';
import 'package:assistify/data/model/add_expences/delete_expence_model.dart';
import 'package:assistify/data/model/add_expences/edit_expence_model.dart';
import 'package:dio/dio.dart';

abstract class AddExpencesDatasource {
  Future<AddExpenceModel> add_Expences(dynamic body);
  Future<EditExpenceModel> edit_Expences(dynamic body);
  Future<DeleteExpencesModel> delete_Expence(dynamic id);
}

class AddExpencesDataSourceImpl implements AddExpencesDatasource {
  final Dio client;
  AddExpencesDataSourceImpl({required this.client});

  @override
  Future<AddExpenceModel> add_Expences(dynamic body) async {
    print(body);
    try {
      final response = await client.post(addExpences, data: jsonEncode(body));
      print('Response status code of add_Products: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Response data add_Expences: ${response.data}');

        return AddExpenceModel.fromJson(response.data);
      } else if (response.statusCode == 401) {
        print(response);
        throw Exception('Failed to load add_Expences: ${response.statusCode}');
      } else {
        throw Exception('Failed to load add_Expences: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load add_Expences: ${e.toString()}');
    }
  }

  @override
  Future<EditExpenceModel> edit_Expences(dynamic body) async {
    print(body);
    try {
      final response = await client.post(editExpences, data: jsonEncode(body));
      print('Response status code of edit_Expences: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Response data edit_Expences: ${response.data}');

        return EditExpenceModel.fromJson(response.data);
      } else if (response.statusCode == 401) {
        print(response);
        throw Exception('Failed to load edit_Expences: ${response.statusCode}');
      } else {
        throw Exception('Failed to load edit_Expences: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load edit_Expences: ${e.toString()}');
    }
  }

  @override
  Future<DeleteExpencesModel> delete_Expence(dynamic id) async {
    print(id.runtimeType);
    try {
      final response = await client.get('$deleteExpences/$id');
      print('Response status code of delete_Expence: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Response data delete_Expence: ${response.data}');
        return DeleteExpencesModel.fromJson(response.data);
      } else if (response.statusCode == 401) {
        print(response);
        throw Exception(
          'Failed to load delete_Expence: ${response.statusCode}',
        );
      } else {
        throw Exception(
          'Failed to load delete_Expence: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load delete_Expence: ${e.toString()}');
    }
  }
}
