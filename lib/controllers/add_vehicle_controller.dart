import 'dart:convert';

import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/ApiServices/networkcall.dart';
import 'package:oyaridedriver/Common/common_methods.dart';
import 'package:oyaridedriver/Models/vehicle_type_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNewVehicleController extends GetxController{
  RxBool isLoading = false.obs;


  List<VehicleTypes> vehicleTypes = <VehicleTypes>[].obs;

  RxString selectedVehicleType="selectedVehicleType".obs;

  getVehicleType() {
    vehicleTypes.clear();
    isLoading(true);
    getAPI(ApiConstant.vehicleTypes, (value) {
      if (value.code == 200) {
        Map<String, dynamic> valueMap = json.decode(value.response);
        if (valueMap["status"] == 200) {
          VehicleTypeModel vehicleTypeModel =
          VehicleTypeModel.fromJson(valueMap);
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

  addNewVehicle(Map<String, String> map, context) async {
    isLoading(true);
    // postAPIWithHeader(APiC, param, callback)
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
      postAPIWithHeader(ApiConstant.addVehicle, map, (value) {
        if (value.code == 200) {
          Map<String, dynamic> valueMap = json.decode(value.response);
          if (valueMap["status"] == 200) {
            isLoading(false);
            Get.back();
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