import 'dart:convert';

import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/ApiServices/networkcall.dart';
import 'package:oyaridedriver/Common/common_methods.dart';
import 'package:oyaridedriver/Models/vehicle_list_model.dart';
import 'package:oyaridedriver/Models/vehicle_type_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VehicleController extends GetxController {
  RxBool isLoading = false.obs;

  List<VehicleList> vehicleList = <VehicleList>[].obs;
  List<VehicleTypes> vehicleTypes = <VehicleTypes>[].obs;

  RxString selectedVehicleType = "selectedVehicleType".obs;
  RxInt activeVehicle = 0.obs;
  getVehicles() async {
    isLoading(true);
    activeVehicle(0);
    vehicleList.clear();
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
      getAPI(ApiConstant.getVehicle, (value) {
        printInfo(info: value.response.toString());
        if (value.code == 200) {
          Map<String, dynamic> valueMap = json.decode(value.response);
          if (valueMap["status"] == 200) {
            VehicleListModel vehicleListModel = VehicleListModel.fromJson(valueMap);
            vehicleList.addAll(vehicleListModel.data);
            if(vehicleList.isNotEmpty){
              for(int i=0;i<vehicleList.length;i++){
                if(vehicleList[i].isActiveVehicle==1){
                  printInfo(info: "active vehicle index=="+i.toString());
                  activeVehicle(i);
                }
              }
            }
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
  }

  changeActiveVehicle(Map<String, String> map, context) async {
    //  isLoading(true);
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
      postAPIWithHeader(ApiConstant.changeActiveVehicle, map, (value) {
        if (value.code == 200) {
          Map<String, dynamic> valueMap = json.decode(value.response);
          if (valueMap["status"] == 200) {
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
  }
}
