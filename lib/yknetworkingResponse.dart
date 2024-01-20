library yknetworking;

class YKNetworkingResponse {

  dynamic? data;

  Exception? exception;

  YKNetworkingResponse({this.data, this.exception = null});
}