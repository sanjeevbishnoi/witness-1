import 'package:dio/dio.dart';

import '../../../core/global_variables.dart';

class DioHelper {
  static String baseUrl = "http://91.232.125.244:8085";
  static String contentType = "application/json";
  static String authorization = token;

  static Map<String, String> headers = {
    'Accept': contentType,
    'Content-Type': contentType,
    'Authorization': authorization,
  };
  static Dio? dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    dio!.options.headers = headers;
    return await dio!.get(url, queryParameters: query);
  }

  static Future<Response> postData({
    required String url,
    required FormData data,
    Map<String, dynamic>? query,
  }) async {
    dio!.options.headers = headers;
    return dio!.post(
      url,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
  }) async {
    dio!.options.headers = headers;
    return dio!.put(url, queryParameters: query, data: data);
  }

  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    dio!.options.headers = headers;
    return dio!.delete(url, queryParameters: query);
  }
}
