import 'dart:convert';

import 'package:get/get.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/ApiServices/networkcall.dart';
import 'package:oyaridedriver/Common/common_methods.dart';
import 'package:oyaridedriver/UIScreens/change_password_screen.dart';
import 'package:oyaridedriver/UIScreens/recover_password_screen.dart';

class ForgetPasswordController extends GetxController{


  RxBool isLoading = false.obs;

  sendEmail(Map<String, String> map,context){
    postAPI(ApiConstant.forgetPassword, map, (value) {
      if (value.code == 200) {
        Map<String, dynamic> valueMap = json.decode(value.response);
        if (valueMap["status"] == 200) {

          isLoading(false);
          Get.to(()=>RecoverPasswordScreen());
        } else {
          isLoading(false);
          handleError(valueMap["status"].toString(), context);
        }
      } else {
        isLoading(false);
        handleError(value.response.toString(), context);
      }
    });
  }




}