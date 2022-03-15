import 'dart:convert';

import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/ApiServices/networkcall.dart';
import 'package:oyaridedriver/Common/common_methods.dart';
import 'package:oyaridedriver/Models/total_earning_model.dart';
import 'package:oyaridedriver/Models/trip_history_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YourTripController extends GetxController {
  RxBool isLoading = false.obs;
  RxInt totalJob = 0.obs;
  RxString totalEarn = "0.0".obs;
  List<TripHistoryModel> historyTripList = <TripHistoryModel>[];
  RxBool isLoadingToday = false.obs;
  getTodayTripHistory(String date) async {
    isLoadingToday(true);
    historyTripList.clear();
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
      String url = ApiConstant.geTripHistory + "?date=$date";
      getAPI(url, (value) {
        printInfo(info: value.response.toString());
        if (value.code == 200) {
          Map<String, dynamic> valueMap = json.decode(value.response);
          if (valueMap["status"] == 200) {
            TripHistoryListModel yourTripHistoryListModel = TripHistoryListModel.fromJson(valueMap);

            historyTripList.addAll(yourTripHistoryListModel.data);

            isLoadingToday(false);
          } else {
            isLoadingToday(false);
            printError(info: valueMap["message"].toString());
          }
        } else {
          isLoadingToday(false);
          printError(info: value.response.toString());
        }
      });
    }
  }

  getTripHistory(String date) async {
    isLoading(true);
    historyTripList.clear();
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
      String url = ApiConstant.geTripHistory + "?date=$date";
      getAPI(url, (value) {
        printInfo(info: value.response.toString());
        if (value.code == 200) {
          Map<String, dynamic> valueMap = json.decode(value.response);
          if (valueMap["status"] == 200) {
            TripHistoryListModel yourTripHistoryListModel = TripHistoryListModel.fromJson(valueMap);

            historyTripList.addAll(yourTripHistoryListModel.data);

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

  getTotalEarnAndTotalJobs() async {
    isLoading(true);
    totalJob(0);
    totalEarn("0.0");
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
      getAPI(ApiConstant.getTotalEarn, (value) {
        if (value.code == 200) {
          Map<String, dynamic> valueMap = json.decode(value.response);
          if (valueMap["status"] == 200) {
            TotalEarningModel totalEarningModel = TotalEarningModel.fromJson(valueMap);
            totalJob(totalEarningModel.data.jobs);
            totalEarn(totalEarningModel.data.earning);
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
