import 'package:dio/dio.dart';
import '../../../core/util/global_variables.dart';
import 'package:fresh_dio/fresh_dio.dart';

class DioHelper {
  static String baseUrl = "http://91.232.125.244:8085";
  static String contentType = "application/json";
  static String? authorization = token;

  static Map<String, String> headers = {
    'Accept': contentType,
    'Content-Type': contentType,
    'Authorization': authorization ?? "",
  };
  static Dio? dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        validateStatus: (status) => status! < 500,
        followRedirects: false,
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    dio!.options.headers = headers;
    dio!.options.headers["Authorization"] = token;
    return await dio!.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required String url,
    required dynamic data,
    Map<String, dynamic>? query,
  }) async {
    dio!.options.headers = headers;
    dio!.options.headers["Authorization"] = token;
    return await dio!.post(
      url,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> putData({
    required String url,
    required dynamic data,
    Map<String, dynamic>? query,
  }) async {
    dio!.options.headers = headers;
    dio!.options.headers["Authorization"] = token;
    return await dio!.put(url, queryParameters: query, data: data);
  }

  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    dio!.options.headers = headers;
    dio!.options.headers["Authorization"] = token;
    return await dio!.delete(url, queryParameters: query);
  }
}
