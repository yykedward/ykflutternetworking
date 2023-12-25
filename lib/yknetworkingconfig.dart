

class YKNetworkingConfig {

  static YKNetworkingConfig? _instance;

  int timeOut = 30;
  int receiveTimeout = 30;
  String baseUrl = "";
  Map<String, dynamic> commHeader = {};
  Map<String, dynamic> commParams = {};

  factory YKNetworkingConfig.getInstance() {
    _instance ??= YKNetworkingConfig._();
    return _instance!;
  }

  YKNetworkingConfig._();
}