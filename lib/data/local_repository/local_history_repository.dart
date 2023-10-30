import 'dart:convert';

import 'package:flutter_project/core/dimensions/dimensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_project/data/models/repositry_model.dart';

abstract class LocalHistoryRepository {
  Future<void> saveSearchQuery(RepositoryModel query);

  Future<List<RepositoryModel>> getSearchHistory();

  Future<void> clearSearchHistory();

  Future<bool> isFavorite(String id);
}

class LocalHistoryRepositoryImpl extends LocalHistoryRepository {
  final SharedPreferences sharedPreferences;
  final String searchHistoryKey = 'searchHistory';

  LocalHistoryRepositoryImpl({required this.sharedPreferences});

  @override
  Future<void> saveSearchQuery(RepositoryModel query) async {
    List<RepositoryModel> history = await getSearchHistory();

    history.removeWhere((item) => item.name == query.name);

    history.insert(startWith0, query);
    if (history.length > length15) {
      history = history.sublist(startWith0, length15);
    }
    await _saveSearchHistory(history);
  }

  @override
  Future<List<RepositoryModel>> getSearchHistory() async {
    final String? historyJson = sharedPreferences.getString(searchHistoryKey);
    if (historyJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(historyJson) as List<dynamic>;
        return decoded
            .map((item) =>
                RepositoryModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  @override
  Future<void> clearSearchHistory() async {
    await sharedPreferences.remove(searchHistoryKey);
  }

  Future<void> _saveSearchHistory(List<RepositoryModel> history) async {
    final List<dynamic> historyJsonList =
        history.map((query) => query.toJson()).toList();
    final String historyJson = jsonEncode(historyJsonList);
    await sharedPreferences.setString(searchHistoryKey, historyJson);
  }

  @override
  Future<bool> isFavorite(String id) async {
    List<RepositoryModel> favorites = await getSearchHistory();
    return favorites.any((element) => element.id == id);
  }
}
