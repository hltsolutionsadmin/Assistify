import 'package:assistify/data/model/dash_board/all_expences_model.dart';

abstract class AllExpencesRepository {
  Future<AllExpencesModel> all_Expences(dynamic id);
}
