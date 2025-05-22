import 'package:assistify/data/model/dash_board/all_expences_model.dart';

abstract class AllExpencesState {}

class AllExpencesInitial extends AllExpencesState {}

class AllExpencesLoading extends AllExpencesState {}

class AllExpencesLoaded extends AllExpencesState {
  final AllExpencesModel allExpencesModel;
  AllExpencesLoaded(this.allExpencesModel);
}

class AllExpencesError extends AllExpencesState {
  final String message;
 AllExpencesError(this.message);
}
