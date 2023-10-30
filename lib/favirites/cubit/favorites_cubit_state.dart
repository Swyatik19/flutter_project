import 'package:flutter_project/data/models/repositry_model.dart';

abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<RepositoryModel> favorites;

  FavoritesLoaded(this.favorites);
}

class FavoritesError extends FavoritesState {
  final String message;

  FavoritesError(this.message);
}
