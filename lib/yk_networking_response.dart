library yk_networking;

class YKNetworkingResponse {

  dynamic? data;

  Exception? exception;

  YKNetworkingResponse({this.data = null, this.exception = null});
}