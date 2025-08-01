library yk_networking;

import 'package:yknetworking/yk_networking_response.dart';
import 'package:dio/dio.dart';

enum YKNetworkingMethod {
  get,
  post,
  put,
}

enum YKNetworkingContentType {
  applicationXWwFormUrlencoded,
  applicationJson,
  textPlain,
  multipartFormData,
}


class YKNetworkingRequest {

  String baseUrl;
  String path;
  final YKNetworkingMethod method;

  YKNetworkingContentType? contentType;

  //===upload
  String? fileLocalPath;
  String fileName = "";
  String fileMiniType = "";
  String formName = "";


  //===download
  String? downloadPath;

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

  String? contentTypeStr() {

    String? type = null;

    if (this.contentType == YKNetworkingContentType.applicationXWwFormUrlencoded) {
      type = Headers.formUrlEncodedContentType;
    } else if (this.contentType == YKNetworkingContentType.applicationJson) {
      type = Headers.jsonContentType;
    } else if (this.contentType == YKNetworkingContentType.textPlain) {
      type = Headers.textPlainContentType;
    } else if (this.contentType == YKNetworkingContentType.multipartFormData) {
      type = Headers.multipartFormDataContentType;
    }

    return type;
  }

  Map<String, dynamic>? commheader;
  Map<String, dynamic>? params;
  Exception? Function(YKNetworkingRequest request, YKNetworkingResponse response)? handleData;
  Function(YKNetworkingRequest request, Exception ex)? errorCallBack;
  Function(int count, int total)? progressCallBack;
  Function(bool show)? showLoadingCallBack;
  bool showLoading = false;
  bool disableDynamicHeader = false;
  bool disableDynamicParams = false;

  YKNetworkingRequest({
    this.baseUrl = "",
    this.path = "",
    this.method = YKNetworkingMethod.get,
    this.commheader,
    this.params,
    this.handleData,
    this.errorCallBack,
    this.progressCallBack,
    this.showLoading = false,
    this.showLoadingCallBack,
    this.disableDynamicHeader = false,
    this.disableDynamicParams = false,
  });

  upload(String? fileLocalPath,
      String fileName,
      String fileMiniType,
      String formName,) {
    this.fileLocalPath = fileLocalPath;
    this.fileName = fileName;
    this.fileMiniType = fileMiniType;
    this.formName = formName;
  }

  download(String? downloadPath) {
    this.downloadPath = downloadPath;
  }
}