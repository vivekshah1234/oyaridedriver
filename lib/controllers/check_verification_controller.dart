import 'dart:convert';

import 'package:get/get.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/ApiServices/networkcall.dart';
import 'package:oyaridedriver/Common/common_methods.dart';
import 'package:oyaridedriver/Models/login_modal.dart';
import 'package:oyaridedriver/Models/sign_up_model.dart';
import 'package:oyaridedriver/UIScreens/licence_details_screens.dart';
import 'package:oyaridedriver/UIScreens/mapScreens/map_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class CheckVerificationController extends GetxController {
  RxBool isLoading = false.obs;

  checkStatus(context) async {
    isLoading(true);
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? countryCode = sp.getString("countryCode");
    String? mobileNumber = sp.getString("mobileNumber");
    Map<String, String> map = {"country_code": countryCode!, "mobile_number": mobileNumber!};

    postAPI(ApiConstant.verifyDoc, map, (value) {
      printInfo(info: value.code.toString());
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
          printError(info: valueMap["data"].toString());
        }
      } else if (value.code == 501) {
        isLoading(false);
        printError(info: value.response.toString());
      } else if (value.code == 406) {
        printError(info: value.response.toString());
        sp.setInt("registerFormNo", 3);

        Get.offAll(() => const LicenceDocumentScreen());
        isLoading(false);
      } else {
        isLoading(false);
        printError(info: value.response.toString());
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
