import 'package:assistify/data/model/add_expences/add_expence_model.dart';
import 'package:assistify/data/model/add_expences/delete_expence_model.dart';
import 'package:assistify/data/model/add_expences/edit_expence_model.dart';

abstract class AddExpencesState {}

class AddExpencesInitial extends AddExpencesState {}
class EditExpencesInitial extends AddExpencesState {}
class DeleteExpencesInitial extends AddExpencesState {}



class AddExpencesLoading extends AddExpencesState {}
class EditExpencesLoading extends AddExpencesState {}
class DeleteExpencesLoading extends AddExpencesState {}



class AddExpencesLoaded extends AddExpencesState {
  final AddExpenceModel addProductsModel;
  AddExpencesLoaded(this.addProductsModel);
}

class EditExpencesLoaded extends AddExpencesState {
  final EditExpenceModel editProductModel;
  EditExpencesLoaded(this.editProductModel);
}

class DeleteExpencesLoaded extends AddExpencesState {
  final DeleteExpencesModel deleteProductModel;
  DeleteExpencesLoaded(this.deleteProductModel);
}

class AddExpencesError extends AddExpencesState {
  final String message;
 AddExpencesError(this.message);
}

class EditExpencesError extends AddExpencesState {
  final String message;
 EditExpencesError(this.message);
}

class DeleteExpencesError extends AddExpencesState {
  final String message;
 DeleteExpencesError(this.message);
}