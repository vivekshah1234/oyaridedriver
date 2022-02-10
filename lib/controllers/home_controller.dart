import 'dart:async';
import 'dart:convert';
import 'package:oyaridedriver/Models/request_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/ApiServices/networkcall.dart';
import 'package:oyaridedriver/Common/common_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_cards/swipe_cards.dart';


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

  //All Socket operations
  connectToSocket({required bool isFromNotification, userid}) {
    try {
      _socket = IO.io(SocketEvents.socketUrl, <String, dynamic>{
        'transports': ['websocket', 'polling'],
        'forceNew': true,
        'reconnecting': true,
        'timeout': 50000
      });
      _socket.connect();
      printInfo(info: _socket.connected.toString());
      _socket.on("connect", (_) {
        printInfo(info: 'Socket Connected================');
        if (isFromNotification == true) {
          Map<String, dynamic> map = {
            "user_id": userid,
          };
          sendIdToSocket(map);
        }
      });
      _socket.onError((data) {
        printError(info: "Socket Error" + data.toString());
      });
    } catch (ex) {
      printError(info: "Socket Error" + ex.toString());
    }
  }

  reconnectSocket() {
    if (!_socket.connected) {
      _socket.connect();
      _socket.on("connect", (_) {
        printInfo(
            info: 'Socket Re-Connected================' +
                _socket.connected.toString());
      });
    }
  }

  updateLocation2(Map<String, dynamic> map) async {
    reconnectSocket();
    try {
      _socket.emit(SocketEvents.updateDriverLocation, map);
    } catch (Ex) {
      printError(info: "Socket Error" + Ex.toString());
    }
  }

  sendIdToSocket(Map<String, dynamic> map) async {
    isAddingData(true);
    reconnectSocket();
    printInfo(info: "getRequest==========" + isAddingData.value.toString());
    try {
      _socket.emit(SocketEvents.getRequest, map);
      getDataFromSocket();
    } catch (Ex) {
      printError(info: "Socket Error" + Ex.toString());
    }
  }

  getDataFromSocket() {
    reconnectSocket();
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

  acceptRequest(Map<String, dynamic> map) {
    printInfo(info: "accept==============" + map.toString());
    reconnectSocket();
    try {
      _socket.emit(SocketEvents.acceptRequest, map);
      _socket.on(SocketEvents.sendAcceptReqResponse, (data) {
        printInfo(info: "getAcceptedData==========" + data.toString());
        Map<String, dynamic> valueMap = json.decode(data);
      });
    } catch (Ex) {
      printError(info: "Socket Error" + Ex.toString());
    }
  }

  //API Calling
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
            Map<String, dynamic> map = {
              "trip_id": requestList[i].id,
              "driver_id": AppConstants.userID
            };

            acceptRequest(map);
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

  allDataClear() {
    requestList.clear();
    swipeItems.clear();
    isAddingData(false);
  }
}
