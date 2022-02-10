import 'dart:async';
import 'dart:typed_data';

import 'package:badges/badges.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:fcm_config/fcm_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as poly_util;
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_methods.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/extension_widgets.dart';
import 'package:oyaridedriver/Common/image_assets.dart';
import 'package:oyaridedriver/UIScreens/drawer_screen.dart';
import 'package:oyaridedriver/UIScreens/rider_details_screen.dart';
import 'package:oyaridedriver/controllers/home_controller.dart';
import 'package:sized_context/src/extensions.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import '../../main.dart';
import '../cancel_ride_reason_dialog.dart';
// ignore_for_file: prefer_const_constructors

class MapHomeScreen extends StatefulWidget {
  final bool isFromNotification;
  final dynamic userId;

  MapHomeScreen({required this.isFromNotification, this.userId});

  @override
  _MapHomeScreenState createState() => _MapHomeScreenState();
}

class _MapHomeScreenState extends State<MapHomeScreen>
    with FCMNotificationMixin, FCMNotificationClickMixin, WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Completer<GoogleMapController> _mapController = Completer();
  late double latitude, longitude;
  late CameraPosition _kGooglePlex;
  late LatLng _lastMapPosition;
  bool isOnline = false;
  bool isLoading = true;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLine = <Polyline>{};
  List<LatLng> polyLineCoordinates = [];
  late PolylinePoints polylinePoints;
  int status = -1;
  HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    printInfo(info: "notificationFrom=========" + widget.isFromNotification.toString());
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    getCurrentPosition();
    homeController.connectToSocket(isFromNotification: widget.isFromNotification, userid: widget.userId);
  }

  getCurrentPosition() async {
    Position position = await determinePosition();
    latitude = position.latitude;
    longitude = position.longitude;
    _lastMapPosition = LatLng(latitude, longitude);
    _kGooglePlex = CameraPosition(
      target: _lastMapPosition,
      zoom: 14.4746,
    );
    Map<String, dynamic> map = {};
    _locationSubscription = _locationTracker.onLocationChanged.handleError((onError) {
      printInfo(info: "Error=====" + onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((newLocalData) async {
      map["latitude"] = newLocalData.latitude;
      map["longitude"] = newLocalData.longitude;
      map["userId"] = AppConstants.userID;
      homeController.updateLocation2(map);
    });
    addMyMarker(latitude, longitude);
    isLoading = false;
    setState(() {});
  }

  addMyMarker(latitude, longitude) async {
    Uint8List? imageData = await getBytesFromAsset(ImageAssets.driverCarIcon, 100);
    _markers.add(Marker(
        markerId: MarkerId("myLocation"),
        position: LatLng(latitude, longitude),
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(imageData!)));
    setState(() {});
  }

  @override
  void onNotify(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    var notificationType = message.data["notificationType"];
    showNotification(
        1234, notification!.title.toString(), notification.body.toString(), "GET PAYLOAD FROM message userECT");
    if (notificationType == "1") {
      printInfo(info: "notifying1=========" + message.data.toString());
      Map<String, String> map = {
        "user_id": message.data["userId"],
      };
      homeController.sendIdToSocket(map);
    }
    // homeController.addData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
        init: HomeController(),
        builder: (controller) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Scaffold(
                  key: _scaffoldKey,
                  extendBodyBehindAppBar: true,
                  drawer: DrawerScreen(),
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: FloatingActionButton(
                        onPressed: () {
                          _scaffoldKey.currentState!.openDrawer();
                        },
                        backgroundColor: AllColors.whiteColor,
                        child: const Icon(
                          Icons.sort,
                          color: AllColors.blackColor,
                        ),
                      ),
                    ),
                    actions: [
                      GestureDetector(
                        onTap: () {
                          notificationCounterValueNotifier.value = 0;
                          setState(() {});
                        },
                        child: ValueListenableBuilder(
                          builder: (BuildContext context, int newNotificationCounterValue, Widget? child) {
                            return Badge(
                              badgeColor: AllColors.greenColor,
                              toAnimate: true,
                              badgeContent: Padding(padding: const EdgeInsets.only(top: 30.0), child: Container()),
                              showBadge: newNotificationCounterValue == 0 ? false : true,
                              //  showBadge: true,
                              child: CircleAvatar(
                                backgroundColor: AllColors.whiteColor,
                                child: const Icon(
                                  Icons.notifications_none_sharp,
                                  size: 30,
                                  color: AllColors.blackColor,
                                ),
                              ),
                            );
                          },
                          valueListenable: notificationCounterValueNotifier,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      !AppConstants.userOnline
                          ? GestureDetector(
                              onTap: () {
                                Map<String, String> map = {};
                                map["is_available"] = "1";
                                homeController.changeUserStatus(map, context);
                              },
                              child: Container(
                                decoration:
                                    BoxDecoration(color: AllColors.blackColor, borderRadius: BorderRadius.circular(13)),
                                margin: const EdgeInsets.only(top: 15, bottom: 15),
                                padding: const EdgeInsets.only(left: 5, right: 5),
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      backgroundColor: AllColors.whiteColor,
                                      radius: 7,
                                    ),
                                    const SizedBox(
                                      width: 7,
                                    ),
                                    textWidget(
                                        txt: " Go online ",
                                        fontSize: 11,
                                        color: AllColors.whiteColor,
                                        italic: false,
                                        bold: FontWeight.w600)
                                  ],
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                Map<String, String> map = {};
                                map["is_available"] = "0";
                                homeController.changeUserStatus(map, context);
                              },
                              child: Container(
                                decoration:
                                    BoxDecoration(color: AllColors.blackColor, borderRadius: BorderRadius.circular(13)),
                                margin: const EdgeInsets.only(top: 15, bottom: 15),
                                padding: const EdgeInsets.only(left: 5, right: 5),
                                child: Row(
                                  children: [
                                    textWidget(
                                        txt: " Go offline",
                                        fontSize: 11,
                                        color: AllColors.whiteColor,
                                        italic: false,
                                        bold: FontWeight.w600),
                                    const SizedBox(
                                      width: 7,
                                    ),
                                    CircleAvatar(
                                      backgroundColor: AllColors.greenColor,
                                      radius: 7,
                                    ),
                                    const SizedBox(
                                      width: 7,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      const SizedBox(
                        width: 20,
                      )
                    ],
                  ),
                  body: Stack(
                    children: [
                      isLoading
                          ? SizedBox(
                              height: double.infinity,
                              width: double.infinity,
                              child: greenLoadingWidget(),
                            )
                          : GoogleMap(
                              mapType: MapType.terrain,
                              initialCameraPosition: _kGooglePlex,
                              onMapCreated: (GoogleMapController controller) {
                                _mapController.complete(controller);
                              },
                              markers: _markers,
                              polylines: _polyLine,
                            ),
                      Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: controller.isAddingData.value
                              ? FetchingTheRequests()
                              : controller.swipeItems.isEmpty
                                  ? NoRequestCart()
                                  : Container(
                                      child: status == -1
                                          ? SizedBox(
                                              height: calculateHeight(MediaQuery.of(context).size.height, context),
                                              child: SwipeCards(
                                                matchEngine: controller.matchEngine,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return GestureDetector(
                                                      onTap: () {
                                                        Get.to(() => RiderDetailScreen(controller.requestList[index]));
                                                      },
                                                      child: RiderRequest(
                                                        name: controller.requestList[index].userName,
                                                        imgUrl: controller.requestList[index].profilePic,
                                                        km: controller.requestList[index].kilometer.toDouble(),
                                                        price: 50.0,
                                                        pickUpPoint: controller.requestList[index].sourceAddress,
                                                        dropOffPoint: controller.requestList[index].destinationAddress,
                                                        acceptOnTap: () {
                                                          controller.matchEngine.currentItem?.like();
                                                          acceptRequest(index);
                                                          Map<String, dynamic> map = {
                                                            "trip_id": controller.requestList[index].id,
                                                            "driver_id": AppConstants.userID
                                                          };
                                                          homeController.acceptRequest(map);
                                                          setState(() {});
                                                        },
                                                        ignoreOnTap: () {
                                                          controller.matchEngine.currentItem?.nope();
                                                          printInfo(info: "nope2");
                                                          printInfo(info: "i=====" + index.toString());
                                                          printInfo(
                                                              info: "swipeItems====" +
                                                                  controller.swipeItems.length.toString());
                                                          if (index == controller.requestList.length - 1) {
                                                            controller.allDataClear();
                                                          }
                                                          setState(() {});
                                                        },
                                                      ));
                                                },
                                                onStackFinished: () {
                                                  polyLineCoordinates.clear();
                                                  _polyLine.clear();
                                                  _markers.clear();

                                                  setState(() {});
                                                },
                                              ),
                                            )
                                          : Container(
                                              width: MediaQuery.of(context).size.width,
                                              decoration: BoxDecoration(
                                                color: AllColors.whiteColor,
                                                borderRadius: const BorderRadius.only(
                                                  topRight: Radius.circular(40),
                                                  topLeft: Radius.circular(40),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.5),
                                                    spreadRadius: 5,
                                                    blurRadius: 7,
                                                    offset: const Offset(0, 3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                children: [
                                                  locationDetails(),
                                                  status < 2
                                                      ? RiderDetails(
                                                          name: "Stella Josh",
                                                          callButton: () {
                                                            url_launcher.launch("tel://21213123123");
                                                          },
                                                        )
                                                      : status == 2
                                                          ? whileTravelingCart()
                                                          : userCart3(),
                                                  status < 2
                                                      ? Row(
                                                          children: [
                                                            SmallButton(
                                                              text: "CANCEL",
                                                              color: AllColors.blueColor,
                                                              onPressed: () {
                                                                cancelRide();
                                                                _locationSubscription?.cancel();
                                                                // _locationTracker.
                                                                setState(() {
                                                                  _locationSubscription = null;
                                                                });
                                                              },
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            if (status < 1)
                                                              SmallButton(
                                                                text: "ARRIVED",
                                                                color: AllColors.greenColor,
                                                                onPressed: () {
                                                                  status = 1;

                                                                  setState(() {});
                                                                },
                                                              )
                                                            else if (status == 1)
                                                              SmallButton(
                                                                text: "PICKED UP",
                                                                color: AllColors.greenColor,
                                                                onPressed: () {
                                                                  status = 2;

                                                                  setState(() {});
                                                                },
                                                              )
                                                            else if (status == 2)
                                                              Container()
                                                            // Expanded(child: greenButton(txt: "ACCEPT",function: (){})),
                                                          ],
                                                        ).putPadding(
                                                          0,
                                                          20,
                                                          context.widthPct(0.08),
                                                          context.widthPct(0.08),
                                                        )
                                                      : status == 2
                                                          ? AppButton(
                                                                  text: "TAP WHEN DROP",
                                                                  onPressed: () {
                                                                    status = 3;
                                                                    print("tap");
                                                                    setState(() {});
                                                                  },
                                                                  color: AllColors.greenColor)
                                                              .paddingSymmetric(horizontal: 15)
                                                          : AppButton(
                                                                  text: "CONFIRM PAYMENT",
                                                                  onPressed: () {
                                                                    status = 4;
                                                                    setState(() {});
                                                                  },
                                                                  color: AllColors.greenColor)
                                                              .paddingSymmetric(horizontal: 15),
                                                ],
                                              ),
                                            ),
                                    ))
                    ],
                  )),
              Visibility(visible: controller.isLoading.value, child: greenLoadingWidget())
            ],
          );
        });
  }

  acceptRequest(i) {
    status = 0;
    startLiveTracking();
    setState(() {});
  }

  cancelRide() {
    showAnimatedDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return const CancelRide().alertCard(context);
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
    );
  }

  setPolyline(route) async {
    polyLineCoordinates.clear();
    _polyLine.clear();
    var points = poly_util.PolygonUtil.decode(route);
    for (var pointLatLng in points) {
      polyLineCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
    }

    _polyLine.add(
        Polyline(polylineId: PolylineId("poly"), color: AllColors.blueColor, width: 4, points: polyLineCoordinates));
    setState(() {});
  }

  setMarker({required LatLng source, required LatLng destination}) async {
    _markers.clear();
    Uint8List? imageData = await getBytesFromAsset(ImageAssets.greenLocationPin, 100);
    _markers.add(Marker(
        markerId: MarkerId("markerSource"),
        position: source,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(imageData!)));
    _markers.add(Marker(
        markerId: MarkerId("markerDestination"),
        position: destination,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.defaultMarker));

    setState(() {});
  }

  void updateMarkerAndCircle(var newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude!, newLocalData.longitude!);
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading!,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData)));
    });
  }

  StreamSubscription<LocationData>? _locationSubscription;

  final Location _locationTracker = Location();

  startLiveTracking() async {
    try {
      var location = await determinePosition();
      _lastMapPosition = LatLng(location.latitude, location.longitude);
      Uint8List? imageData = await getBytesFromAsset(ImageAssets.driverCarIcon, 100);

      _locationSubscription = _locationTracker.onLocationChanged.handleError((onError) {
        printInfo(info: "Error=====" + onError);
        _locationSubscription?.cancel();
        setState(() {
          _locationSubscription = null;
        });
      }).listen((newLocalData) async {
        if (_mapController != null) {
          final GoogleMapController controller = await _mapController.future;
          _lastMapPosition = LatLng(newLocalData.latitude!, newLocalData.longitude!);
          controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(bearing: 192.833, target: _lastMapPosition, tilt: 0, zoom: 12)));

          updateMarkerAndCircle(newLocalData, imageData!);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  Widget locationDetails() {
    return Container(
      decoration: const BoxDecoration(
        color: AllColors.blackColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          topLeft: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.only(top: 15, bottom: 10, left: 20, right: 20),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: status == 0 ? AllColors.whiteColor : AllColors.greenColor,
            child: const Icon(
              Icons.location_on,
              color: AllColors.blackColor,
            ),
          ),
          Expanded(child: dottedLine()),
          CircleAvatar(
            backgroundColor: status <= 1 ? AllColors.whiteColor : AllColors.greenColor,
            child: const Icon(
              Icons.directions_car,
              color: AllColors.blackColor,
            ),
          ),
          Expanded(child: dottedLine2()),
          CircleAvatar(
            backgroundColor: status <= 2 ? AllColors.whiteColor : AllColors.greenColor,
            child: const Icon(
              Icons.flag_sharp,
              color: AllColors.blackColor,
            ),
          )
        ],
      ),
    );
  }

  Widget dottedLine() {
    return DottedLine(
      direction: Axis.horizontal,
      lineLength: double.infinity,
      lineThickness: 2.0,
      dashLength: 4.0,
      dashColor: status <= 1 ? AllColors.whiteColor : AllColors.greenColor,
      // dashGradient: const [Colors.red, Colors.blue],
      dashRadius: 0.0,
      dashGapLength: 4.0,
      dashGapColor: Colors.transparent,
      //  dashGapGradient: const [Colors.red, Colors.blue],
      dashGapRadius: 0.0,
    );
  }

  Widget dottedLine2() {
    return DottedLine(
      direction: Axis.horizontal,
      lineLength: double.infinity,
      lineThickness: 2.0,
      dashLength: 4.0,
      dashColor: status <= 2 ? AllColors.whiteColor : AllColors.greenColor,
      // dashGradient: const [Colors.red, Colors.blue],
      dashRadius: 0.0,
      dashGapLength: 4.0,
      dashGapColor: Colors.transparent,
      //  dashGapGradient: const [Colors.red, Colors.blue],
      dashGapRadius: 0.0,
    );
  }

  Widget whileTravelingCart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //  crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 2,
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            shadowColor: Colors.grey.shade900,
            child: Column(
              children: [
                const CircleAvatar(
                  backgroundImage:
                      NetworkImage("https://i.pinimg.com/564x/04/e1/78/04e1784fc85d72ccec586ca224ce361a.jpg"),
                  radius: 35,
                ).putPadding(10, 10, 25, 25),
                // SizedBox(height: 10,),
                textWidget(
                    txt: "Stella Josan",
                    bold: FontWeight.w600,
                    fontSize: 18,
                    italic: false,
                    color: AllColors.blackColor),
                const SizedBox(
                  height: 10,
                ),
                GiveRatingWidget(initialRating: 3, onRatingUpdate: (val) {})
              ],
            ).putPadding(20, 20, 20, 20),
          ),
        ),
        Expanded(
          flex: 2,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.30,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              shadowColor: Colors.grey.shade900,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textWidget(
                      txt: "Waiting", bold: FontWeight.w500, fontSize: 18, italic: false, color: AllColors.blackColor),
                  const SizedBox(
                    height: 10,
                  ),
                  textWidget(
                      txt: "00:00:00", bold: FontWeight.w500, fontSize: 18, italic: false, color: AllColors.blackColor),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget userCart3() {
    return Column(
      children: [
        Container(
          color: Colors.grey.shade50,
          padding: const EdgeInsets.only(left: 7, right: 7, top: 7, bottom: 7),
          margin: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(imgUrl),
                    radius: 35,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  textWidget(
                      txt: "Stella Josan",
                      bold: FontWeight.w800,
                      fontSize: 18,
                      italic: false,
                      color: AllColors.blackColor),
                ],
              ),
              Column(
                children: [
                  textWidget(
                      txt: "\$50", fontSize: 17, color: AllColors.blackColor, bold: FontWeight.w800, italic: false),
                  textWidget(
                      txt: "15 km", fontSize: 15, color: AllColors.greyColor, bold: FontWeight.normal, italic: false),
                ],
              )
            ],
          ),
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textWidget(
                    txt: "Booking ID", fontSize: 18, color: AllColors.blackColor, bold: FontWeight.w300, italic: false),
                textWidget(
                    txt: "#TXN67876", fontSize: 18, color: AllColors.blackColor, bold: FontWeight.w300, italic: false)
              ],
            ).putPadding(0, 0, 10, 10),
            const SizedBox(
              height: 12,
            ),
            const Divider(
              height: 2,
              color: AllColors.greyColor,
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textWidget(
                    txt: "Total", fontSize: 18, color: AllColors.blackColor, bold: FontWeight.w300, italic: false),
                textWidget(txt: "\$50", fontSize: 18, color: AllColors.blackColor, bold: FontWeight.w300, italic: false)
              ],
            ).putPadding(0, 0, 10, 10),
            const SizedBox(
              height: 12,
            ),
            const Divider(
              height: 2,
              color: AllColors.greyColor,
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textWidget(
                    txt: "Payment", fontSize: 18, color: AllColors.blackColor, bold: FontWeight.w300, italic: false),
                textWidget(txt: "Cash", fontSize: 18, color: AllColors.blackColor, bold: FontWeight.w300, italic: false)
              ],
            ).putPadding(0, 0, 10, 10),
            const SizedBox(
              height: 12,
            ),
            const Divider(
              height: 2,
              color: AllColors.greyColor,
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ).putPadding(10, 10, 10, 10),
      ],
    );
  }

  @override
  void onClick(RemoteMessage notification) {
    // TODO: implement onClick
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //do your stuff
      homeController.connectToSocket(isFromNotification: false);
    }
  }
}

