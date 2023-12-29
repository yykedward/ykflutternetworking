library yknetworking;


import 'dart:io';
import 'package:dio/dio.dart';
import 'package:yknetworking/yknetworkingconfig.dart';
import 'package:yknetworking/yknetworkingResponse.dart';
import 'package:yknetworking/yknetworkingRequest.dart';

export 'package:yknetworking/yknetworkingconfig.dart';
export 'package:yknetworking/yknetworkingResponse.dart';
export 'package:yknetworking/yknetworkingRequest.dart';




class YKNetworking {

  late Dio _dio;
  Exception? Function(YKNetworkingResponse response)? handleData;


  Map<String, dynamic>? Function(YKNetworkingRequest request)? dynamicHeader; //每次请求都会动态添加到头部中
  Map<String, dynamic>? Function(YKNetworkingRequest request)? dynamicParams; //每次请求都会动态添加到参数中

  Function(Exception ex)? errorCallBack;
  Map<String, dynamic>? commonHeader;
  Map<String, dynamic>? commonParams;
  String? _baseUrl;

  YKNetworking({String? baseUrl, this.commonHeader, this.commonParams, this.handleData, this.errorCallBack}) {

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

  Future<YKNetworkingResponse> get(String path,
      {
        Map<String, dynamic>? params,
        Map<String, dynamic>? header,
      }) async {
    return await request(path, method: YKNetworkingMethod.get, params: params, header: header);
  }

  Future<YKNetworkingResponse> post(String path,
      {
        Map<String, dynamic>? params,
        Map<String, dynamic>? header,
      }) async {
    return await request(path, method: YKNetworkingMethod.post, params: params, header: header);
  }

  Future<YKNetworkingResponse> request(String path,
      {
        YKNetworkingMethod method = YKNetworkingMethod.get,
        Map<String, dynamic>? params,
        Map<String, dynamic>? header,
      }) async {

    var _request = _getRequest(method, path);
    Map<String, dynamic> commheader = YKNetworkingConfig.getInstance().commHeader;
    if (commonHeader != null) {
      commheader.addAll(commonHeader!);
    }
    if (header != null) {
      commheader.addAll(header!);
    }
    if (dynamicHeader != null) {
      var dHeader = dynamicHeader!(_request);
      if (dHeader != null) {
        commheader.addAll(dHeader!);
      }
    }

    Map<String, dynamic> commParams = YKNetworkingConfig.getInstance().commParams;
    if (commonParams != null) {
      commParams.addAll(commonParams!);
    }
    if (params != null) {
      commParams.addAll(params!);
    }
    if (dynamicParams != null) {
      var dParams = dynamicParams!(_request);
      if (dParams != null) {
        commParams.addAll(dParams!);
      }
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

  Future<YKNetworkingResponse> upload(String path, String filePath,
      {
        Map<String, dynamic>? params,
        Map<String, dynamic>? header,
      }) async {

    var _request = _getRequest(YKNetworkingMethod.post, path);
    Map<String, dynamic> commheader = YKNetworkingConfig.getInstance().commHeader;
    if (commonHeader != null) {
      commheader.addAll(commonHeader!);
    }
    if (header != null) {
      commheader.addAll(header!);
    }
    if (dynamicHeader != null) {
      var dHeader = dynamicHeader!(_request);
      if (dHeader != null) {
        commheader.addAll(dHeader!);
      }
    }

    Map<String, dynamic> commParams = YKNetworkingConfig.getInstance().commParams;
    if (commonParams != null) {
      commParams.addAll(commonParams!);
    }
    if (params != null) {
      commParams.addAll(params!);
    }
    if (dynamicParams != null) {
      var dParams = dynamicParams!(_request);
      if (dParams != null) {
        commParams.addAll(dParams!);
      }
    }

    try {

      File file = File(filePath);
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "Filedata": await MultipartFile.fromFile(file.path, filename: fileName),
      });

      commParams.addAll({"filename":fileName});

      Response response = await _dio.post(
        path,
        data: formData,
        queryParameters: commParams,
        options: Options(headers: commheader),
      );

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

  /// TODO:正在修改, 未经过测试，不建议使用
  Future<dynamic?> download(String path) async {
    try {
      var _request = _getRequest(YKNetworkingMethod.post, path);
      Map<String, dynamic> commheader = YKNetworkingConfig.getInstance().commHeader;
      if (commonHeader != null) {
        commheader.addAll(commonHeader!);
      }
      if (dynamicHeader != null) {
        var dHeader = dynamicHeader!(_request);
        if (dHeader != null) {
          commheader.addAll(dHeader!);
        }
      }

      Map<String, dynamic> commParams = YKNetworkingConfig.getInstance().commParams;
      if (commonParams != null) {
        commParams.addAll(commonParams!);
      }
      if (dynamicParams != null) {
        var dParams = dynamicParams!(_request);
        if (dParams != null) {
          commParams.addAll(dParams!);
        }
      }

      final response = await _dio.get(path, options: Options(responseType: ResponseType.bytes));

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

  YKNetworkingRequest _getRequest(YKNetworkingMethod method,String path) {
    var method = "GET";

    if (method == YKNetworkingMethod.get) {
      method = "GET";
    } else if (method == YKNetworkingMethod.post) {
      method = "POST";
    } else if (method == YKNetworkingMethod.put) {
      method = "PUT";
    }

    YKNetworkingRequest request = YKNetworkingRequest(baseUrl: "$_baseUrl", path: path, method: method);
    return request;
  }
}