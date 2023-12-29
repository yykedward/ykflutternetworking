


enum YKNetworkingMethod {
  get,
  post,
  put,
}



class YKNetworkingRequest {

  final String baseUrl;
  final String path;
  final String method;

  YKNetworkingRequest({this.baseUrl = "", this.path = "",this.method = "GET"});
}