class NoRequestCart extends StatelessWidget {
  const NoRequestCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: AllColors.whiteColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(40),
          topLeft: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      padding: EdgeInsets.only(top: 7, bottom: 20),
      child: Column(
        children: [
          Container(
            height: 4,
            width: MediaQuery.of(context).size.width * 0.35,
            margin: EdgeInsets.only(top: 5, bottom: 15),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          Text(
            "Welcome, ${AppConstants.fullName}",
            style: TextStyle(fontSize: 20, color: AllColors.blueColor, fontWeight: FontWeight.bold),
          ).paddingOnly(top: 0, bottom: 15),
          Container(
            height: 1.5,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey.shade300,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Currently,You don't have any request.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: AllColors.blueColor, fontWeight: FontWeight.w300),
          )
        ],
      ),
    );
  }
}

class FetchingTheRequests extends StatelessWidget {
  double bigFont = 23.0;
  double smallFont = 14.0;
  double mediumFont = 16.0;

  FontWeight largeFontWeight = FontWeight.w900;
  FontWeight mediumFontWeight = FontWeight.w600;
  FontWeight normalFontWeight = FontWeight.normal;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: AllColors.whiteColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(40),
          topLeft: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 100,
            margin: const EdgeInsets.only(top: 10, bottom: 25),
            height: 5,
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15.0, bottom: 15),
            child: Text(
              "Fetching the request",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          dividerWidget(),
          LinearProgressIndicator(
            backgroundColor: AllColors.blueColor,
            valueColor: AlwaysStoppedAnimation(AllColors.greenColor),
            minHeight: 5,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

Widget dividerWidget() {
  return Divider(
    color: Colors.grey.shade300,
    height: 2,
    thickness: 1.5,
  );
}
