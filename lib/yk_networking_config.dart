library yk_networking;

import 'package:yk_networking/yk_networking_request.dart';
import 'package:yk_networking/yk_networking_response.dart';
import 'package:dio/dio.dart';

class YKNetworkingConfig {

  static YKNetworkingConfig? _instance;
  Dio? _dio;

  int _timeOut = 30;
  int _receiveTimeout = 30;

  Dio get dio => _dio!;

  int get timeOut => _timeOut;

  int get receiveTimeout => _receiveTimeout;
  String baseUrl = "";
  Map<String, dynamic> commHeader = {};
  Map<String, dynamic> commParams = {};
  void Function(YKNetworkingRequest request, YKNetworkingResponse response)? cacheRequest;

  factory YKNetworkingConfig.getInstance() {
    _instance ??= YKNetworkingConfig._();
    return _instance!;
  }

  YKNetworkingConfig._() {
    _dio = Dio(BaseOptions(
        connectTimeout: Duration(seconds: _timeOut),
        receiveTimeout: Duration(seconds: _receiveTimeout)
    ));
  }

  set receiveTimeout(int value) {
    _dio!.options.receiveTimeout = Duration(seconds: value);
    _receiveTimeout = value;
  }

  set timeOut(int value) {
    _dio!.options.connectTimeout = Duration(seconds: value);
    _timeOut = value;
  }
}