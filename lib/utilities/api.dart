import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

Dio dio() {
  Dio dio = Dio();
  String url = "https://studypill.org/api";
  // String url = "http://192.168.10.169:8000/api";
  dio.options.baseUrl = url;

  dio.options.headers['accept'] = 'application/json';
  dio.options.connectTimeout = 60 * 1000;
  dio.options.receiveTimeout = 60 * 1000;
  dio.interceptors.add(DioCacheManager(CacheConfig(baseUrl: url)).interceptor);
  return dio;
}
