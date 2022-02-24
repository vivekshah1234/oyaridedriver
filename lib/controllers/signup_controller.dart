import 'dart:convert';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/ApiServices/networkcall.dart';
import 'package:oyaridedriver/Common/common_methods.dart';
import 'package:oyaridedriver/Models/login_modal.dart';
import 'package:oyaridedriver/Models/sign_up_model.dart';
import 'package:oyaridedriver/UIScreens/licence_details_screens.dart';
import 'package:oyaridedriver/UIScreens/authScreens/login_screen.dart';
import 'package:oyaridedriver/UIScreens/mapScreens/map_screen.dart';
import 'package:oyaridedriver/UIScreens/personal_info_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class SignUpController extends GetxController {
  RxBool isLoading = false.obs;

  register1(Map<String, String> map, context) async {
    isLoading(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    multipartPostAPI(
        profilePic: null,
        methodName: ApiConstant.signUp,
        param: map,
        callback: (value) {
          if (value.code == 200) {
            Map<String, dynamic> valueMap = json.decode(value.response);
            if (valueMap["status"] == 200) {
              // //SignUpModel signUpModel=SignUpModel.fromJson(valueMap);
              printInfo(info: valueMap["data"]["user"]["id"].toString());
              prefs.setString("user_id", valueMap["data"]["user"]["id"].toString());
              prefs.setInt("registerFormNo", 1);
              AppConstants.userID = valueMap["data"]["user"]["id"].toString();
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

  register2(Map<String, String> map, context) async {
    isLoading(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    multipartPostAPI(
        profilePic: null,
        methodName: ApiConstant.signUp,
        param: map,
        callback: (value) {
          if (value.code == 200) {
            Map<String, dynamic> valueMap = json.decode(value.response);
            if (valueMap["status"] == 200) {
              // //SignUpModel signUpModel=SignUpModel.fromJson(valueMap);

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

  register3(Map<String, String> map, context) async {
    isLoading(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    multipartPostAPI(
        profilePic: null,
        methodName: ApiConstant.signUp,
        param: map,
        callback: (value) {
          if (value.code == 200) {
            Map<String, dynamic> valueMap = json.decode(value.response);
            if (valueMap["status"] == 200) {
              // //SignUpModel signUpModel=SignUpModel.fromJson(valueMap);

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

  register4({required Map<String, String> map, context, required XFile profilePic, required XFile licencePhoto}) async {
    isLoading(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? pwd = prefs.getString("pwd");
    multipartPostAPI(
        profilePic: profilePic.path,
        licencePhoto: licencePhoto.path,
        methodName: ApiConstant.signUp,
        param: map,
        callback: (value) {
          if (value.code == 200) {
            Map<String, dynamic> valueMap = json.decode(value.response);
            if (valueMap["status"] == 200) {
              SignUpModel signUpModel = SignUpModel.fromJson(valueMap);

              prefs.setInt("registerFormNo", 4);
              //  Get.offAll(() => const LoginScreen());

              Map<String, String> _map = {
                "mobile_number": signUpModel.data.user.mobileNumber,
                "country_code": signUpModel.data.user.countryCode,
                "password": pwd!,
                "role": "driver"
              };
              login(_map, context);
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

  login(Map<String, dynamic> map, context) async {
    isLoading(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    postAPI(ApiConstant.login, map, (value) {
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
