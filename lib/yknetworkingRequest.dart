library yknetworking;

import 'package:yknetworking/yknetworkingResponse.dart';
import 'package:dio/dio.dart';

enum YKNetworkingMethod {
  get,
  post,
  put,
}

enum YKNetworkingContentType {
  application_x_ww_form_urlencoded,
  application_json,
  text_plain,
  multipart_form_data,
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

    if (this.contentType == YKNetworkingContentType.application_x_ww_form_urlencoded) {
      type = Headers.formUrlEncodedContentType;
    } else if (this.contentType == YKNetworkingContentType.application_json) {
      type = Headers.jsonContentType;
    } else if (this.contentType == YKNetworkingContentType.text_plain) {
      type = Headers.textPlainContentType;
    } else if (this.contentType == YKNetworkingContentType.multipart_form_data) {
      type = Headers.multipartFormDataContentType;
    }

    return type;
  }

  Map<String, dynamic>? commheader;
  Map<String, dynamic>? params;
  Exception? Function(YKNetworkingRequest request, YKNetworkingResponse response)? handleData;
  Function(YKNetworkingRequest request, Exception ex)? errorCallBack;
  Function(int count, int total)? progressCallBack;
  Function(bool show)? showloadingCallBack;
  bool showloading = false;

  YKNetworkingRequest({
    this.baseUrl = "",
    this.path = "",
    this.method = YKNetworkingMethod.get,
    this.commheader = null,
    this.params = null,
    this.handleData = null,
    this.errorCallBack = null,
    this.progressCallBack = null,
    this.showloading = false,
    this.showloadingCallBack = null,
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

  download(String? downoadPath) {
    this.downloadPath = downoadPath;
  }
}