library yknetworking;

import 'package:flutter/foundation.dart';

import 'dart:io';
import 'package:yknetworking/yknetworkingconfig.dart';
import 'package:yknetworking/yknetworkingResponse.dart';
import 'package:yknetworking/yknetworkingRequest.dart';
import 'package:yknetworking/ykbasenetworking.dart';

export 'package:yknetworking/yknetworkingconfig.dart';
export 'package:yknetworking/yknetworkingResponse.dart';
export 'package:yknetworking/yknetworkingRequest.dart';




class YKNetworking {

  Exception? Function(YKNetworkingRequest request, YKNetworkingResponse response)? handleData;


  Map<String, dynamic>? Function(YKNetworkingRequest request)? dynamicHeader; //每次请求都会动态添加到头部中
  Map<String, dynamic>? Function(YKNetworkingRequest request)? dynamicParams; //每次请求都会动态添加到参数中

  Function(YKNetworkingRequest request, Exception ex)? errorCallBack;
  Map<String, dynamic>? commonHeader;
  Map<String, dynamic>? commonParams;
  String? _baseUrl;

  YKNetworking({String? baseUrl, this.commonHeader, this.commonParams, this.handleData, this.errorCallBack}) {

    String url = YKNetworkingConfig.getInstance().baseUrl;
    if (baseUrl != null) {
      url = baseUrl!;
    }
    _baseUrl = url;
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

    YKNetworkingRequest request = _getRequest(method, path, commonHeader, header);

    var result = YKBaseNetworking.request(request);

    result.catchError((err) {
      debugPrint("inseit err:${err}");
    });

    return result;
  }



  YKNetworkingRequest _getRequest(YKNetworkingMethod method,String path,Map<String, dynamic>? header,Map<String, dynamic>? params) {


    YKNetworkingRequest _request = YKNetworkingRequest(
        baseUrl: "$_baseUrl",
        path: path,
        method: method,
        handleData: handleData,
        errorCallBack: errorCallBack
    );

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
    _request.commheader = commheader;
    _request.params = commParams;

    return _request;
  }


}