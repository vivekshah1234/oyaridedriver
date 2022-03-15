import 'dart:convert';

import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/ApiServices/networkcall.dart';
import 'package:oyaridedriver/Common/common_methods.dart';
import 'package:oyaridedriver/Models/driver_due_payment_model.dart';
import 'package:oyaridedriver/Models/payment_model.dart';
import 'package:oyaridedriver/UIScreens/payment_webview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverPaymentController extends GetxController {
  RxBool isLoading = false.obs;

  RxString payment = "0.0".obs;
  List<TripList> tripList = [];

  getPendingPayment() async {
    tripList.clear();
    isLoading(true);
    payment("0.0");
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
      getAPI(ApiConstant.duePayment, (value) {
   //     printInfo(info: value.response.toString());
        if (value.code == 200) {
          Map<String, dynamic> valueMap = json.decode(value.response);
          if (valueMap["status"] == 200) {
            DriverDuePaymentModel driverDuePaymentModel = DriverDuePaymentModel.fromJson(valueMap);
            if (driverDuePaymentModel.data.tripList.isNotEmpty) {
              payment(driverDuePaymentModel.data.finalAmount.toString());
              tripList.addAll(driverDuePaymentModel.data.tripList);
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

  makePayment({
    required Map<String, String> map,
    context,
  }) async {
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
      postAPIWithHeader(ApiConstant.payment, map, (value) async {
        if (value.code == 200) {
          Map<String, dynamic> valueMap = json.decode(value.response);
          if (valueMap["status"] == 200) {
            PaymentModel paymentModel = PaymentModel.fromJson(valueMap);
            isLoading(false);
            await Get.to(() => WebViewEx(
                  paymentModel.paymentData.data.authorizationUrl,
                  paymentModel.paymentData.data.reference,
                ));
            getPendingPayment();
          } else {
            isLoading(false);
            handleError(valueMap["message"].toString(), context);
          }
          // Get.to(() => WebViewEx(valueMap["data"]["authorization_url"]));
        } else {
          isLoading(false);
          handleError(value.response.toString(), context);
        }
      });
    }
  }
}
