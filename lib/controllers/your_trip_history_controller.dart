import 'dart:convert';

import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/ApiServices/networkcall.dart';
import 'package:oyaridedriver/Common/common_methods.dart';
import 'package:oyaridedriver/Models/YourTripHistoryModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YourTripController extends GetxController {
  RxBool isLoading = false.obs;

  List<HistoryTrip> historyTripList = <HistoryTrip>[];

  getTripHistory() async {
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
      getAPI(ApiConstant.geTripHistory, (value) {
        if (value.code == 200) {
          Map<String, dynamic> valueMap = json.decode(value.response);
          if (valueMap["status"] == 200) {
            YourTripHistoryModel yourTripHistoryModel = YourTripHistoryModel.fromJson(valueMap);

            printInfo(info: value.response.toString());
            historyTripList.addAll(yourTripHistoryModel.data);
            isLoading(false);
          } else {
            isLoading(false);
            printError(info: valueMap["message"].toString());
          }
        } else {
          isLoading(false);
          printError(info: value.response.toString());
        }
      });
    }
  }
}
