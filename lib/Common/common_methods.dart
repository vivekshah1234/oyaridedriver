
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/ApiServices/networkcall.dart';
import 'package:oyaridedriver/Common/extension_widgets.dart';
import 'package:oyaridedriver/UIScreens/drawer_screen.dart';
import 'package:oyaridedriver/UIScreens/authScreens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'all_colors.dart';
import 'common_widgets.dart';

import 'package:get/get.dart';
double calculateHeight(double height,context) {
  print("Screen height===" + height.toString());
  double height2=0.0;
  if (height <= 650) {
    height2= MediaQuery.of(context).size.height*0.50;
  }else if(height > 650 && height <=700){
    height2= MediaQuery.of(context).size.height*0.45;
  }
  else if(height > 650 && height <=700){
    height2= MediaQuery.of(context).size.height*0.38;
  }else
    {
    height2= MediaQuery.of(context).size.height*0.35;
  }
  return height2;
}


bool isValidEmail(String email) {
  const _emailRegExpString = r'[a-zA-Z0-9\+\.\_\%\-\+]{1,256}\@[a-zA-Z0-9]'
      r'[a-zA-Z0-9\-]{0,64}(\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,25})+';
  return RegExp(_emailRegExpString, caseSensitive: false).hasMatch(email);
}

bool isValidPassword(String value) {
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}
//
// Future<Uint8List> getMarker2(context) async {
//   ByteData byteData = await DefaultAssetBundle.of(context)
//       .load(ImageAssets.driverCarIcon);
//   return byteData.buffer.asUint8List();
// }

Future<Uint8List?> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))?.buffer.asUint8List();
}


handleError(value, context) {
  showAnimatedDialog(
    context: context,barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      return textWidget(
          txt: value, fontSize: 14, color: AllColors.blueColor, bold: FontWeight.w600, italic: false)
          .alertCard(context);
    },
    animationType: DialogTransitionType.slideFromBottomFade,
    curve: Curves.fastOutSlowIn,
    duration:  const Duration(milliseconds: 500),
  );
}



Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

sendTokenToBackend(context) async {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  String? firebaseToken = await firebaseMessaging.getToken();
  Map<String, dynamic> map = {};
  if (Platform.isAndroid) {
    map["device_type"] = "1";
  } else if (Platform.isIOS) {
    map["device_type"] = "2";
  }
  map["device_token"] = firebaseToken;
  postAPIWithHeader(ApiConstant.addDeviceInfo, map, (value) {
    Map<String, dynamic> valueMap = json.decode(value.response);

    if (value.code == 200) {
      if (valueMap["status"] == 200) {
        // Get.to(() => TabBarScreen());
      } else {
        //  printError(info: valueMap["message"]);
      }
    } else {
      handleError(
          value.error == null ? valueMap["message"] : value.error.toString(),
          context);
    }
  });
}


Future<String> refreshTokenApi() async {
  Map<String, dynamic> param = {};
  param["token"] = AppConstants.userToken;
  String token = "userToken";

  var url = ApiConstant.baseUrl + ApiConstant.refreshToken;
  var uri = Uri.parse(url);
  print("==request== $uri");
  print("==Params== $param");
  try {
    var response = await http.post(uri, headers: null, body: param);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      print("==token response== ${response.body}");
      if (map["status"] == 200) {
        token = map["data"]["token"];
      } else {
        toast("Token is not refreshed");
      }
    } else {
      toast("Server Error please login in again.");
      AppConstants.userToken = "userToken";
      SharedPreferences sp = await SharedPreferences.getInstance();
      FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
      _firebaseMessaging.deleteToken();
      destroyData();
      sp.remove("token");
      sp.remove("userData");
      Get.offAll(() => const LoginScreen());
      return "";
    }
  } catch (ex) {
    print("Error==$ex");
  }
  //print("2===" + token.toString());
  return token;
}


