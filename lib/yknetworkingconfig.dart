library yknetworking;

import 'package:yknetworking/yknetworkingRequest.dart';
import 'package:dio/dio.dart';

class YKNetworkingConfig {

  static YKNetworkingConfig? _instance;

  int timeOut = 30;
  int receiveTimeout = 30;
  String baseUrl = "";
  Map<String, dynamic> commHeader = {};
  Map<String, dynamic> commParams = {};
  Function(YKNetworkingRequest request, Exception? ex)? cacheRequest;

  Dio? _dio;

  factory YKNetworkingConfig.getInstance() {
    _instance ??= YKNetworkingConfig._();
    return _instance!;
  }

  YKNetworkingConfig._();

  Dio getDio() {

    if (_dio == null) {
      _dio = Dio(BaseOptions(
          connectTimeout: Duration(seconds: YKNetworkingConfig.getInstance().timeOut),
          receiveTimeout: Duration(seconds: YKNetworkingConfig.getInstance().receiveTimeout)
      ));
    }

    return _dio!;
  }
}