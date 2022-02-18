import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:oyaridedriver/Common/allString.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/image_assets.dart';
import 'package:oyaridedriver/Models/acceptedDriverModel.dart';
import 'package:oyaridedriver/Models/calculateDistanceModel.dart';
import 'package:oyaridedriver/Models/request_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/ApiServices/networkcall.dart';
import 'package:oyaridedriver/Common/common_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_cards/swipe_cards.dart';

//when nothing type =0
//when requests arrive  type = 1
//when all request cancel type = 0
//when accept request type = 2
//when arrived location type = 3
//when pick up location type = 4
//when drop at location type = 5
//when payment done type = 6
//when rating done type=7

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  late IO.Socket _socket;

  final List<SwipeItem> swipeItems = <SwipeItem>[];
  late MatchEngine matchEngine;
  List<Map<String, dynamic>> dataList = [];
  RxBool isAddingData = false.obs;
  RxList<RequestModel> requestList = <RequestModel>[].obs;
  RxInt currentAppState = 0.obs;
  late AcceptedDriverModel acceptedDriverModel;

  Completer<GoogleMapController> mapController = Completer();
  late double latitude, longitude;
  late CameraPosition kGooglePlex;
  late CameraPosition kGooglePlex2;
  late LatLng lastMapPosition;
  late LatLng lastMapPositionPrivious;
  RxBool isLoadingMap = true.obs;
  Set<Marker> markers = {};
  Set<Polyline> polyLine = <Polyline>{};

  List<LatLng> polyLineCoordinates = <LatLng>[];
  late PolylinePoints polylinePoints;
  StreamSubscription<LocationData>? locationSubscription;

  Location locationTracker = Location();
  RxBool isAddingMarkerAndPolyline = false.obs;

  @override
  void onInit() {
    getCurrentPosition();
    polylinePoints = PolylinePoints();
    init(requestList);
    super.onInit();
  }

  getCurrentPosition() async {
    isLoadingMap(true);
    Position position = await determinePosition();
    latitude = position.latitude;
    longitude = position.longitude;
    lastMapPosition = LatLng(latitude, longitude);
    lastMapPositionPrivious = LatLng(latitude, longitude);
    kGooglePlex = CameraPosition(
      target: lastMapPosition,
      zoom: 14.4746,
    );
    kGooglePlex2 = CameraPosition(
      target: lastMapPositionPrivious,
      zoom: 14.4746,
    );
    Map<String, dynamic> map = {};
    locationSubscription = locationTracker.onLocationChanged.handleError((onError) {
      printInfo(info: "Error=====" + onError);
      locationSubscription?.cancel();

      locationSubscription = null;
    }).listen((newLocalData) async {
      map["latitude"] = newLocalData.latitude;
      map["longitude"] = newLocalData.longitude;
      map["userId"] = AppConstants.userID;
      updateLocation2(map);
    });
    addMyMarker(latitude, longitude, position.heading);
  }

  addMyMarker(double latitude, double longitude, double heading) async {
    Uint8List? imageData = await getBytesFromAsset(ImageAssets.driverCarIcon, 100);
    markers.add(Marker(
        markerId: MarkerId(MarkerPolylineId.myLocationMarker),
        position: LatLng(latitude, longitude),
        draggable: false,
        rotation: heading,
        zIndex: 2,
        flat: true,
        anchor: const Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(imageData!)));
    isLoadingMap(false);
  }

  void updateMarkerAndCircle(var newLocalData, Uint8List imageData) {
    LatLng latLng = LatLng(newLocalData.latitude!, newLocalData.longitude!);

    markers.add(Marker(
        markerId: MarkerId(MarkerPolylineId.myLocationMarker),
        position: latLng,
        rotation: newLocalData.heading!,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: const Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(imageData)));
  }

  RxBool cameraAnimate = false.obs;

  startLiveTracking(
      {required String id,
      required double sourceLatitude,
      required double sourceLongitude,
      required double destinationLatitude,
      required double destinationLongitude}) async {
    Map<String, dynamic> majoinRoomMap = {};
    majoinRoomMap["driver_id"] = id;
    printInfo(info: "Join room===" + majoinRoomMap.toString());
    double distance = 0.0;
    _socket.emit("joinRoom", majoinRoomMap);
    try {
      var location = await determinePosition();
      lastMapPosition = LatLng(location.latitude, location.longitude);
      Uint8List? imageData = await getBytesFromAsset(ImageAssets.driverCarIcon, 100);
      Map<String, dynamic> map = {};
      locationSubscription = locationTracker.onLocationChanged.handleError((onError) {
        printInfo(info: "Error=====" + onError);
        locationSubscription?.cancel();

        locationSubscription = null;
      }).listen((newLocalData) async {
        cameraAnimate(true);
        printInfo(
            info: "newLocalData====" + newLocalData.latitude.toString() + " ," + newLocalData.longitude.toString());
        map["latitude"] = newLocalData.latitude;
        map["longitude"] = newLocalData.longitude;
        map["heading"] = newLocalData.heading;
        map["driver_id"] = id;
        map["distance"] = distance.toString();
        _socket.emit('updateLocation', map);
        lastMapPositionPrivious = LatLng(newLocalData.latitude!, newLocalData.longitude!);
        lastMapPosition = LatLng(newLocalData.latitude!, newLocalData.longitude!);
        updateMarkerAndCircle(newLocalData, imageData!);
        cameraAnimate(false);
        // }
      });
      isLoadingDriver(false);
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
      isLoadingDriver(false);
    }
  }

  setPolyline(
      {required double sourceLatitude,
      required double sourceLongitude,
      required double destinationLatitude,
      required double destinationLongitude}) async {
    isAddingMarkerAndPolyline(true);
    polyLineCoordinates.clear();
    isAddingMarkerAndPolyline(false);
    isAddingMarkerAndPolyline(true);
    var result = await polylinePoints.getRouteBetweenCoordinates(ApiKeys.mapApiKey,
        PointLatLng(sourceLatitude, sourceLongitude), PointLatLng(destinationLatitude, destinationLongitude));
    printInfo(info: "result>>>-----    " + result.status.toString());
    if (result.points.isNotEmpty) {
      for (var pointLatLng in result.points) {
        polyLineCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }

      polyLine.add(Polyline(
          polylineId: PolylineId(MarkerPolylineId.sourceToDesPolyline),
          color: AllColors.blueColor,
          width: 4,
          points: polyLineCoordinates));
    }
    isAddingMarkerAndPolyline(false);
  }

  List<TaskModel> listofTasks = [];

  setPolylineMyLocToUserSourceLoc() async {
    isAddingMarkerAndPolyline(true);
    printInfo(info: "llllllllll================="+listofTasks.length.toString());
    for (int i = 0; i < listofTasks.length; i++) {
      Polyline polyline;
      if (listofTasks != null && listofTasks.isNotEmpty) {
        for (var one in listofTasks) {
          try {
            // List<LatLng> polylineCoordinates = [];
            // PolylinePoints polylinePoints = PolylinePoints();
            polyLineCoordinates.clear();
            var result = await polylinePoints.getRouteBetweenCoordinates(ApiKeys.mapApiKey,
                PointLatLng(one.slatitude, one.slongitude), PointLatLng(one.dlatitude, one.dlongitude));

            if (result.points.isNotEmpty) {
              for (var point in result.points) {
                polyLineCoordinates.add(LatLng(point.latitude, point.longitude));
              }
            }

            polyline = Polyline(
                polylineId: PolylineId("poly" + i.toString()),
                color: i == 0 ? AllColors.blueColor : AllColors.greenColor,
                width: 4,
                points: polyLineCoordinates);
            polyLine.add(polyline);
            isAddingMarkerAndPolyline(false);
          } catch (e) {
            print("Ex--- $e");
          }
        }
      }
    }
  }

  setMarker({required LatLng source, required LatLng destination}) async {
    // markers.clear();
    Uint8List? imageData = await getBytesFromAsset(ImageAssets.greenLocationPin, 100);
    markers.add(Marker(
        markerId: MarkerId(MarkerPolylineId.sourceMarker),
        position: source,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: const Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(imageData!)));
    markers.add(Marker(
        markerId: MarkerId(MarkerPolylineId.destinationMarker),
        position: destination,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: const Offset(0.5, 0.5),
        icon: BitmapDescriptor.defaultMarker));
  }

  getDistance(
      {required double sourceLatitude,
      required double sourceLongitude,
      required double destinationLatitude,
      required double destinationLongitude}) {
    String url =
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$sourceLatitude,$sourceLongitude&destinations=$destinationLatitude,$destinationLongitude&key=${ApiKeys.mapApiKey}";
    getAPIForMap(url, (value) {
      if (value.code == 200) {
        Map<String, dynamic> valueMap = json.decode(value.response);
        CalculateDistanceModel calculateDistanceModel = CalculateDistanceModel.fromJson(valueMap);
        printInfo(info: "Distance==" + calculateDistanceModel.rows[0].elements[0].duration.toString());
        return calculateDistanceModel.rows[0].elements[0].duration;
      }
      return 0.0;
    });
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
        printInfo(info: 'Socket Connected===');
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
    printInfo(info: "Socket Connected???===" + _socket.connected.toString());
    if (_socket.connected == false) {
      _socket.connect();
      _socket.on("connect", (_) {
        printInfo(info: 'Socket Re-Connected===' + _socket.connected.toString());
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
    printInfo(info: "getRequest===" + isAddingData.value.toString());
    try {
      _socket.emit(SocketEvents.getRequest, map);
      fetchRequests();
    } catch (Ex) {
      printError(info: "Socket Error" + Ex.toString());
    }
  }

  fetchRequests() {
    reconnectSocket();
    _socket.on(SocketEvents.sendRequest, (data) {
      printInfo(info: "getData===" + data.toString());
      Map<String, dynamic> valueMap = json.decode(data);
      RequestModel requestModel = RequestModel.fromJson(valueMap);
      requestList.add(requestModel);
      init(requestList);
      currentAppState(1);
      printInfo(info: "len===========" + requestList.length.toString());
      printInfo(info: "swipeItems===========" + swipeItems.isNotEmpty.toString());
      if (swipeItems.isNotEmpty) {
        printInfo(info: "inside===");
        isAddingData(false);
      }
      // return streamSocket.addResponse;
    });
  }

  acceptRequest(Map<String, dynamic> map) {
    printInfo(info: "accept===" + map.toString());

    isLoadingDriver(true);
    reconnectSocket();
    Map<String, String> statusChange = {};
    statusChange["is_available"] = "0";
    changeUserStatus(
      statusChange,
    );
    AppConstants.userOnline = false;
    try {
      _socket.emit(SocketEvents.acceptRequest, map);
      _socket.on(SocketEvents.sendAcceptReqResponse, (data) {
        printInfo(info: "getAcceptedData===" + data.toString());
        Map<String, dynamic> valueMap = json.decode(data);
        acceptedDriverModel = AcceptedDriverModel.fromJson(valueMap);
        currentAppState(2);

        double sourceLatitude = double.parse(acceptedDriverModel.tripData.sourceLatitude);
        double sourceLongitude = double.parse(acceptedDriverModel.tripData.sourceLongitude);
        double destinationLatitude = double.parse(acceptedDriverModel.tripData.destinationLatitude);
        double destinationLongitude = double.parse(acceptedDriverModel.tripData.destinationLongitude);
        getCurrentPosition();

        listofTasks = [
          TaskModel("1", "one", latitude, longitude, destinationLatitude, destinationLongitude),
          TaskModel("2", "two", sourceLatitude, sourceLongitude, destinationLatitude, destinationLongitude)
        ];

        setMarker(
            source: LatLng(sourceLatitude, sourceLongitude),
            destination: LatLng(destinationLatitude, destinationLongitude));
        printInfo(info: "len====" + listofTasks.length.toString());
      //  setPolylineMyLocToUserSourceLoc();
        setPolyline(  sourceLatitude: sourceLatitude,
            sourceLongitude: sourceLongitude,
            destinationLatitude: destinationLatitude,
            destinationLongitude: destinationLongitude);
        startLiveTracking(
            id: AppConstants.userID,
            sourceLatitude: sourceLatitude,
            sourceLongitude: sourceLongitude,
            destinationLatitude: destinationLatitude,
            destinationLongitude: destinationLongitude);
        // setPolylineMyLocToUserSourceLoc(
        //     sourceLatitude: sourceLatitude,
        //     sourceLongitude: sourceLongitude,
        //     destinationLatitude: destinationLatitude,
        //     destinationLongitude: destinationLongitude);
      });
    } catch (Ex) {
      printError(info: "Socket Error" + Ex.toString());
    }
  }

  RxBool isLoadingDriver = false.obs;

  reachedAtLoc(Map<String, dynamic> map) {
    isLoadingDriver(true);
    printInfo(info: "reached at loc===" + map.toString());
    reconnectSocket();
    try {
      _socket.emit(SocketEvents.reachedAtLocation, map);
      _socket.on(SocketEvents.sendReachedAtLocationResponse, (data) {
        printInfo(info: "getReachedData===" + data.toString());
        Map<String, dynamic> valueMap = json.decode(data);
        acceptedDriverModel = AcceptedDriverModel.fromJson(valueMap);
        currentAppState(3);
        isLoadingDriver(false);
      });
    } catch (Ex) {
      printError(info: "Socket Error" + Ex.toString());
    }
  }

  pickedUp(Map<String, dynamic> map) {
    isLoadingDriver(true);
    printInfo(info: "picked up ===" + map.toString());
    reconnectSocket();
    try {
      _socket.emit(SocketEvents.pickUpTheRider, map);
      _socket.emit(SocketEvents.startRide, map);
      _socket.on(SocketEvents.startRideDetails, (data) {
        printInfo(info: "startRideData===" + data.toString());
        Map<String, dynamic> valueMap = json.decode(data);
        acceptedDriverModel = AcceptedDriverModel.fromJson(valueMap);
        currentAppState(4);
        isLoadingDriver(false);
      });
    } catch (Ex) {
      printError(info: "Socket Error" + Ex.toString());
    }
  }

  dropAtLoc(Map<String, dynamic> map) {
    isLoadingDriver(true);
    printInfo(info: "dropped ====" + map.toString());
    reconnectSocket();
    try {
      _socket.emit(SocketEvents.completeRide, map);

      _socket.on(SocketEvents.sendCompleteRideResponse, (data) {
        printInfo(info: "dropRideData===" + data.toString());
        Map<String, dynamic> valueMap = json.decode(data);
        acceptedDriverModel = AcceptedDriverModel.fromJson(valueMap);
        currentAppState(5);
        isLoadingDriver(false);
      });
    } catch (Ex) {
      printError(info: "Socket Error" + Ex.toString());
    }
  }

  confirmPayment(Map<String, dynamic> map) {
    isLoadingDriver(true);
    printInfo(info: "dropped ===" + map.toString());
    reconnectSocket();
    try {
      _socket.emit(SocketEvents.paymentVerifyDriver, map);
      currentAppState(0);
    } catch (Ex) {
      printError(info: "Socket Error" + Ex.toString());
    }
  }

  //API Calling
  changeUserStatus(Map<String, String> map) async {
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
          //     handleError(value.error.toString(), context);
          printError(info: value.error.toString());
        }
      });
    }
  }

  init(List<RequestModel> requestList) {
    for (int i = 0; i < requestList.length; i++) {
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
            Map<String, dynamic> map = {"trip_id": requestList[i].id, "driver_id": AppConstants.userID};

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
    printInfo(info: "swipeItems===" + swipeItems.length.toString());
    matchEngine = MatchEngine(swipeItems: swipeItems);
  }

  allDataClear() {
    requestList.clear();
    swipeItems.clear();
    isAddingData(false);
  }
}

class TaskModel {
  String name;
  String address;
  double slatitude;
  double dlatitude;
  double slongitude;
  double dlongitude;

  TaskModel(this.name, this.address, this.slatitude, this.slongitude, this.dlatitude, this.dlongitude);
}
