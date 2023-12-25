library yknetworking;


import 'package:dio/dio.dart';
import 'package:yknetworking/yknetworkingconfig.dart';


enum YKNetworkingMethod {
  get,
  post,
  put,
}

class YKNetworkingResponse {

  dynamic? data;

  YKNetworkingResponse({this.data});
}

class YKNetworking {

  late Dio _dio;
  Exception? Function(YKNetworkingResponse response)? handleData;
  Function(Exception ex)? errorCallBack;
  Map<String, dynamic>? thisHeader;
  Map<String, dynamic>? thisParams;
  String? _baseUrl;

  YKNetworking({String? baseUrl, this.thisHeader,this.handleData,this.errorCallBack}) {

    String url = YKNetworkingConfig.getInstance().baseUrl;
    if (baseUrl != null) {
      url = baseUrl!;
    }
    _baseUrl = url;

    _dio = Dio(BaseOptions(
        baseUrl: url,
        connectTimeout: Duration(seconds: YKNetworkingConfig.getInstance().timeOut),
        receiveTimeout: Duration(seconds: YKNetworkingConfig.getInstance().receiveTimeout)
    ));
  }

  Future<YKNetworkingResponse> request(String path,
      {
        YKNetworkingMethod method = YKNetworkingMethod.get,
        Map<String, dynamic>? params,
        Map<String, dynamic>? header,
      }) async {

    Map<String, dynamic> commheader = YKNetworkingConfig.getInstance().commHeader;
    if (thisHeader != null) {
      commheader.addAll(thisHeader!);
    }
    if (header != null) {
      commheader.addAll(header!);
    }

    Map<String, dynamic> commParams = YKNetworkingConfig.getInstance().commParams;
    if (thisParams != null) {
      commParams.addAll(thisParams!);
    }
    if (params != null) {
      commParams.addAll(params!);
    }

    try {
      Response? response;
      if (method == YKNetworkingMethod.get) {
        response = await _dio.get(path, queryParameters: commParams, options: Options(headers: commheader));
      } else if (method == YKNetworkingMethod.post) {
        response = await _dio.post(path, queryParameters: params, options: Options(headers: commheader));
      } else if (method == YKNetworkingMethod.put) {
        response = await _dio.put(path, queryParameters: params, options: Options(headers: commheader));
      } else {
        response = null;
      }

      if (response == null) {
        throw Exception(["请求错误"]);
      }
      YKNetworkingResponse resp = YKNetworkingResponse(data: response.data);
      if (handleData != null) {
        var result = handleData!(resp);

        if (result == null) {
          return resp;
        } else {
          throw result!;
        }
      } else {
        return resp;
      }
    } on Exception catch (e) {
      YKNetworkingResponse resp = YKNetworkingResponse(data: null);
      if (errorCallBack != null) {
        errorCallBack!(e);
      }
      return resp;
    }
  }
}