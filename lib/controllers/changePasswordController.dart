import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/ApiServices/networkcall.dart';
import 'package:oyaridedriver/Common/common_methods.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordController extends GetxController {
  var isLoading = false.obs;

  changePassword(currentPwd, newPwd, context) async {
    isLoading(true);

    bool hasExpired = JwtDecoder.isExpired(AppConstants.userToken);
    print("expire token====" + hasExpired.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (hasExpired == true) {
      //refreshToken
      var token = await refreshTokenApi();
      AppConstants.userToken = token;
      prefs.setString("token", AppConstants.userToken);
    }
    if (AppConstants.userToken != "userToken") {
      Map<String, dynamic> map = {};

      map["current_password"] = currentPwd;
      map["password"] = newPwd;
      await postAPIWithHeader(ApiConstant.changePassword, map, (value) {
        Map<String, dynamic> valueMap = json.decode(value.response);
        if (value.code == 200) {
          if (valueMap["status"] == 200) {
            isLoading(false);
            toast(valueMap["message"].toString());
          } else {
            isLoading(false);
            handleError(value.error == null
                ? valueMap["message"]
                : value.error.toString(), context);


            printError(info: value.error.toString());
          }
        } else {
          //print("else 2");
          isLoading(false);
          handleError(value.error == null
              ? valueMap["message"]
              : value.error.toString(), context);
          printError(info: value.error.toString());
        }

      });
    }
  }
}
