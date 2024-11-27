import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(BaseOptions(
        baseUrl: "https://farmconnects-s31x.onrender.com/api/",
        receiveDataWhenStatusError: true,
        headers: {
          "Content-Type": "application/json",
          "lang": 'en',
        }));
  }

  static Future<Response> postData({
    required String method,
    required Map<String, dynamic> data,
    String lang = 'en',
    String? token,
  }) async {

    dio.options.headers.addAll({
      'lang': lang,
      if (token != null) 'Authorization': 'Bearer $token',
    });


    return await dio.post(
      method,
      data: data,
    );
  }


  static Future<Response> getData({
    required String method,
    Map<String, dynamic>? query,
    String? token,
    String lang = 'en',
  }) async {
    // Ensure token uses the 'Bearer' format
    dio.options.headers.addAll({
      'lang': lang,
      if (token != null) 'Authorization': 'Bearer $token',
    });

    try {
      return await dio.get(method, queryParameters: query);
    } catch (error) {
      rethrow;
    }
  }

  static Future<Response> putData({
    required String method,
    required Map<String, dynamic> data,
    String lang = 'en',
    String? token,
  }) async {
    dio.options.headers.addAll({
      'lang': lang,
      if (token != null) 'Authorization': 'Bearer $token',
    });

    return await dio.put(
      method,
      data: data,
    );
  }
}
