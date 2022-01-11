import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:oyaridedriver/Models/response_api.dart';


import 'api_constant.dart';

Map<String, String> getHeaders() {
  var header = <String, String>{};
  // header["language"] = "en";
  // header["device_type"] = "1.0.0";
  header["Authorization"] = 'Bearer ${AppConstants.userToken}';
  //print(AppConstants.userToken);
  // headers["device_id"] = await getDeviceId();

  return header;
}

postAPI(String methodName, Map<String, dynamic> param,
    Function(ResponseAPI) callback) {
  var url = ApiConstant.baseUrl + methodName;
  var uri = Uri.parse(url);
  debugPrint("==request== $uri");
  debugPrint("==Params== $param");

  http.post(uri, headers: null, body: param).then((value) {
    debugPrint("==response== ${value.body}");_handleResponse(value, callback);
  }).onError((error, stackTrace) {
    debugPrint("onError== $error");
    _handleError(error, callback);
  }).catchError((error) {
    debugPrint("catchError== $error");
    _handleError(error, callback);
  });
}

postAPIWithHeader(String methodName, Map<String, dynamic> param,
    Function(ResponseAPI) callback) {
  var url = ApiConstant.baseUrl + methodName;
  var uri = Uri.parse(url);
  debugPrint("==request2== $uri");
  debugPrint("==Params== $param");
  var headers = getHeaders();
  debugPrint(headers.toString());
  http.post(uri, headers: headers, body: param).then((value) {
    _handleResponse(value, callback);
  }).onError((error, stackTrace) {
    debugPrint("onError== $error");
    _handleError(error, callback);
  }).catchError((error) {
    debugPrint("catchError== $error");
    _handleError(error, callback);
  });
}

getAPI(String methodName,
    Function(ResponseAPI) callback) {
  var url = ApiConstant.baseUrl + methodName;

  var uri = Uri.parse(url);
  var headers = getHeaders();
  debugPrint(headers.toString());
  http.get(uri, headers: headers).then((value) {
    debugPrint("==request== $uri");
    _handleResponse(value, callback);
  }).onError((error, stackTrace) {
    debugPrint("onError== $error");
    _handleError(error, callback);
  }).catchError((error) {
    debugPrint("catchError== $error");
    _handleError(error, callback);
  });
}

_handleResponse(value, Function(ResponseAPI) callback) {
  debugPrint("==response== ${value.body}");
  callback.call(ResponseAPI(value.statusCode, value.body));
}

_handleError(value, Function(ResponseAPI) callback) {
  if (!value.toString().contains("errno = 111")) {
    callback.call(ResponseAPI(0, "No internet connection",
        isError: true, error: value.toString()));
  } else {
    debugPrint("error::::::::::::::");
    callback.call(ResponseAPI(
      0,
      "Something went wrong",
      isError: true,
      error: value.toString(),
    ));
  }
}

putAPI(String methodName, Map<String, dynamic> param,
    Function(ResponseAPI) callback) {
  var url = ApiConstant.baseUrl + methodName;
  var uri = Uri.parse(url);
  debugPrint("==request== $uri");
  debugPrint("==Params== $param");

  http.put(uri, headers: null, body: param).then((value) {
    debugPrint("==response== ${value.body}");_handleResponse(value, callback);
  }).onError((error, stackTrace) {
    debugPrint("onError== $error");
    _handleError(error, callback);
  }).catchError((error) {
    debugPrint("catchError== $error");
    _handleError(error, callback);
  });
}