import 'dart:async';
import 'dart:convert';
import 'package:oyaridedriver/Models/request_model.dart';
import 'package:oyaridedriver/UIScreens/rider_list_cart_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/ApiServices/networkcall.dart';
import 'package:oyaridedriver/Common/common_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_cards/swipe_cards.dart';

// STEP1:  Stream setup
class StreamSocket {
  final _socketResponse = StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<dynamic> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  late IO.Socket _socket;
  StreamSocket streamSocket = StreamSocket();
  final List<SwipeItem> swipeItems = <SwipeItem>[];
  late MatchEngine matchEngine;
  List<Map<String, dynamic>> dataList = [];
  RxBool isAddingData = false.obs;
  RxList<RequestModel> requestList = <RequestModel>[].obs;

  RxInt currentAppState = 0.obs;

  @override
  void onInit() {
    init(requestList);
    super.onInit();
  }

  changeUserStatus(Map<String, String> map, context) async {
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

  connectToSocket() {
    try {
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
      });
    } catch (ex) {
      printError(info: "Socket Error" + ex.toString());
    }
  }

  updateLocation2(Map<String, dynamic> map) async {
    try {
      // printInfo(info: "Updated Location====" + map.toString());
      _socket.emit(SocketEvents.updateDriverLocation, map);
    } catch (Ex) {
      printError(info: "Socket Error" + Ex.toString());
    }
  }

  sendIdToSocket(Map<String, dynamic> map) async {
    isAddingData(true);

    printInfo(info: "getRequest==========" + isAddingData.value.toString());
    try {
      _socket.emit(SocketEvents.getRequest, map);
      getDataFromSocket();
    } catch (Ex) {
      printError(info: "Socket Error" + Ex.toString());
    }
  }

  getDataFromSocket() {
    _socket.on(SocketEvents.sendRequest, (data) {
      printInfo(info: "getData==========" + data.toString());
      Map<String, dynamic> valueMap = json.decode(data);
      RequestModel requestModel = RequestModel.fromJson(valueMap);
      requestList.add(requestModel);
      init(requestList);
      if (swipeItems.isNotEmpty) {
        printInfo(info: "inside===");
        isAddingData(false);
      }
      return streamSocket.addResponse;
    });
  }

  init(List<RequestModel> requestList) {
    for (int i = 0; i < requestList.length - 1; i++) {
      swipeItems.add(SwipeItem(
          content: Content(
              name: requestList[i].userName,
              imgurl: requestList[i].profilePic,
              charge: 50.0,
              kiloMeter: requestList[i].kilometer.toDouble(),
              pickUpPoint: requestList[i].sourceAddress,
              destinationPoint: requestList[i].destinationAddress),
          likeAction: () {
            printInfo(info: "like");
            // acceptRequest(i);
          },
          nopeAction: () {
            printInfo(info: "nope");
            printInfo(info: "i=====" + i.toString());
            printInfo(info: "swipeItems====" + swipeItems.length.toString());
            if (i == requestList.length - 1) {
              allDataClear();
            }
          },
          superlikeAction: () {
            printInfo(info: "super Like");
            if (i == requestList.length - 1) {
              allDataClear();
            }
          }));
    }
    printInfo(info: "swipeItems==========" + swipeItems.length.toString());
    matchEngine = MatchEngine(swipeItems: swipeItems);
  }

  acceptRequest(Map<String, dynamic> map) {
    try {
      _socket.emit(SocketEvents.acceptRequest, map);
    } catch (Ex) {
      printError(info: "Socket Error" + Ex.toString());
    }
  }

  allDataClear() {
    requestList.clear();
    swipeItems.clear();
    isAddingData(false);
  }
}
