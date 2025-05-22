import 'package:assistify/data/datasource/dashboard/all_expences_datasource.dart';
import 'package:assistify/data/model/dash_board/all_expences_model.dart';
import 'package:assistify/domain/repo/dashboard/all_expences_repository.dart';

class AllExpencesRepoImpl implements AllExpencesRepository{
  final AllExpencesDatasource remoteDataSource;

  AllExpencesRepoImpl({required this.remoteDataSource});

  @override
  Future<AllExpencesModel> all_Expences(dynamic id) async {
    final model = await remoteDataSource.all_Expences( id);
    return AllExpencesModel(
      message: model.message,
      status: model.status,  
      data: model.data,        
    );
  }
}
