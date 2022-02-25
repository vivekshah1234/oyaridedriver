import 'dart:convert';

import 'package:get/get.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/ApiServices/networkcall.dart';
import 'package:oyaridedriver/Common/common_methods.dart';
import 'package:oyaridedriver/Models/login_modal.dart';
import 'package:oyaridedriver/Models/sign_up_model.dart';
import 'package:oyaridedriver/Models/signup_modal.dart';
import 'package:oyaridedriver/UIScreens/mapScreens/map_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;

  login(Map<String, dynamic> map, context) async {
    isLoading(true);
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    postAPI(ApiConstant.login, map, (value) {
      printInfo(info: "code===="+value.code.toString());
      if (value.code == 200) {
        Map<String, dynamic> valueMap = json.decode(value.response);
        if (valueMap["status"] == 200) {
          LoginModel loginModel = LoginModel.fromJson(valueMap);
          AppConstants.userID = loginModel.data.user.id.toString();
          if (loginModel.data.user.isAvailable == 0) {
            AppConstants.userOnline = false;
          } else {
            AppConstants.userOnline = true;
          }
          saveTokenAndUserData(token: loginModel.data.token.toString(), user: loginModel.data.user, context: context);

          Get.offAll(() => const MapHomeScreen(
                isFromNotification: false,
              ));
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

  saveTokenAndUserData({required String token, required User user, context}) async {
    AppConstants.userToken = token;
    String jsonString = jsonEncode(user);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", AppConstants.userToken);
    prefs.setString("userData", jsonString);
    prefs.setBool("userOnline", true);
    setUserData(user);
    sendTokenToBackend(context);
  }
}
