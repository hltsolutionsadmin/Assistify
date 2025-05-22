import 'package:assistify/data/datasource/add_expences/add_expences_datasource.dart';
import 'package:assistify/data/model/add_expences/add_expence_model.dart';
import 'package:assistify/data/model/add_expences/delete_expence_model.dart';
import 'package:assistify/data/model/add_expences/edit_expence_model.dart';
import 'package:assistify/domain/repo/add_expences/add_expences_repository.dart';

class AddExpencesRepoImpl implements AddExpencesRepository {
  final AddExpencesDatasource remoteDataSource;

  AddExpencesRepoImpl({required this.remoteDataSource});

  @override
  Future<AddExpenceModel> add_Expences(dynamic body) async {
    final model = await remoteDataSource.add_Expences(body);
    return AddExpenceModel(
      message: model.message,
      status: model.status,
      data: model.data,
    );
  }

  @override
  Future<EditExpenceModel> edit_Expences(dynamic body) async {
    final model = await remoteDataSource.edit_Expences(body);
    return EditExpenceModel(
      message: model.message,
      status: model.status,
      data: model.data,
    );
  }

  @override
  Future<DeleteExpencesModel> delete_Expences(dynamic id) async {
    final model = await remoteDataSource.delete_Expence(id);
    return DeleteExpencesModel(
      message: model.message,
      status: model.status,
      data: model.data,
    );
  }
}
