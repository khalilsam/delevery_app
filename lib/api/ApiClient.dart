import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      Response response = await _dio.post(
        'https://badhrah.com/zsapi/public/api/login',
        queryParameters: {'email': email, 'password': password},
      );
      //returns the successful user data json object
      return response.data;
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }
}
