import 'dart:convert';
import 'package:assistify/core/constants/api_constatnts.dart';
import 'package:assistify/data/model/add_product/add_product_model.dart';
import 'package:assistify/data/model/add_product/edit_product_model.dart';
import 'package:assistify/data/model/add_product/get_products_list_model.dart';
import 'package:dio/dio.dart';

abstract class AddProductsDatasource {
  Future<AddProductsModel> add_Products(dynamic body);
  Future<EditProductModel> edit_Products(dynamic body);
  Future<GetProductsListModel> get_Products(String companyId);
}

class AddProductsDataSourceImpl implements AddProductsDatasource {
  final Dio client;

  AddProductsDataSourceImpl({required this.client});

  @override
  Future<AddProductsModel> add_Products(dynamic body) async {
    print(body);
    try {
      final response = await client.post(addProduct, data: jsonEncode(body));
      print('Response status code of add_Products: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Response data add_Products: ${response.data}');

        return AddProductsModel.fromJson(response.data);
      } else if (response.statusCode == 401) {
        print(response);
        throw Exception('Failed to load add_Products: ${response.statusCode}');
      } else {
        throw Exception('Failed to load add_Products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load add_Products: ${e.toString()}');
    }
  }

  @override
  Future<EditProductModel> edit_Products(dynamic body) async {
    print(body);
    try {
      final response = await client.post(editProduct, data: jsonEncode(body));
      print('Response status code of editProduct: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Response data editProduct: ${response.data}');

        return EditProductModel.fromJson(response.data);
      } else if (response.statusCode == 401) {
        print(response);
        throw Exception('Failed to load editProduct: ${response.statusCode}');
      } else {
        throw Exception('Failed to load editProduct: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load editProduct: ${e.toString()}');
    }
  }

  @override
  Future<GetProductsListModel> get_Products(String companyId) async {
    try {
      final response = await client.get('$getProductById/$companyId');
      print('Response status code of get_Products: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Response data editProduct: ${response.data}');

        return GetProductsListModel.fromJson(response.data);
      } else if (response.statusCode == 401) {
        print(response);
        throw Exception('Failed to load get_Products: ${response.statusCode}');
      } else {
        throw Exception('Failed to load get_Products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load get_Products: ${e.toString()}');
    }
  }
}
