library yknetworking;

import 'package:yknetworking/yknetworkingResponse.dart';

enum YKNetworkingMethod {
  get,
  post,
  put,
}



class YKNetworkingRequest {

  final String baseUrl;
  final String path;
  final YKNetworkingMethod method;

  String get methodStr {
    var method = "GET";

    if (method == YKNetworkingMethod.get) {
      method = "GET";
    } else if (method == YKNetworkingMethod.post) {
      method = "POST";
    } else if (method == YKNetworkingMethod.put) {
      method = "PUT";
    }
    return method;
  }
  Map<String, dynamic>? commheader;
  Map<String, dynamic>? params;
  Exception? Function(YKNetworkingRequest request, YKNetworkingResponse response)? handleData;
  Function(YKNetworkingRequest request, Exception ex)? errorCallBack;

  YKNetworkingRequest({this.baseUrl = "", this.path = "",this.method = YKNetworkingMethod.get,this.commheader = null, this.params = null, this.handleData = null,this.errorCallBack = null});
}