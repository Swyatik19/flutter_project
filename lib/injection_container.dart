import 'package:dio/dio.dart';
import 'package:flutter_project/core/dimensions/dimensions.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_project/data/local_repository/local_favorite_repository.dart';
import 'package:flutter_project/data/local_repository/local_history_repository.dart';
import 'package:flutter_project/data/network_repository/network_repository.dart';
import 'package:flutter_project/favirites/cubit/favorites_cubit_cubit.dart';
import 'package:flutter_project/search/cubit/search_cubit_cubit.dart';

final sl = GetIt.instance;

Future<void> setup() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.github.com/',
      connectTimeout: const Duration(milliseconds: milliseconds10_000),
      receiveTimeout: const Duration(milliseconds: milliseconds10_000),
    ),
  );
  dio.options.headers = {
    "content-type": "application/json",
    "Accept": "application/json",
  };
  sl.registerLazySingleton<Dio>(
    () => dio,
  );

  sl.registerLazySingleton<SearchCubit>(() => SearchCubit(
        sl<NetworkRepository>(),
        sl<LocalHistoryRepository>(),
      ));
  sl.registerLazySingleton<FavoritesCubit>(
      () => FavoritesCubit(sl<LocalFavoriteRepository>()));

  sl.registerSingleton<NetworkRepository>(NetworkRepositoryImpl(dio: dio));
  sl.registerSingleton<LocalFavoriteRepository>(
      LocalFavoriteRepositoryImpl(sharedPreferences: sharedPreferences));
  sl.registerSingleton<LocalHistoryRepository>(
      LocalHistoryRepositoryImpl(sharedPreferences: sharedPreferences));
}
