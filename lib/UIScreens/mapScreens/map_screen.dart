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
import 'package:oyaridedriver/UIScreens/ChatUI/chat_screen.dart';
import 'package:oyaridedriver/UIScreens/drawer_screen.dart';
import 'package:oyaridedriver/UIScreens/rider_details_screen.dart';
import 'package:oyaridedriver/controllers/home_controller.dart';
import 'package:sized_context/src/extensions.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import '../../main.dart';
import '../cancel_ride_reason_dialog.dart';
import '../notification_screen.dart';

class MapHomeScreen extends StatefulWidget {
  final bool isFromNotification;
  final dynamic userId;

  const MapHomeScreen({required this.isFromNotification, this.userId});

  @override
  _MapHomeScreenState createState() => _MapHomeScreenState();
}

class _MapHomeScreenState extends State<MapHomeScreen>
    with FCMNotificationMixin, FCMNotificationClickMixin, WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final HomeController _homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _homeController.connectToSocket(isFromNotification: widget.isFromNotification, userid: widget.userId);
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
      _homeController.sendIdToSocket(map);
    }

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
                  drawer: const DrawerScreen(),
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
                          Get.to(()=> const NotificationScreen());
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
                              child: const CircleAvatar(
                                backgroundColor: AllColors.whiteColor,
                                child: Icon(
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
                                if(controller.currentAppState.value==0){
                                Map<String, String> map = {};
                                map["is_available"] = "1";
                                _homeController.changeUserStatus(map);
                                }else{
                                  toast("You can not be online while you are already on a ride.");
                                }
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
                                _homeController.changeUserStatus(map);
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
                      controller.isLoadingMap.value
                          ? SizedBox(
                              height: double.infinity,
                              width: double.infinity,
                              child: greenLoadingWidget(),
                            )
                          : Stack(
                              alignment: Alignment.center,
                              children: [
                                GoogleMap(
                                  mapType: MapType.terrain,
                                  initialCameraPosition:
                                      controller.cameraAnimate.value ? controller.kGooglePlex2 : controller.kGooglePlex,
                                  onMapCreated: (GoogleMapController mapController) {
                                    controller.mapController.complete(mapController);
                                  },
                                  markers: controller.markers,
                                  polylines: Set<Polyline>.of(controller.polylines.values),
                                ),
                                Visibility(
                                    visible: controller.isAddingMarkerAndPolyline.value, child: greenLoadingWidget())
                              ],
                            ),
                      Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: controller.isAddingData.value
                              ? const FetchingTheRequests("Fetching the request")
                              : controller.currentAppState.value == 0 //&& controller.swipeItems.isEmpty
                                  ? NoRequestCart(
                                      userOnline: AppConstants.userOnline,
                                    )
                                  : Container(
                                      child: controller.currentAppState.value == 1 && !controller.isLoadingDriver.value
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
                                                        price: controller.requestList[index].price,
                                                        pickUpPoint: controller.requestList[index].sourceAddress,
                                                        dropOffPoint: controller.requestList[index].destinationAddress,
                                                        acceptOnTap: () {
                                                          controller.matchEngine.currentItem?.like();
                                                          Map<String, dynamic> map = {
                                                            "trip_id": controller.requestList[index].id,
                                                            "driver_id": AppConstants.userID
                                                          };
                                                          _homeController.acceptRequest(map);
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

                                                  // controller.polyLine.clear();
                                                  controller.markers.clear();

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
                                                boxShadow: [boxShadow()],
                                              ),
                                              child: Column(
                                                children: [
                                                  controller.currentAppState.value == 2 &&
                                                          !controller.isLoadingDriver.value
                                                      ? RiderDetails(
                                                          name: controller.acceptedDriverModel.userData.firstName +
                                                              " " +
                                                              controller.acceptedDriverModel.userData.lastName,
                                                          profilePic:
                                                              controller.acceptedDriverModel.userData.profilePic,
                                                          callButton: () {
                                                            String number = controller
                                                                    .acceptedDriverModel.userData.countryCode +
                                                                controller.acceptedDriverModel.userData.mobileNumber;
                                                            url_launcher.launch("tel://$number");
                                                          },
                                                          chatTap: () {
                                                            Get.to(() => ChatPage(
                                                                  peerId: controller.acceptedDriverModel.userData.id
                                                                      .toString()
                                                                      .toString(),
                                                                ));
                                                          },
                                                          cancelTap: () {},
                                                          arrivedTap: () {
                                                            Map<String, dynamic> map = {
                                                              "trip_id":
                                                                  controller.acceptedDriverModel.tripData.id.toString(),
                                                            };
                                                            _homeController.reachedAtLoc(map);
                                                          },
                                                        )
                                                      : controller.currentAppState.value == 3 &&
                                                              !controller.isLoadingDriver.value
                                                          ? ReachedAtLoc(
                                                              name: controller.acceptedDriverModel.userData.firstName +
                                                                  " " +
                                                                  controller.acceptedDriverModel.userData.lastName,
                                                              profilePic:
                                                                  controller.acceptedDriverModel.userData.profilePic,
                                                              chatTap: () {},
                                                              callButton: () {
                                                                String number = controller
                                                                        .acceptedDriverModel.userData.countryCode +
                                                                    controller
                                                                        .acceptedDriverModel.userData.mobileNumber;
                                                                url_launcher.launch("tel://$number");
                                                              },
                                                              cancelTap: () {},
                                                              pickedTap: () {
                                                                Map<String, dynamic> map = {
                                                                  "trip_id": controller.acceptedDriverModel.tripData.id
                                                                      .toString(),
                                                                };
                                                                _homeController.pickedUp(map);
                                                              },
                                                            )
                                                          : controller.currentAppState.value == 4 &&
                                                                  !controller.isLoadingDriver.value
                                                              ? WhileTravelingCart(
                                                                  name: controller
                                                                          .acceptedDriverModel.userData.firstName +
                                                                      " " +
                                                                      controller.acceptedDriverModel.userData.lastName,
                                                                  profilePic: controller
                                                                      .acceptedDriverModel.userData.profilePic,
                                                                  dropTap: () {
                                                                    Map<String, dynamic> map = {
                                                                      "trip_id": controller
                                                                          .acceptedDriverModel.tripData.id
                                                                          .toString(),
                                                                    };
                                                                    _homeController.dropAtLoc(map);
                                                                  },
                                                                )
                                                              : controller.currentAppState.value == 5 &&
                                                                      !controller.isLoadingDriver.value
                                                                  ? CompleteRide(
                                                                      name: controller
                                                                              .acceptedDriverModel.userData.firstName +
                                                                          " " +
                                                                          controller
                                                                              .acceptedDriverModel.userData.lastName,
                                                                      price:
                                                                          controller.acceptedDriverModel.tripData.price,
                                                                      bookingId: controller
                                                                          .acceptedDriverModel.tripData.bookingId
                                                                          .toString(),
                                                                      paymentType: controller
                                                                          .acceptedDriverModel.userData.paymentType,
                                                                      kilometer: controller
                                                                          .acceptedDriverModel.tripData.kilometer
                                                                          .toString(),
                                                                      confirmPayment: () {
                                                                        Map<String, dynamic> map = {
                                                                          "trip_id": controller
                                                                              .acceptedDriverModel.tripData.id
                                                                              .toString(),
                                                                          "payment_status": "1"
                                                                        };
                                                                        _homeController.confirmPayment(map);
                                                                        // animatedGif();
                                                                      },
                                                                    )
                                                                  : Container(),
                                                  controller.isLoadingDriver.value
                                                      ? const FetchingTheRequests("Loading.....")
                                                      : Container()
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

  animatedGif() {
    showAnimatedDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return const AnimationComplete().alertCard(context);
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
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
      _homeController.connectToSocket(isFromNotification: false);
    }
  }
}

class AnimationComplete extends StatelessWidget {
  const AnimationComplete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          ImageAssets.animatedGif,
        ),
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Congrats ${AppConstants.fullName},you have successfully completed your ride.",
                textAlign: TextAlign.center,
                maxLines: 3,
                style: TextStyle(color: AllColors.greenColor, fontSize: 18, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        )
      ],
    );
  }
}
