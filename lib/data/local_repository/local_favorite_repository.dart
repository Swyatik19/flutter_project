import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_project/data/models/repositry_model.dart';

abstract class LocalFavoriteRepository {
  Future<bool> saveFavorite(RepositoryModel model);
  Future<bool> deleteFavorite(String id);
  Future<List<RepositoryModel>> getAllFavorite();
  Future<bool> isFavorite(String id);
}

class LocalFavoriteRepositoryImpl extends LocalFavoriteRepository {
  final SharedPreferences sharedPreferences;
  final String favoritesKey = 'favorites';

  LocalFavoriteRepositoryImpl({required this.sharedPreferences});

  @override
  Future<bool> saveFavorite(RepositoryModel model) async {
    List<RepositoryModel> favorites = await getAllFavorite();
    if (!favorites.any((element) => element.id == model.id)) {
      favorites.add(model);
      return await _saveFavoritesList(favorites);
    }
    return false;
  }

  @override
  Future<bool> isFavorite(String id) async {
    List<RepositoryModel> favorites = await getAllFavorite();
    return favorites.any((element) => element.id == id);
  }

  @override
  Future<bool> deleteFavorite(String id) async {
    List<RepositoryModel> favorites = await getAllFavorite();
    favorites.removeWhere((element) => element.id == id);
    return await _saveFavoritesList(favorites);
  }

  @override
  Future<List<RepositoryModel>> getAllFavorite() async {
    final String? favoritesJson = sharedPreferences.getString(favoritesKey);
    if (favoritesJson != null) {
      Iterable decoded = jsonDecode(favoritesJson);
      return List<RepositoryModel>.from(
          decoded.map((model) => RepositoryModel.fromJson(model)));
    }
    return [];
  }

  Future<bool> _saveFavoritesList(List<RepositoryModel> favorites) async {
    final favoritesJson =
        jsonEncode(favorites.map((model) => model.toJson()).toList());
    return await sharedPreferences.setString(favoritesKey, favoritesJson);
  }
}
