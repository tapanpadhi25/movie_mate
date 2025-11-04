import 'package:dio/dio.dart';
import 'package:movie_mate/utils/api_url.dart';

abstract class MovieRepository {
  Future<dynamic> fetchAuthToken();

  Future<dynamic> fetchMovieList();
}

class MovieService extends MovieRepository {
  MovieService();

  var dio = Dio();

  @override
  Future<dynamic> fetchAuthToken() async {
    final data = {
      "socket_id": "870770.2318077",
      "channel_name": "private-account_690a1a6e0edcb3c6b0413959",
      "timezone": "Asia Calcutta",
    };

    try {
      print("---- Starting API call ----");
      print("URL: ${URLS.AUTH_API}");
      print("Body: $data");

      var response = await dio.post(
        URLS.AUTH_API,
        data: FormData.fromMap(data),
        // options: Options(
        //   headers: {"Accept": "application/json"},
        // ),
      );

      print("---- Response ----");
      print("Status Code: ${response.statusCode}");
      print("Data: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Unexpected status: ${response.statusCode}");
      }

    } on DioException catch (e) {
      print("---- DioException ----");
      print("Type: ${e.type}");
      print("Message: ${e.message}");
      print("Response: ${e.response?.data}");
      print("Status: ${e.response?.statusCode}");
      rethrow;
    } catch (e) {
      print("---- General Exception ----");
      print(e);
      rethrow;
    }
  }


  @override
  Future<dynamic> fetchMovieList() async {}
}
