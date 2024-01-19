library yknetworking;

import 'package:yknetworking/yknetworkingResponse.dart';
import 'dart:typed_data';

enum YKNetworkingMethod {
  get,
  post,
  put,
}



class YKNetworkingRequest {

  final String baseUrl;
  final String path;
  final YKNetworkingMethod method;

  String? fileLocalPath;
  String fileName = "";
  String fileMiniType = "";
  String formName = "";

  bool _isUpload = false;

  String methodStr() {
    var methodStr = "GET";

    if (this.method == YKNetworkingMethod.get) {
      methodStr = "GET";
    } else if (this.method == YKNetworkingMethod.post) {
      methodStr = "POST";
    } else if (this.method == YKNetworkingMethod.put) {
      methodStr = "PUT";
    }
    return methodStr;
  }
  Map<String, dynamic>? commheader;
  Map<String, dynamic>? params;
  Exception? Function(YKNetworkingRequest request, YKNetworkingResponse response)? handleData;
  Function(YKNetworkingRequest request, Exception ex)? errorCallBack;

  YKNetworkingRequest({
    this.baseUrl = "",
    this.path = "",
    this.method = YKNetworkingMethod.get,
    this.commheader = null,
    this.params = null,
    this.handleData = null,
    this.errorCallBack = null
  });

  upload(
    String? fileLocalPath,
    String fileName,
    String fileMiniType,
    String formName,
      ) {
    this.fileLocalPath = fileLocalPath;
    this.fileName = fileName;
    this.fileMiniType = fileMiniType;
    this.formName = formName;
    this._isUpload = true;
  }
}