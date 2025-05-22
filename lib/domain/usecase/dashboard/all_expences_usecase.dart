import 'package:assistify/data/model/dash_board/all_expences_model.dart';
import 'package:assistify/domain/repo/dashboard/all_expences_repository.dart';

class AllExpencesUsecase {
  final AllExpencesRepository repository;
  AllExpencesUsecase({required this.repository});

  Future<AllExpencesModel> call(dynamic id) async {
    return await repository.all_Expences(id);
  }
}
