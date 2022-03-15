import 'dart:convert';

import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/ApiServices/networkcall.dart';
import 'package:oyaridedriver/Common/common_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebviewGetController extends GetxController {
  var isLoading = false.obs;

  verifyPayment(Map<String, String> map, context) async {
    isLoading(true);
    bool hasExpired = JwtDecoder.isExpired(AppConstants.userToken);
    printInfo(info: "expire token====" + hasExpired.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (hasExpired == true) {
      //refreshToken
      var token = await refreshTokenApi();
      AppConstants.userToken = token;
      prefs.setString("token", AppConstants.userToken);
    }
    if (AppConstants.userToken != "userToken") {
      postAPIWithHeader(ApiConstant.verifyTransaction, map, (value) {
        if (value.code == 200) {
          Map<String, dynamic> valueMap = json.decode(value.response);
          if (valueMap["status"] == 200) {
            isLoading(false);
            Get.back();
          }
          // Get.to(() => WebViewEx(valueMap["data"]["authorization_url"]));
        } else {
          handleError(value.response.toString(), context);
          isLoading(false);
        }
      });
    }
  }
}
