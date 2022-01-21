// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:typed_data';
// import 'package:badges/badges.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:location/location.dart';
// import 'package:maps_toolkit/maps_toolkit.dart' as poly_util;
// import 'package:oyaridedriver/ApiServices/api_constant.dart';
// import 'package:oyaridedriver/ApiServices/notificationScreen.dart';
// import 'package:oyaridedriver/Common/common_methods.dart';
// import 'package:oyaridedriver/Common/common_widgets.dart';
// import 'package:oyaridedriver/Common/image_assets.dart';
// import 'package:oyaridedriver/UIScreens/drawer_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:oyaridedriver/Common/all_colors.dart';
// import 'package:oyaridedriver/Common/extension_widgets.dart';
// import 'package:dotted_line/dotted_line.dart';
// import 'package:oyaridedriver/UIScreens/rider_details_screen.dart';
// import 'package:oyaridedriver/UIScreens/rider_list_cart_screen.dart';
// import 'package:sized_context/src/extensions.dart';
// import 'package:swipe_cards/swipe_cards.dart';
// import 'package:url_launcher/url_launcher.dart' as url_launcher;
//
// import '../main.dart';
// class MapScreenWithData extends StatefulWidget {
//   const MapScreenWithData({Key? key}) : super(key: key);
//
//   @override
//   _MapScreenWithDataState createState() => _MapScreenWithDataState();
// }
//
// class _MapScreenWithDataState extends State<MapScreenWithData> {
//   final Completer<GoogleMapController> _controller = Completer();
//   late double latitude, longitude;
//   late CameraPosition _kGooglePlex;
//   late LatLng _lastMapPosition;
//   bool isOnline = false;
//   bool isLoading = true;
//   final Set<Marker> _markers = {};
//   final Set<Polyline> _polyLine = <Polyline>{};
//   List<LatLng> polyLineCoordinates = [];
//   late PolylinePoints polylinePoints;
//   int status = -1;
//   final List<SwipeItem> _swipeItems = [];
//   late MatchEngine _matchEngine;
//   List<Map<String, dynamic>> dataList = [
//     {
//       "name": "Ian Somerholder",
//       "imgUrl": imgUrl,
//       "charge": 50.0,
//       "kiloMeter": 15.0,
//       "sourcePoint": "Medical Education Center",
//       "destinationPoint": "Barthimam College",
//       "route": DummyData.route1,
//       "sourceLatLong": LatLng(22.9960, 72.4997),
//       "destinationLatLong": LatLng(23.0585, 72.5175),
//     },
//     {
//       "name": "Paul Welsey",
//       "imgUrl": imgUrl,
//       "charge": 50.0,
//       "kiloMeter": 15.0,
//       "sourcePoint": "Medical Education Center",
//       "destinationPoint": "Barthimam College",
//       "route": DummyData.route2,
//       "sourceLatLong": LatLng(22.9960, 72.4997),
//       "destinationLatLong": LatLng(23.0145, 72.5929),
//     },
//     {
//       "name": "Nina Doberev",
//       "imgUrl": imgUrl,
//       "charge": 50.0,
//       "kiloMeter": 15.0,
//       "sourcePoint": "Medical Education Center",
//       "destinationPoint": "Barthimam College",
//       "route": DummyData.route1,
//       "sourceLatLong": LatLng(22.9960, 72.4997),
//       "destinationLatLong": LatLng(23.0585, 72.5175),
//     },
//     {
//       "name": "Tony Somerholder",
//       "imgUrl": imgUrl,
//       "charge": 50.0,
//       "kiloMeter": 15.0,
//       "sourcePoint": "Medical Education Center",
//       "destinationPoint": "Barthimam College",
//       "route": DummyData.route2,
//       "sourceLatLong": LatLng(22.9960, 72.4997),
//       "destinationLatLong": LatLng(23.0145, 72.5929),
//     }
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     getCurrentPosition();
//     init();
//     //   setPolyline();
//   }
//
//   init() {
//     for (int i = 0; i < dataList.length; i++) {
//       _swipeItems.add(SwipeItem(
//           content: Content(
//               name: dataList[i]["name"],
//               imgurl: dataList[i]["imgUrl"],
//               charge: dataList[i]["charge"],
//               kiloMeter: dataList[i]["kiloMeter"],
//               pickUpPoint: dataList[i]["sourcePoint"],
//               destinationPoint: dataList[i]["destinationPoint"]),
//           likeAction: () {
//             printInfo(info: "like");
//             acceptRequest(i);
//           },
//           nopeAction: () {
//             setMarker(
//                 source: dataList[i + 1]["sourceLatLong"],
//                 destination: dataList[i + 1]["destinationLatLong"]);
//             setPolyline(dataList[i + 1]["route"]);
//             printInfo(info: "nope");
//           },
//           superlikeAction: () {
//             printInfo(info: "super Like");
//           }));
//     }
//     polylinePoints = PolylinePoints();
//     setMarker(
//         source: dataList[0]["sourceLatLong"],
//         destination: dataList[0]["destinationLatLong"]);
//     setPolyline(dataList[0]["route"]);
//
//     _matchEngine = MatchEngine(swipeItems: _swipeItems);
//   }
//
//   getCurrentPosition() async {
//     Position position = await determinePosition();
//     latitude = position.latitude;
//     longitude = position.longitude;
//     _lastMapPosition = LatLng(latitude, longitude);
//     _kGooglePlex = CameraPosition(
//       target: _lastMapPosition,
//       zoom: 14.4746,
//     );
//
//     isLoading = false;
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         isLoading
//             ? SizedBox(
//           height: double.infinity,
//           width: double.infinity,
//           child: greenLoadingWidget(),
//         )
//             : GoogleMap(
//           mapType: MapType.terrain,
//           initialCameraPosition: _kGooglePlex,
//           onMapCreated: (GoogleMapController controller) {
//             _controller.complete(controller);
//           },
//           markers: _markers,
//           polylines: _polyLine,
//         ),
//         Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               child: status == -1
//                   ? SizedBox(
//                 height: calculateHeight(
//                     MediaQuery.of(context).size.height, context),
//                 child: SwipeCards(
//                   matchEngine: _matchEngine,
//                   itemBuilder: (BuildContext context, int index) {
//                     return GestureDetector(
//                         onTap: () {
//                           Get.to(() => const RiderDetailScreen());
//                         },
//                         child: SwipeItem2(
//                           name: dataList[index]["name"],
//                           imgUrl: dataList[index]["imgUrl"],
//                           km: dataList[index]["kiloMeter"],
//                           price: dataList[index]["charge"],
//                           pickUpPoint: dataList[index]["sourcePoint"],
//                           dropOffPoint: dataList[index]
//                           ["destinationPoint"],
//                           acceptOnTap: () {
//                             _matchEngine.currentItem?.like();
//                             acceptRequest(index);
//                             setState(() {});
//                           },
//                           ignoreOnTap: () {
//                             printInfo(info: "aaaaa");
//                             _matchEngine.currentItem?.nope();
//                             if (index != dataList.length - 1) {
//                               setMarker(
//                                   source: dataList[index + 1]
//                                   ["sourceLatLong"],
//                                   destination: dataList[index + 1]
//                                   ["destinationLatLong"]);
//                               setPolyline(dataList[index + 1]["route"]);
//                             }
//                             setState(() {});
//                           },
//                         ));
//                   },
//                   onStackFinished: () {
//                     // _scaffoldKey.currentState
//                     //     ?.showSnackBar(const SnackBar(
//                     //   content: Text("Stack Finished"),
//                     //   duration: Duration(milliseconds: 500),
//                     // ));
//
//                     polyLineCoordinates.clear();
//                     _polyLine.clear();
//                     _markers.clear();
//                     setState(() {});
//                   },
//                 ),
//               )
//                   : Container(
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                   color: AllColors.whiteColor,
//                   borderRadius: const BorderRadius.only(
//                     topRight: Radius.circular(40),
//                     topLeft: Radius.circular(40),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.5),
//                       spreadRadius: 5,
//                       blurRadius: 7,
//                       offset: const Offset(
//                           0, 3), // changes position of shadow
//                     ),
//                   ],
//                 ),
//
//                 //  padding: EdgeInsets.only(top: 10),
//                 child: Column(
//                   children: [
//                     locationDetails(),
//                     status < 2
//                         ? RiderDetails(
//                       name: "Stella Josh",
//                       callButton: () {
//                         url_launcher.launch("tel://21213123123");
//                       },
//                     )
//                         : status == 2
//                         ? whileTravelingCart()
//                         : userCart3(),
//                     status < 2
//                         ? Row(
//                       children: [
//                         SmallButton(
//                           text: "CANCEL",
//                           color: AllColors.blueColor,
//                           onPressed: () {
//                             printInfo(
//                                 info:
//                                 "************stop***********");
//                             _locationSubscription?.cancel();
//                             // _locationTracker.
//                             setState(() {
//                               _locationSubscription = null;
//                             });
//                           },
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         if (status < 1)
//                           SmallButton(
//                             text: "ARRIVED",
//                             color: AllColors.greenColor,
//                             onPressed: () {
//                               status = 1;
//                               print("tap");
//                               setState(() {});
//                             },
//                           )
//                         else if (status == 1)
//                           SmallButton(
//                             text: "PICKED UP",
//                             color: AllColors.greenColor,
//                             onPressed: () {
//                               status = 2;
//                               print("tap");
//                               setState(() {});
//                             },
//                           )
//                         else if (status == 2)
//                             Container()
//                         // Expanded(child: greenButton(txt: "ACCEPT",function: (){})),
//                       ],
//                     ).putPadding(
//                       0,
//                       20,
//                       context.widthPct(0.08),
//                       context.widthPct(0.08),
//                     )
//                         : status == 2
//                         ? AppButton(
//                         text: "TAP WHEN DROP",
//                         onPressed: () {
//                           status = 3;
//                           print("tap");
//                           setState(() {});
//                         },
//                         color: AllColors.greenColor)
//                         .paddingSymmetric(horizontal: 15)
//                         : AppButton(
//                         text: "CONFIRM PAYMENT",
//                         onPressed: () {
//                           status = 4;
//                           print("tap");
//                           setState(() {});
//                         },
//                         color: AllColors.greenColor)
//                         .paddingSymmetric(horizontal: 15),
//                   ],
//                 ),
//               ),
//             ))
//       ],
//     );
//   }
//
// }
