library yknetworking;

import 'package:yknetworking/yk_networking_config.dart';
import 'package:yknetworking/yk_networking_response.dart';
import 'package:yknetworking/yk_networking_request.dart';
import 'package:yknetworking/yk_base_networking.dart';

export 'package:yknetworking/yk_networking_config.dart';
export 'package:yknetworking/yk_networking_response.dart';
export 'package:yknetworking/yk_networking_request.dart';


class YKNetworking {

  Exception? Function(YKNetworkingRequest request, YKNetworkingResponse response)? handleData;


  Future<Map<String, dynamic>?> Function(YKNetworkingRequest request)? dynamicHeader; //每次请求都会动态添加到头部中
  Future<Map<String, dynamic>?> Function(YKNetworkingRequest request)? dynamicParams; //每次请求都会动态添加到参数中

  Function(YKNetworkingRequest request, Exception ex)? errorCallBack;
  Map<String, dynamic>? commonHeader;
  Map<String, dynamic>? commonParams;
  void Function(bool show)? showLoadingCallBack;
  String? _baseUrl;

  YKNetworking({String? baseUrl, this.commonHeader, this.commonParams, this.handleData, this.errorCallBack, this.showLoadingCallBack}) {
    String url = YKNetworkingConfig
        .getInstance()
        .baseUrl;
    if (baseUrl != null) {
      url = baseUrl;
    }
    _baseUrl = url;
  }

  Future<YKNetworkingResponse> get(String path,
      {
        Map<String, dynamic>? params,
        Map<String, dynamic>? header,
        Function(int count, int total)? progressCallBack,
        bool showLoading = false,
        YKNetworkingContentType? contentType,
      }) async {
    return await request(path, method: YKNetworkingMethod.get, params: params, header: header, showLoading: showLoading, contentType: contentType);
  }

  Future<YKNetworkingResponse> post(String path,
      {
        Map<String, dynamic>? params,
        Map<String, dynamic>? header,
        Function(int count, int total)? progressCallBack,
        bool showLoading = false,
        YKNetworkingContentType? contentType,
      }) async {
    return await request(path, method: YKNetworkingMethod.post, params: params, header: header, showLoading: showLoading, contentType: contentType);
  }

  Future<YKNetworkingResponse> request(String path,
      {
        YKNetworkingMethod method = YKNetworkingMethod.get,
        Map<String, dynamic>? params,
        Map<String, dynamic>? header,
        Function(int count, int total)? progressCallBack,
        bool showLoading = false,
        YKNetworkingContentType? contentType,
      }) async {
    return await YKBaseNetworking.request(
        await _getRequest(method, path, header, params, progressCallBack, showLoading: showLoading, contentType: contentType));
  }

  Future<YKNetworkingResponse> upload(String path,
      String? fileLocalPath,
      String fileName,
      String fileMiniType,
      String formName,
      {
        Map<String, dynamic>? params,
        Map<String, dynamic>? header,
        Function(int count, int total)? progressCallBack,
        bool showLoading = false,
        YKNetworkingContentType? contentType,
      }) async {
    return await YKBaseNetworking.upload(await _uploadRequet(
        path,
        fileLocalPath,
        fileName,
        fileMiniType,
        formName,
        params: params,
        header: header,
        progressCallBack: progressCallBack,
        showLoading: showLoading,
        contentType: contentType
    ));
  }

  Future<YKNetworkingResponse> download(String url,
      {
        String? downloadPath = null,
        Map<String, dynamic>? params,
        Map<String, dynamic>? header,
        Function(int count, int total)? progressCallBack,
        bool showLoading = false,
        YKNetworkingContentType? contentType,
      }) async {
    return await YKBaseNetworking.download(await _downloadRequest(url,
        downloadPath: downloadPath,
        params: params,
        header: header,
        progressCallBack: progressCallBack,
        showLoading: showLoading,
        contentType: contentType
    ));
  }

  Future<YKNetworkingRequest> _getRequest(YKNetworkingMethod method,
      String path,
      Map<String, dynamic>? header,
      Map<String, dynamic>? params,
      Function(int count, int total)? progressCallBack,
      {
        bool showLoading = false,
        YKNetworkingContentType? contentType,
      }) async {
    YKNetworkingRequest request = YKNetworkingRequest(
      baseUrl: "$_baseUrl",
      path: path,
      method: method,
      handleData: handleData,
      errorCallBack: errorCallBack,
      progressCallBack: progressCallBack,
      showLoading: showLoading,
      showLoadingCallBack: showLoadingCallBack,
    );

    if (path.startsWith("http://") || path.startsWith("https://")) {
      request.baseUrl = path;
      request.path = "";
    }

    YKNetworkingConfig config = YKNetworkingConfig.getInstance();
    Map<String, dynamic> commheader = {};
    commheader.addAll(config.commHeader);
    if (commonHeader != null) {
      commheader.addAll(commonHeader!);
    }
    if (header != null) {
      commheader.addAll(header);
    }
    if (dynamicHeader != null) {
      var dHeader = await dynamicHeader!(request);
      if (dHeader != null) {
        commheader.addAll(dHeader);
      }
    }

    Map<String, dynamic> commParams = {};
    commParams.addAll(config.commParams);
    if (commonParams != null) {
      commParams.addAll(commonParams!);
    }
    if (params != null) {
      commParams.addAll(params);
    }
    if (dynamicParams != null) {
      var dParams = await dynamicParams!(request);
      if (dParams != null) {
        commParams.addAll(dParams);
      }
    }
    request.commheader = commheader;
    request.params = commParams;
    request.contentType = contentType;

    return request;
  }

  Future<YKNetworkingRequest> _uploadRequet(String path,
      String? fileLocalPath,
      String fileName,
      String fileMiniType,
      String formName,
      {
        Map<String, dynamic>? params,
        Map<String, dynamic>? header,
        Function(int count, int total)? progressCallBack,
        bool showLoading = false,
        YKNetworkingContentType? contentType,
      }) async {
    YKNetworkingRequest _request = await _getRequest(
        YKNetworkingMethod.post,
        path,
        header,
        params,
        progressCallBack,
        showLoading: showLoading
    );
    _request.upload(fileLocalPath, fileName, fileMiniType, formName);
    _request.contentType = contentType;

    return _request;
  }

  Future<YKNetworkingRequest> _downloadRequest(String url,
      {
        String? downloadPath,
        Map<String, dynamic>? params,
        Map<String, dynamic>? header,
        Function(int count, int total)? progressCallBack,
        bool showLoading = false,
        YKNetworkingContentType? contentType,
      }) async {
    YKNetworkingRequest _request = await _getRequest(
        YKNetworkingMethod.get,
        url,
        header,
        params,
        progressCallBack,
        showLoading: showLoading
    );
    _request.download(downloadPath);
    _request.contentType = contentType;

    return _request;
  }

}