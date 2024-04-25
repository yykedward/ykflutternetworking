library yknetworking;

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
  void Function(bool show)? showloadingCallBack;
  String? _baseUrl;

  YKNetworking({String? baseUrl, this.commonHeader, this.commonParams, this.handleData, this.errorCallBack, this.showloadingCallBack}) {
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
        bool showloading = false,
      }) async {
    return await request(path, method: YKNetworkingMethod.get, params: params, header: header, showloading: showloading);
  }

  Future<YKNetworkingResponse> post(String path,
      {
        Map<String, dynamic>? params,
        Map<String, dynamic>? header,
        Function(int count, int total)? progressCallBack,
        bool showloading = false,
      }) async {
    return await request(path, method: YKNetworkingMethod.post, params: params, header: header, showloading: showloading);
  }

  Future<YKNetworkingResponse> request(String path,
      {
        YKNetworkingMethod method = YKNetworkingMethod.get,
        Map<String, dynamic>? params,
        Map<String, dynamic>? header,
        Function(int count, int total)? progressCallBack,
        bool showloading = false,
      }) async {
    return await YKBaseNetworking.request(_getRequest(method, path, header, params, progressCallBack, showloading: showloading));
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
        bool showloading = false,
      }) async {
    return await YKBaseNetworking.upload(_uploadRequet(
        path,
        fileLocalPath,
        fileName,
        fileMiniType,
        formName,
        params: params,
        header: header,
        progressCallBack: progressCallBack,
      showloading: showloading,
    ));
  }

  Future<YKNetworkingResponse> download(String url,
      {
        String? downloadPath = null,
        Map<String, dynamic>? params,
        Map<String, dynamic>? header,
        Function(int count, int total)? progressCallBack,
        bool showloading = false,
      }) async {
    return await YKBaseNetworking.download(_downloadRequest(url,
        downloadPath: downloadPath,
        params: params,
        header: header,
        progressCallBack: progressCallBack,
      showloading: showloading,
    ));
  }

  YKNetworkingRequest _getRequest(YKNetworkingMethod method,
      String path,
      Map<String, dynamic>? header,
      Map<String, dynamic>? params,
      Function(int count, int total)? progressCallBack,
      {
        bool showloading = false,
      }
      ) {
    YKNetworkingRequest _request = YKNetworkingRequest(
      baseUrl: "$_baseUrl",
      path: path,
      method: method,
      handleData: handleData,
      errorCallBack: errorCallBack,
      progressCallBack: progressCallBack,
      showloading: showloading,
      showloadingCallBack: showloadingCallBack,
    );

    if (path.startsWith("http://") || path.startsWith("https://")) {
      _request.baseUrl = path;
      _request.path = "";
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
      var dHeader = dynamicHeader!(_request);
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
      var dParams = dynamicParams!(_request);
      if (dParams != null) {
        commParams.addAll(dParams);
      }
    }
    _request.commheader = commheader;
    _request.params = commParams;

    return _request;
  }

  YKNetworkingRequest _uploadRequet(String path,
      String? fileLocalPath,
      String fileName,
      String fileMiniType,
      String formName,
      {
        Map<String, dynamic>? params,
        Map<String, dynamic>? header,
        Function(int count, int total)? progressCallBack,
        bool showloading = false,
      }) {
    YKNetworkingRequest _request = _getRequest(
      YKNetworkingMethod.post,
      path,
      header,
      params,
      progressCallBack,
      showloading: showloading
    );
    _request.upload(fileLocalPath, fileName, fileMiniType, formName);

    return _request;
  }

  YKNetworkingRequest _downloadRequest(String url,
      {
        String? downloadPath,
        Map<String, dynamic>? params,
        Map<String, dynamic>? header,
        Function(int count, int total)? progressCallBack,
        bool showloading = false,
      }) {
    YKNetworkingRequest _request = _getRequest(
        YKNetworkingMethod.get,
        url,
        header,
        params,
        progressCallBack,
      showloading: showloading
    );
    _request.download(downloadPath);

    return _request;
  }

}