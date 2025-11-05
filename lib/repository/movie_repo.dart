import 'package:dio/dio.dart';

import '../model/movie_model.dart';
import '../utils/global_auth.dart';

abstract class MovieRepository {
  Future<dynamic> fetchMovieList({int page = 1, int limit = 8});
}

class MovieService extends MovieRepository {
  MovieService();

  var dio = Dio();

  @override
  Future<dynamic> fetchMovieList({int page = 1, int limit = 8}) async {
    try {
      var response = await dio.get(
        "$API2&page=$page",
        options: Options(headers: {"Authorization": "Bearer $accessToken"}),
      );
      if (response.statusCode == 200) {
        return MovieModel.fromJson(response.data);
      }else {
        throw Exception("Failed with status: ${response.statusCode}");
      }
    } on DioException catch (e) {
      print(e.response!.data);
      throw Exception(e.toString());
    }
  }
}
