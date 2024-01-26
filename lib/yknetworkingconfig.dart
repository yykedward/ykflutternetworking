library yknetworking;

import 'package:yknetworking/yknetworkingRequest.dart';

class YKNetworkingConfig {

  static YKNetworkingConfig? _instance;

  int timeOut = 30;
  int receiveTimeout = 30;
  String baseUrl = "";
  Map<String, dynamic> commHeader = {};
  Map<String, dynamic> commParams = {};

  Function(YKNetworkingRequest request, Exception? ex)? cacheRequest;

  factory YKNetworkingConfig.getInstance() {
    _instance ??= YKNetworkingConfig._();
    return _instance!;
  }

  YKNetworkingConfig._();
}