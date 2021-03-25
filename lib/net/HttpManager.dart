import 'package:dio/dio.dart';

class HttpManager {
  factory HttpManager() => _getInstance();
  static  HttpManager? _instance;

  Dio get http => _dio;
  late Dio _dio;

  static const int _CONNECT_TIMEOUT = 15000;
  static const int _RECEIVE_TIMEOUT = 15000;

  static _getInstance() {
    if (_instance == null) {
      _instance = HttpManager._();
    }
    return _instance;
  }

  ///
  /// 初始化
  ///
  HttpManager._() {
    var options = BaseOptions(
        connectTimeout: _CONNECT_TIMEOUT, receiveTimeout: _RECEIVE_TIMEOUT);
    _dio = Dio(options)
      ..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }
}
