library yknetworking;

import 'package:dio/dio.dart';
import 'package:yknetworking/yk_networking_config.dart';
import 'package:yknetworking/yk_networking_request.dart';
import 'package:yknetworking/yk_networking_response.dart';

class YKBaseNetworking {

  //MARK: 请求
  static Future<YKNetworkingResponse> request(YKNetworkingRequest request) async {
    Dio dio = YKNetworkingConfig
        .getInstance()
        .dio;
    dio.options.baseUrl = request.baseUrl;
    dio.options.queryParameters = {};
    dio.options.headers = {};
    if (request.showLoadingCallBack != null && request.showLoading) {
      request.showLoadingCallBack!(true);
    }

    try {
      Response? response;
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
                headers: request.commheader,
                contentType: request.contentTypeStr()
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
                contentType: request.contentTypeStr(),
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
      YKNetworkingConfig.getInstance().cacheRequest?.call(request, resp);
      if (request.showLoadingCallBack != null && request.showLoading) {
        request.showLoadingCallBack!(false);
      }
      return resp;
    } on Exception catch (e) {
      Exception newE = e;

      YKNetworkingResponse resp = YKNetworkingResponse(data: null, exception: newE);
      if (request.errorCallBack != null) {
        request.errorCallBack!(request, newE);
      }
      YKNetworkingConfig.getInstance().cacheRequest?.call(request, resp);
      if (request.showLoadingCallBack != null && request.showLoading) {
        request.showLoadingCallBack!(false);
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
    if (request.showLoadingCallBack != null && request.showLoading) {
      request.showLoadingCallBack!(true);
    }
    try {
      Response? response;

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
      YKNetworkingConfig.getInstance().cacheRequest?.call(request, resp);
      if (request.showLoadingCallBack != null && request.showLoading) {
        request.showLoadingCallBack!(false);
      }
      return resp;
    } on Exception catch (e) {
      Exception newE = e;

      YKNetworkingResponse resp = YKNetworkingResponse(data: null, exception: newE);
      if (request.errorCallBack != null) {
        request.errorCallBack!(request, newE);
      }
      YKNetworkingConfig.getInstance().cacheRequest?.call(request, resp);
      if (request.showLoadingCallBack != null && request.showLoading) {
        request.showLoadingCallBack!(false);
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
    if (request.showLoadingCallBack != null && request.showLoading) {
      request.showLoadingCallBack!(true);
    }
    try {
      Response? response;

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

      YKNetworkingConfig.getInstance().cacheRequest?.call(request, resp);
      if (request.showLoadingCallBack != null && request.showLoading) {
        request.showLoadingCallBack!(false);
      }
      return resp;
    } on Exception catch (e) {
      Exception newE = e;

      YKNetworkingResponse resp = YKNetworkingResponse(data: null, exception: newE);
      if (request.errorCallBack != null) {
        request.errorCallBack!(request, newE);
      }
      YKNetworkingConfig.getInstance().cacheRequest?.call(request, resp);
      if (request.showLoadingCallBack != null && request.showLoading) {
        request.showLoadingCallBack!(false);
      }
      return resp;
    }
  }
}