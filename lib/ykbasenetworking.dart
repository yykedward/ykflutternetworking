library yknetworking;

import 'package:dio/dio.dart';
import 'package:yknetworking/yknetworkingconfig.dart';
import 'package:yknetworking/yknetworkingRequest.dart';
import 'package:yknetworking/yknetworkingResponse.dart';

class YKBaseNetworking {

  //MARK: 请求
  static Future<YKNetworkingResponse> request(YKNetworkingRequest request) async {
    Dio dio = YKNetworkingConfig
        .getInstance()
        .dio;
    dio.options.baseUrl = request.baseUrl;
    dio.options.queryParameters = {};
    dio.options.headers = {};
    if (request.showloadingCallBack != null && request.showloading) {
      request.showloadingCallBack!(true);
    }

    try {
      Response? response = null;
      if (request.method == YKNetworkingMethod.get) {
        response = await dio.get(
            request.path,
            queryParameters: request.params,
            options: Options(
                sendTimeout: Duration(seconds: YKNetworkingConfig
                    .getInstance()
                    .timeOut),
                receiveTimeout: Duration(seconds: YKNetworkingConfig
                    .getInstance()
                    .receiveTimeout),
                headers: request.commheader
            ),
            onReceiveProgress: (count, total) {
              if (request.progressCallBack != null) {
                request.progressCallBack!(count, total);
              }
            }
        );
      } else if (request.method == YKNetworkingMethod.post) {
        response = await dio.post(
            request.path,
            data: request.params,
            options: Options(
                sendTimeout: Duration(seconds: YKNetworkingConfig
                    .getInstance()
                    .timeOut),
                receiveTimeout: Duration(seconds: YKNetworkingConfig
                    .getInstance()
                    .receiveTimeout),
                headers: request.commheader,
                contentType: Headers.formUrlEncodedContentType
            ),
            onReceiveProgress: (count, total) {
              if (request.progressCallBack != null) {
                request.progressCallBack!(count, total);
              }
            }
        );
      } else if (request.method == YKNetworkingMethod.put) {
        response = await dio.put(
            request.path,
            queryParameters: request.params,
            options: Options(
                sendTimeout: Duration(seconds: YKNetworkingConfig
                    .getInstance()
                    .timeOut),
                receiveTimeout: Duration(seconds: YKNetworkingConfig
                    .getInstance()
                    .receiveTimeout),
                headers: request.commheader
            ),
            onSendProgress: (count, total) {
              if (request.progressCallBack != null) {
                request.progressCallBack!(count, total);
              }
            }
        );
      }

      if (response == null) {
        throw Exception(["请求错误"]);
      }
      YKNetworkingResponse resp = YKNetworkingResponse(data: response.data);
      if (request.handleData != null) {
        var result = request.handleData!(request, resp);

        if (result != null) {
          throw result;
        }
      }
      if (YKNetworkingConfig
          .getInstance()
          .cacheRequest != null) {
        YKNetworkingConfig.getInstance().cacheRequest!(request, resp);
      }
      if (request.showloadingCallBack != null && request.showloading) {
        request.showloadingCallBack!(false);
      }
      return resp;
    } on Exception catch (e) {
      Exception newE = e;

      YKNetworkingResponse resp = YKNetworkingResponse(data: null, exception: newE);
      if (request.errorCallBack != null) {
        request.errorCallBack!(request, newE);
      }
      if (YKNetworkingConfig
          .getInstance()
          .cacheRequest != null) {
        YKNetworkingConfig.getInstance().cacheRequest!(request, resp);
      }
      if (request.showloadingCallBack != null && request.showloading) {
        request.showloadingCallBack!(false);
      }
      return resp;
    }
  }

