import 'dart:convert';

import 'package:get/get.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/ApiServices/networkcall.dart';
import 'package:oyaridedriver/Common/common_methods.dart';
import 'package:oyaridedriver/Models/signup_modal.dart';
import 'package:oyaridedriver/UIScreens/licence_details_screens.dart';
import 'package:oyaridedriver/UIScreens/personal_info_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpController extends GetxController {
  RxBool isLoading = false.obs;

  register1(Map<String, dynamic> map, context) async {
    isLoading(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    postAPI(ApiConstant.signUp, map, (value) {
      if (value.code == 200) {
        Map<String, dynamic> valueMap = json.decode(value.response);
        if (valueMap["status"] == 200) {
          SignupModel signupModel = SignupModel.fromJson(valueMap);
          AppConstants.userID = signupModel.data[0].driverId.toString();

          prefs.setInt("registerFormNo", 1);
          prefs.setString("user_id", signupModel.data[0].driverId.toString());
          Get.offAll(() => const PersonalInfoScreen());
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

  register2(Map<String, dynamic> map, context) async {
    isLoading(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    putAPI(ApiConstant.registerPersonalInfo, map, (value) {
      if (value.code == 200) {
        Map<String, dynamic> valueMap = json.decode(value.response);
        if (valueMap["status"] == 200) {

          prefs.setInt("registerFormNo", 2);

          Get.offAll(() => const LicenceDetailScreen());
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

  register3(Map<String, dynamic> map, context) async {
    isLoading(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    putAPI(ApiConstant.driverLicenseNumber, map, (value) {
      if (value.code == 200) {
        Map<String, dynamic> valueMap = json.decode(value.response);
        if (valueMap["status"] == 200) {
          prefs.setInt("registerFormNo", 3);
          Get.offAll(() => const LicenceDocumentScreen());
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
