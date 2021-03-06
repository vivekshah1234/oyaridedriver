import 'dart:convert';

import 'package:get/get.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/ApiServices/networkcall.dart';
import 'package:oyaridedriver/Common/common_methods.dart';
import 'package:oyaridedriver/UIScreens/authScreens/recover_password_screen.dart';

class ForgotPasswordController extends GetxController {
  var isLoading = false.obs;

  sendEmail(String email, context) {
    isLoading(true);
    Map<String, dynamic> map = {};

    map["email"] = email;
    postAPI(ApiConstant.forgotPassword, map, (value) async {
      Map<String, dynamic> valueMap = json.decode(value.response);
      if (value.code == 200) {
        if (valueMap["status"] == 200) {
          isLoading(false);
          Get.to(() =>  RecoverPasswordScreen(
            email: email,
          ));
          // Get.offAll(() => TabBarScreen());
        } else {
          isLoading(false);
          printError(info: valueMap["message"]);
        }
      } else {
        isLoading(false);
        handleError(value.error == null ? valueMap["message"] : value.error.toString(), context);

        printError(info: value.error.toString());
      }
    });
  }
}
