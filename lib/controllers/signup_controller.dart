import 'dart:convert';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/ApiServices/networkcall.dart';
import 'package:oyaridedriver/Common/common_methods.dart';
import 'package:oyaridedriver/Models/login_modal.dart';
import 'package:oyaridedriver/Models/sign_up_model.dart';
import 'package:oyaridedriver/Models/vehicle_type_model.dart';
import 'package:oyaridedriver/UIScreens/document_sent_screen.dart';
import 'package:oyaridedriver/UIScreens/licence_details_screens.dart';
import 'package:oyaridedriver/UIScreens/authScreens/login_screen.dart';
import 'package:oyaridedriver/UIScreens/mapScreens/map_screen.dart';
import 'package:oyaridedriver/UIScreens/personal_info_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class SignUpController extends GetxController {
  RxBool isLoading = false.obs;
  List<VehicleTypes> vehicleTypes = <VehicleTypes>[].obs;

  RxString selectedVehicleType = "selectedVehicleType".obs;

  getVehicleType() {
    vehicleTypes.clear();
    isLoading(true);
    getAPI(ApiConstant.vehicleTypes, (value) {
      if (value.code == 200) {
        Map<String, dynamic> valueMap = json.decode(value.response);
        if (valueMap["status"] == 200) {
          VehicleTypeModel vehicleTypeModel = VehicleTypeModel.fromJson(valueMap);
          vehicleTypes.addAll(vehicleTypeModel.data);
          selectedVehicleType(vehicleTypes[0].name);
          isLoading(false);
        } else {
          isLoading(false);
          printError(
            info: valueMap["status"].toString(),
          );
        }
      } else {
        isLoading(false);
        printError(
          info: value.response.toString(),
        );
      }
    });
  }
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
              prefs.setString("countryCode",  signUpModel.data.user.countryCode);
              prefs.setString("mobileNumber",   signUpModel.data.user.mobileNumber);
              prefs.setInt("registerFormNo", 4);

              saveTokenAndUserData(
                  token: signUpModel.data.token,
                  context: context);

              isLoading(false);
               Get.offAll(() => const DocumentSentScreen());


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
  saveTokenAndUserData({required String token,  context}) async {
    AppConstants.userToken = token;
   // String jsonString = jsonEncode(user);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", AppConstants.userToken);
  //setUserData(user);
    sendTokenToBackend(context);
  }
}
