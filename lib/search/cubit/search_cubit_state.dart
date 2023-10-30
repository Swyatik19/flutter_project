import 'package:flutter_project/data/models/repositry_model.dart';

abstract class SearchCubitState {}

class SearchCubitInitial extends SearchCubitState {}

class SearchCubitLoading extends SearchCubitState {}

class SearchCubitLoaded extends SearchCubitState {
  final List<RepositoryModel> repositories;

  SearchCubitLoaded(this.repositories);
}

class SearchCubitError extends SearchCubitState {
  final String message;

  SearchCubitError(this.message);
}

class HistoryCubitLoaded extends SearchCubitState {
  List<RepositoryModel> repositories;

  HistoryCubitLoaded(this.repositories);
}

class SearchCubitEmpty extends SearchCubitState {}
