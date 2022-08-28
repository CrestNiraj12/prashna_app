import 'package:dio/dio.dart';

Dio dio() {
  Dio dio = Dio();
  dio.options.baseUrl = "https://studypill.org/api";

  // dio.options.baseUrl = "http://192.168.10.169:8000/api";

  dio.options.headers['accept'] = 'application/json';
  dio.options.connectTimeout = 60 * 1000;
  dio.options.receiveTimeout = 60 * 1000;
  return dio;
}
