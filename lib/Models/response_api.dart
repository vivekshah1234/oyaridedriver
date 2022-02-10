class ResponseAPI {
  int code;
  String response;
  final dynamic isError;
  final dynamic isCacheError;
  dynamic error;

  ResponseAPI(this.code, this.response, {this.isError, this.isCacheError, this.error});
}
