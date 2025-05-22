import 'package:assistify/core/constants/api_constatnts.dart';
import 'package:assistify/data/model/dash_board/all_expences_model.dart';
import 'package:dio/dio.dart';

abstract class AllExpencesDatasource {
    Future<AllExpencesModel> all_Expences(dynamic id);
}

class AllExpencesDataSourceImpl implements AllExpencesDatasource {
  final Dio client;

  AllExpencesDataSourceImpl({required this.client});
   @override
  Future<AllExpencesModel> all_Expences(dynamic id) async {
    print(id);
    try {
      final response = await client.get(
        '$expences/$id',
      );
      print('Response status code of AllExpences: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Response data delete_Product: ${response.data}');
        return AllExpencesModel.fromJson(response.data);
      } else if(response.statusCode == 401) {
        print(response);
        throw Exception('Failed to load AllExpences: ${response.statusCode}');
      } else  {
        throw Exception('Failed to load AllExpences: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load AllExpences: ${e.toString()}');
    }
  }
}