  //MARK: 上传
  static Future<YKNetworkingResponse> upload(YKNetworkingRequest request) async {
    Dio dio = YKNetworkingConfig
        .getInstance()
        .dio;
    dio.options.baseUrl = request.baseUrl;
    dio.options.queryParameters = {};
    dio.options.headers = {};
    if (request.showloadingCallBack != null && request.showloading) {
      request.showloadingCallBack!(true);
    }
    try {
      Response? response = null;

      FormData formData = FormData.fromMap({});
      if (request.params != null) {
        final params = request.params!;
        params.addAll({
          request.formName: await MultipartFile.fromFile(request.fileLocalPath!, filename: request.fileName)
        });
        formData = FormData.fromMap(params);
      } else {
        formData = FormData.fromMap({
          request.formName: await MultipartFile.fromFile(request.fileLocalPath!, filename: request.fileName)
        });
      }

      if (request.fileLocalPath != null) {
        response = await dio.post(
          request.path,
          data: formData,
          options: Options(
              sendTimeout: Duration(seconds: YKNetworkingConfig
                  .getInstance()
                  .timeOut),
              receiveTimeout: Duration(seconds: YKNetworkingConfig
                  .getInstance()
                  .receiveTimeout),
              headers: request.commheader
          ),
          onSendProgress: (count, total) {
            if (request.progressCallBack != null) {
              request.progressCallBack!(count, total);
            }
          },
        );
      } else {
        throw Exception(["无上传数据"]);
      }

      YKNetworkingResponse resp = YKNetworkingResponse(data: response.data);
      if (request.handleData != null) {
        var result = request.handleData!(request, resp);

        if (result != null) {
          throw result;
        }
      }
      if (YKNetworkingConfig
          .getInstance()
          .cacheRequest != null) {
        YKNetworkingConfig.getInstance().cacheRequest!(request, resp);
      }
      if (request.showloadingCallBack != null && request.showloading) {
        request.showloadingCallBack!(false);
      }
      return resp;
    } on Exception catch (e) {
      Exception newE = e;

      YKNetworkingResponse resp = YKNetworkingResponse(data: null, exception: newE);
      if (request.errorCallBack != null) {
        request.errorCallBack!(request, newE);
      }
      if (YKNetworkingConfig
          .getInstance()
          .cacheRequest != null) {
        YKNetworkingConfig.getInstance().cacheRequest!(request, resp);
      }
      if (request.showloadingCallBack != null && request.showloading) {
        request.showloadingCallBack!(false);
      }
      return resp;
    }
  }

  //MARK: 下载
  static Future<YKNetworkingResponse> download(YKNetworkingRequest request) async {
    Dio dio = YKNetworkingConfig
        .getInstance()
        .dio;
    dio.options.baseUrl = request.baseUrl;
    dio.options.queryParameters = {};
    dio.options.headers = {};
    if (request.showloadingCallBack != null && request.showloading) {
      request.showloadingCallBack!(true);
    }
    try {
      Response? response = null;

      if (request.downloadPath != null) {
        response = await dio.download(
          request.path,
          request.downloadPath!,
          queryParameters: request.params,
          options: Options(
            headers: request.commheader,
            responseType: ResponseType.bytes
          ),
          onReceiveProgress: (count, total) {
            if (request.progressCallBack != null) {
              request.progressCallBack!(count, total);
            }
          }
        );
      } else {
        response = await dio.get(
          request.path,
          queryParameters: request.params,
          options: Options(
            headers: request.commheader,
            responseType: ResponseType.bytes
          ),
          onReceiveProgress: (count, total) {
            if (request.progressCallBack != null) {
              request.progressCallBack!(count, total);
            }
          }
        );
      }

      YKNetworkingResponse resp = YKNetworkingResponse(data: response.data);

      if (YKNetworkingConfig
          .getInstance()
          .cacheRequest != null) {
        YKNetworkingConfig.getInstance().cacheRequest!(request, resp);
      }
      if (request.showloadingCallBack != null && request.showloading) {
        request.showloadingCallBack!(false);
      }
      return resp;
    } on Exception catch (e) {
      Exception newE = e;

      YKNetworkingResponse resp = YKNetworkingResponse(data: null, exception: newE);
      if (request.errorCallBack != null) {
        request.errorCallBack!(request, newE);
      }
      if (YKNetworkingConfig
          .getInstance()
          .cacheRequest != null) {
        YKNetworkingConfig.getInstance().cacheRequest!(request, resp);
      }
      if (request.showloadingCallBack != null && request.showloading) {
        request.showloadingCallBack!(false);
      }
      return resp;
    }
  }
}