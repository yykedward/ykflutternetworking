library yknetworking;

import 'package:dio/dio.dart';
import 'package:yknetworking/yknetworkingconfig.dart';
import 'package:yknetworking/yknetworkingRequest.dart';
import 'package:yknetworking/yknetworkingResponse.dart';

class YKBaseNetworking {

  static Future<YKNetworkingResponse> request(YKNetworkingRequest request) async {


    Dio dio = Dio(BaseOptions(
        baseUrl: request.baseUrl,
        connectTimeout: Duration(seconds: YKNetworkingConfig.getInstance().timeOut),
        receiveTimeout: Duration(seconds: YKNetworkingConfig.getInstance().receiveTimeout)
    ));

    try {
      Response? response = null;
      if (request.method == YKNetworkingMethod.get) {
        response = await dio.get(
          request.path,
          queryParameters: request.params,
          options: Options(headers: request.commheader)
        );
      } else if (request.method == YKNetworkingMethod.post) {
        response = await dio.post(
          request.path,
          queryParameters: request.params,
          options: Options(headers: request.commheader)
        );
      } else if (request.method == YKNetworkingMethod.put) {
        response = await dio.put(
          request.path,
          queryParameters: request.params,
          options: Options(headers: request.commheader)
        );
      }

      if (response == null) {
        throw Exception(["请求错误"]);
      }
      YKNetworkingResponse resp = YKNetworkingResponse(data: response.data);
      if (request.handleData != null) {
        var result = request.handleData!(request,resp);

        if (result != null) {
          throw result!;
        }
      }
      if (YKNetworkingConfig.getInstance().cacheRequest != null) {
        YKNetworkingConfig.getInstance().cacheRequest!(request,null);
      }
      return resp;
    } on Exception catch (e) {
      YKNetworkingResponse resp = YKNetworkingResponse(data: null);
      if (request.errorCallBack != null) {
        request.errorCallBack!(request, e);
      }
      if (YKNetworkingConfig.getInstance().cacheRequest != null) {
        YKNetworkingConfig.getInstance().cacheRequest!(request,e);
      }
      return resp;
    }
  }

  static Future<YKNetworkingResponse> upload(YKNetworkingRequest request) async {

    YKNetworkingResponse resp = YKNetworkingResponse(data: null);

    return resp;
  }
}