class ResponseAPI {
  int code;
  String response;
  final isError;
   final isCacheError;
  dynamic error;

  ResponseAPI(this.code, this.response,
      {this.isError, this.isCacheError, this.error});
}
