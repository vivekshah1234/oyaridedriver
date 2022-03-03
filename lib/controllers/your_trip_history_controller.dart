import 'dart:convert';

import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/ApiServices/networkcall.dart';
import 'package:oyaridedriver/Common/common_methods.dart';
import 'package:oyaridedriver/Models/YourTripHistoryModel.dart';
import 'package:oyaridedriver/Models/trip_history_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YourTripController extends GetxController {
  RxBool isLoading = false.obs;
  RxInt totalJob = 0.obs;
  double totalEarn = 0.0;
  List<TripHistoryModel> historyTripList = <TripHistoryModel>[];

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
        if (value.code == 200) {
          Map<String, dynamic> valueMap = json.decode(value.response);
          if (valueMap["status"] == 200) {
            TripHistoryListModel yourTripHistoryListModel = TripHistoryListModel.fromJson(valueMap);

            historyTripList.addAll(yourTripHistoryListModel.data);
            // totalJob(historyTripList.length);
            // if(historyTripList.isNotEmpty){
            //   for(int i=0;i<historyTripList.length;i++){
            //     if(historyTripList[i].paymentStatus=="1"){
            //     totalEarn=totalEarn+double.parse(historyTripList[i].price);
            //     }
            //   }
            //  }
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
