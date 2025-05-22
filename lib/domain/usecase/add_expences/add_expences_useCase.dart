import 'package:assistify/data/model/add_expences/add_expence_model.dart';
import 'package:assistify/data/model/add_expences/delete_expence_model.dart';
import 'package:assistify/data/model/add_expences/edit_expence_model.dart';
import 'package:assistify/domain/repo/add_expences/add_expences_repository.dart';

class AddExpencesUsecase {
  final AddExpencesRepository repository;
  AddExpencesUsecase({required this.repository});

  Future<AddExpenceModel> call(dynamic body) async {
    return await repository.add_Expences(body);
  }

  Future<EditExpenceModel> edit_Expences(dynamic body) async {
    return await repository.edit_Expences(body);
  }

   Future<DeleteExpencesModel> delete_Expences(dynamic id) async {
    return await repository.delete_Expences(id);
  }
}
