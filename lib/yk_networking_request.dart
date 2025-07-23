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

extension YKNetworkingMethodExtension on YKNetworkingMethod {

  String value() {
    switch (this) {
      case YKNetworkingMethod.get:
        return "GET";
      case YKNetworkingMethod.post:
        return "POST";
      case YKNetworkingMethod.put:
        return "PUT";
      default:
        return "";
    }
  }
}

extension YKNetworkingContentTypeExtension on YKNetworkingContentType {

  String value() {

    switch (this) {
      case YKNetworkingContentType.textPlain:
        return Headers.textPlainContentType;
      case YKNetworkingContentType.applicationXWwFormUrlencoded:
        return Headers.formUrlEncodedContentType;
      case YKNetworkingContentType.multipartFormData:
        return Headers.multipartFormDataContentType;
      case YKNetworkingContentType.applicationJson:
        return Headers.jsonContentType;
      default:
        return "";
    }
  }
}