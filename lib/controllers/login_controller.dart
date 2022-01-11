import 'dart:convert';

import 'package:get/get.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/ApiServices/networkcall.dart';
import 'package:oyaridedriver/Common/common_methods.dart';
import 'package:oyaridedriver/UIScreens/map_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController{

  RxBool isLoading=false.obs;


  login(Map<String, dynamic> map, context) async {
    isLoading(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    postAPI(ApiConstant.login, map, (value) {
      if (value.code == 200) {
        Map<String, dynamic> valueMap = json.decode(value.response);
        if (valueMap["status"] == 200) {
          // SignupModel signupModel = SignupModel.fromJson(valueMap);
          // AppConstants.userID = signupModel.data[0].driverId.toString();
          //
          // prefs.setInt("registerFormNo", 1);
          // prefs.setString("user_id", signupModel.data[0].driverId.toString());
          Get.offAll(() => const MapHomeScreen());
          isLoading(false);
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