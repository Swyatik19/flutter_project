import 'package:flutter_project/data/local_repository/local_favorite_repository.dart';
import 'package:flutter_project/data/models/repositry_model.dart';
import 'package:flutter_project/favirites/cubit/favorites_cubit_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final LocalFavoriteRepository localFavoriteRepository;

  FavoritesCubit(this.localFavoriteRepository) : super(FavoritesInitial());

  Future<void> getFavorites() async {
    try {
      emit(FavoritesLoading());
      final favorites = await localFavoriteRepository.getAllFavorite();
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> addFavorite(RepositoryModel repository) async {
    await localFavoriteRepository.saveFavorite(repository);
    getFavorites();
  }

  Future<void> removeFavorite(String repositoryId) async {
    await localFavoriteRepository.deleteFavorite(repositoryId);
    getFavorites();
  }
}
