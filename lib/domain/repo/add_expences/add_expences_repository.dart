import 'package:assistify/data/model/add_expences/add_expence_model.dart';
import 'package:assistify/data/model/add_expences/delete_expence_model.dart';
import 'package:assistify/data/model/add_expences/edit_expence_model.dart';

abstract class AddExpencesRepository {
  Future<AddExpenceModel> add_Expences(dynamic body);
   Future<EditExpenceModel> edit_Expences(dynamic body);
  Future<DeleteExpencesModel> delete_Expences(dynamic id);
}
