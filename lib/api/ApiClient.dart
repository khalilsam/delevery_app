import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final Dio _dio = Dio();
  final String base_url='https://badhrah.com/zsapi/public';
  static final storage = new FlutterSecureStorage();
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      Response response = await _dio.post(
        base_url+'/api/login',
        queryParameters: {'email': email, 'password': password},
      );
      //returns the successful user data json object
      return response.data;
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> getOrders(String status,String? token) async {
    try {
      print('uri==>${Uri.encodeFull(base_url+'/api/orders/list/${status}')}');
      Response response = await _dio.get(
        Uri.encodeFull(base_url+'/api/orders/list/${status}'),
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization":"Bearer $token"
          })
      );

      //returns the successful user data json object
      return response.data;
    } on DioError catch (e) {
      //returns the error object if any
      print(e);
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> updateStatus(int id, String status,String reason,String? token) async {
    try {
      Response response = await _dio.post(
          Uri.encodeFull(base_url+'/api/orders/update/${id}'),
          data: {"pending_status": status, "driver_message": reason},
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization":"Bearer $token"
          })
      );
      print(response.data);
      //returns the successful user data json object
      return response.data;
    } on DioError catch (e) {
      //returns the error object if any
      print(e.response!.data);
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> saveCallLog(int id, String duration,String time,String? token) async {
    try {
      Response response = await _dio.post(
          Uri.encodeFull(base_url+'/api/orders/callLog/${id}'),
          data: {"duration": duration, "time": time},
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization":"Bearer $token"
          })
      );
      print(response.data);
      //returns the successful user data json object
      return response.data;
    } on DioError catch (e) {
      //returns the error object if any
      print(e.response!.data);
      return e.response!.data;
    }
  }

  static Future<void> storeToken(String token) async{
    await storage.write(key: "token", value: token);
  }
  static Future<String?> getToken(String token) async{
    return await storage.read(key: "token");
  }
}
