import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/ApiServices/networkcall.dart';
import 'package:oyaridedriver/Common/common_methods.dart';
import 'package:oyaridedriver/Common/image_assets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  late IO.Socket _socket;
  getRequest() {}

  changeUserStatus(Map<String, String> map, context) async {
    isLoading(true);
    // postAPIWithHeader(APiC, param, callback)
    bool hasExpired = JwtDecoder.isExpired(AppConstants.userToken);
    print("expire token====" + hasExpired.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (hasExpired == true) {
      //refreshToken
      var token = await refreshTokenApi();
      AppConstants.userToken = token;
      prefs.setString("token", AppConstants.userToken);
    }
    if (AppConstants.userToken != "userToken") {
      postAPIWithHeader(ApiConstant.userStatus, map, (value) {
        if (value.code == 200) {
          Map<String, dynamic> valueMap = json.decode(value.response);
          if (valueMap["status"] == 200) {
            if (map["is_available"] == "1") {
              AppConstants.userOnline = true;
              prefs.setBool("userOnline", true);
            } else {
              AppConstants.userOnline = false;
              prefs.setBool("userOnline", false);
            }
            isLoading(false);
          } else {
            isLoading(false);
            printError(info: valueMap["message"]);
          }
        } else {
          isLoading(false);

          handleError(value.error.toString(), context);

          printError(info: value.error.toString());
        }
      });
    }
  }




  connectToSocket(){
//    printInfo(info: "inside=================");
    try{
    _socket = IO.io('http://3.13.6.132:3900', <String, dynamic>{
      'transports': ['websocket', 'polling'],
      'forceNew': true,
      'reconnecting': true,
      'timeout': 50000
    });
    _socket.connect();
    printInfo(info: _socket.connected.toString());
    _socket.on("connect", (_) {
      printInfo(info: _socket.connected.toString());
      printInfo(info: 'Socket Connected================');
      // Map<String, dynamic> map = {};
      // map["shipper_order_id"] = widget.courierData.id.toString();
      // printInfo(info: "a====${widget.courierData.id}");
      // _socket.emit("updateDriverLocation", map);
    });

    }catch(Ex){
      printError(info:"Socket Error"+ Ex.toString());
    }
  }


  updateLocation2(Map<String, dynamic> map) async{
    try{
      printInfo(info: "Updated Location===="+map.toString());
      _socket.emit('updateDriverLocation', map);

    }catch(Ex){
      printError(info:"Socket Error"+ Ex.toString());
    }

  }
}
