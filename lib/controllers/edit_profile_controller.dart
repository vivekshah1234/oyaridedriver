import 'dart:convert';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/ApiServices/networkcall.dart';
import 'package:oyaridedriver/Common/common_methods.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Models/edit_profile_model.dart';
import 'package:oyaridedriver/Models/sign_up_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class EditProfileController extends GetxController {
  RxBool isLoading = false.obs;

  updateProfile(Map<String, String> map, context) async {
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
      multipartPostAPI(
          profilePic: null,
          methodName: ApiConstant.editProfile,
          param: map,
          callback: (value) {
            if (value.code == 200) {
              Map<String, dynamic> valueMap = json.decode(value.response);
              if (valueMap["status"] == 200) {
                // //SignUpModel signUpModel=SignUpModel.fromJson(valueMap);
                EditProfileModel editProfileModel = EditProfileModel.fromJson(valueMap);
                String jsonString = jsonEncode(editProfileModel.data);
                prefs.setString("userData", jsonString);
                setUserData(editProfileModel.data);
                toast("Profile updated.");
                Get.back();
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


  updateProfileWithImage({required Map<String, String> map, context, required XFile profilePic}) async {
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
      multipartPostAPI(
          profilePic: profilePic.path,
          methodName: ApiConstant.editProfile,
          param: map,
          callback: (value) {
            if (value.code == 200) {
              Map<String, dynamic> valueMap = json.decode(value.response);
              if (valueMap["status"] == 200) {
                // //SignUpModel signUpModel=SignUpModel.fromJson(valueMap);
                EditProfileModel editProfileModel = EditProfileModel.fromJson(valueMap);
                String jsonString = jsonEncode(editProfileModel.data);
                prefs.setString("userData", jsonString);
                setUserData(editProfileModel.data);
                toast("Profile updated.");
                Get.back();
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
}
