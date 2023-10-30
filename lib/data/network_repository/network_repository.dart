import 'package:dio/dio.dart';
import 'package:flutter_project/core/dimensions/dimensions.dart';
import 'package:flutter_project/data/models/repositry_model.dart';

abstract class NetworkRepository {
  Future<List<RepositoryModel>> search(String query);
}

class NetworkRepositoryImpl extends NetworkRepository {
  NetworkRepositoryImpl({required this.dio});

  final Dio dio;

  @override
  Future<List<RepositoryModel>> search(String query) async {
    final encodedQuery = Uri.encodeComponent(query);
    final response = await dio.get('/search/repositories?q=$encodedQuery',
        options: Options(headers: {}));

    if (response.statusCode == staysCode200) {
      List<dynamic> items = response.data['items'];
      return items.map((item) => RepositoryModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load repositories');
    }
  }
}
