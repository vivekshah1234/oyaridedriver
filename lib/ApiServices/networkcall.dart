import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:oyaridedriver/Models/response_api.dart';

import 'api_constant.dart';

Map<String, String> getHeaders() {
  var header = <String, String>{};
  header["Authorization"] = 'Bearer ${AppConstants.userToken}';
  return header;
}

postAPI(String methodName, Map<String, dynamic> param, Function(ResponseAPI) callback) {
  var url = ApiConstant.baseUrl + methodName;
  var uri = Uri.parse(url);
  debugPrint("==request== $uri");
  debugPrint("==Params== $param");

  http.post(uri, headers: null, body: param).then((value) {
    debugPrint("==response== ${value.body}");
    _handleResponse(value, callback);
  }).onError((error, stackTrace) {
    debugPrint("onError== $error");
    _handleError(error, callback);
  }).catchError((error) {
    debugPrint("catchError== $error");
    _handleError(error, callback);
  });
}

postAPIWithHeader(String methodName, Map<String, dynamic> param, Function(ResponseAPI) callback) {
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

getAPI(String methodName, Function(ResponseAPI) callback) {
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
  // if (!value.toString().contains("errno = 111")) {
  //   callback.call(ResponseAPI(0, "No internet connection", isError: true, error: value.toString()));
  // } else {
  //   debugPrint("error::::::::::::::");
  //   callback.call(ResponseAPI(
  //     0,
  //     "Something went wrong",
  //     isError: true,
  //     error: value.toString(),
  //   ));
  //}
}

putAPI(String methodName, Map<String, dynamic> param, Function(ResponseAPI) callback) {
  var url = ApiConstant.baseUrl + methodName;
  var uri = Uri.parse(url);
  debugPrint("==request== $uri");
  debugPrint("==Params== $param");

  http.put(uri, headers: null, body: param).then((value) {
    debugPrint("==response== ${value.body}");
    _handleResponse(value, callback);
  }).onError((error, stackTrace) {
    debugPrint("onError== $error");
    _handleError(error, callback);
  }).catchError((error) {
    debugPrint("catchError== $error");
    _handleError(error, callback);
  });
}

multipartPostAPI(
    {required String methodName,
    required Map<String, String> param,
    required Function(ResponseAPI) callback,
    profilePic,
    licencePhoto}) async {
  var url = ApiConstant.baseUrl + methodName;
  var uri = Uri.parse(url);
  debugPrint("==request== $uri");
  debugPrint("==Params== $param");
  final imageUploadRequest = http.MultipartRequest('POST', uri);
  if (profilePic != null) {
    final file = await http.MultipartFile.fromPath('profile_pic', profilePic, filename: "profile_pic");
    final file2 = await http.MultipartFile.fromPath('licence_photo', licencePhoto, filename: "licence_photo");
    debugPrint("==profile_pic== $profilePic");
    imageUploadRequest.files.add(file);
    imageUploadRequest.files.add(file2);
  }
  imageUploadRequest.fields.addAll(param);
  try {
    final streamedResponse = await imageUploadRequest.send();
    await http.Response.fromStream(streamedResponse).then((value) {
      _handleResponse(value, callback);
    }).onError((error, stackTrace) {
      _handleError(error, callback);
    }).catchError((error) {
      debugPrint("catchError== $error");
      _handleError(error, callback);
    });
  } catch (e) {
    _handleError(e, callback);
    // return null;
  }
}

getAPIForMap(String methodName, Function(ResponseAPI) callback) {
  var uri = Uri.parse(methodName);
  http.get(uri,).then((value) {
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
