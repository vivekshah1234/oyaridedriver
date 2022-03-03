import 'dart:convert';

import 'package:get/get.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/ApiServices/networkcall.dart';
import 'package:oyaridedriver/Common/common_methods.dart';
import 'package:oyaridedriver/UIScreens/authScreens/login_screen.dart';

class RecoverPasswordController extends GetxController {
  var isLoading = false.obs;

  changePassword(String code, String email, String newPWD, context) {
    isLoading(true);
    Map<String, dynamic> map = {};
    map["email"] = email;
    map["password"] = newPWD;
    map["token"] = code;
    postAPI(ApiConstant.resetPassword, map, (value) {
      Map<String, dynamic> valueMap = json.decode(value.response);

      if (value.code == 200) {
        if (valueMap["status"] == 200) {
          isLoading(false);
          Get.offAll(() => const LoginScreen());
        } else {
          isLoading(false);
          printError(info: valueMap["message"].toString());
        }
      } else {
        isLoading(false);

        handleError(value.error == null ? valueMap["message"].toString() : value.error.toString(), context);

        printError(info: value.error.toString());
      }
    });
  }
}
