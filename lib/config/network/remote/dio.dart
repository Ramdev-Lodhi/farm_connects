import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(BaseOptions(
        baseUrl: "http://172.16.101.84:3000/api/",
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
    //adding to header map
    //note if it's assignment not add that will cause bad response!
    //so use addAll method if you're trying to add a header.
    dio.options.headers.addAll({
      'lang': lang,
      'Authorization': token,
    });

    return await dio.post(
      method,
      data: data,
    );
  }

//   static Future<Response> getData({
//     required String method,
//     Map<String, dynamic>? query,
//     String? token,
//     String lang = 'en'
// }) async
//   {
//     dio.options.headers.addAll({'Authorization' : token, 'lang' : lang});
//     return await dio.get(method, queryParameters: query);
//   }

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
      print('Error in getData: $error');
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
