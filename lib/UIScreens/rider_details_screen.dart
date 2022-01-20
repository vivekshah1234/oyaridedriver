import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get_utils/src/extensions/dynamic_extensions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_methods.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/UIScreens/rider_cart_screen.dart';
import 'package:timelines/timelines.dart';

class RiderDetailScreen extends StatefulWidget {
  const RiderDetailScreen({Key? key}) : super(key: key);

  @override
  _RiderDetailScreenState createState() => _RiderDetailScreenState();
}

class _RiderDetailScreenState extends State<RiderDetailScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  // late double latitude, longitude;
  late CameraPosition _kGooglePlex;
  List<LatLng> polylineCoordinates = [];
  bool isLoading = true;
  final Set<Marker> _markers = {};
  late final Set<Polyline> _polyLine = <Polyline>{};
  PolylinePoints polylinePoints = PolylinePoints();
  double largeFontSize = 22;
  double mediumFontSize = 19;
  double smallFontSize = 15;
  FontWeight largeFontWeight = FontWeight.w900;
  FontWeight mediumFontWeight = FontWeight.w600;
  FontWeight normalFontWeight = FontWeight.normal;
  double sourceLatitude = 22.6916;
  double sourceLongitude = 72.8634;
  double destinationLatitude = 23.0225;
  double destinationLongitude = 72.5714;

  @override
  void initState() {
    getCurrentPosition();
    setMarker();
    setPolyline();
    super.initState();
  }

  getCurrentPosition() async {
    _kGooglePlex = CameraPosition(
      target: LatLng(sourceLatitude, sourceLongitude),
      zoom: 14.4746,
    );

    isLoading = false;
    setState(() {});
  }

  setMarker() {
    _markers.add(Marker(
        markerId: MarkerId("source"),
        position: LatLng(sourceLatitude, sourceLongitude),
        onTap: () {},
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.defaultMarkerWithHue(120)));

    _markers.add(Marker(
        markerId: MarkerId("source"),
        position: LatLng(destinationLatitude, destinationLongitude),
        onTap: () {},
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.defaultMarker));
  }

  setPolyline() async {
    var result = await polylinePoints.getRouteBetweenCoordinates(
        ApiKeys.mapApiKey,
        PointLatLng(sourceLatitude, sourceLongitude),
        PointLatLng(destinationLatitude, destinationLongitude));

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {
      _polyLine.add(Polyline(
          polylineId: const PolylineId("poly"),
          color: AllColors.greenColor,
          width: 3,
          points: polylineCoordinates));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget2("Trip Details"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 0),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AllColors.greyColor,
                  backgroundImage: NetworkImage(
                      "https://image.shutterstock.com/image-photo/ian-somerhalder-lost-live-final-600w-102016990.jpg"),
                  radius: 32,
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Text("Darpan Patel",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: ScreenUtil().setSp(17),
                          color: AllColors.blackColor)),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      textWidget(
                          txt: "\$60",
                          fontSize: ScreenUtil().setSp(17),
                          color: AllColors.blackColor,
                          bold: FontWeight.w600,
                          italic: false),

                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          isLoading
              ? const SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Stack(
                    children: [
                      GoogleMap(
                        mapType: MapType.terrain,
                        initialCameraPosition: _kGooglePlex,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        markers: _markers,
                        polylines: _polyLine,
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          decoration: BoxDecoration(color: AllColors.blueColor,
                          borderRadius: BorderRadius.circular(5)
                          ),
                          padding: const EdgeInsets.only(left: 10,right: 10,bottom: 5,top: 5),
                          child: textWidget(
                              txt: "Kilometer : 45 km",
                              fontSize: ScreenUtil().setSp(15),
                              color: AllColors.whiteColor,
                              bold: FontWeight.w600,
                              italic: false),
                        ),
                      ),
                    ],
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 25, right: 25, top: 0, bottom: 15),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            TimelineTile(
                              nodeAlign: TimelineNodeAlign.start,
                              contents: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text( "Source Location",
                                    //       style: TextStyle(
                                    //         fontSize: smallFontSize,
                                    //         color: AllColors.greyColor,
                                    //         fontWeight: normalFontWeight,)),
                                    //   const SizedBox(
                                    //     height: 3,
                                    //   ),
                                    Text(
                                        "Shri Santram Mandir Marg, Shanti Nagar, Nadiad, Gujarat 387001",
                                        style: TextStyle(
                                          fontSize: smallFontSize,
                                          color: AllColors.greyColor,
                                          fontWeight: normalFontWeight,
                                        )),
                                  ],
                                ),
                              ),
                              node: TimelineNode(
                                  indicator: ContainerIndicator(
                                      child: CircleAvatar(
                                    backgroundColor: AllColors.greenColor,
                                    radius: 4,
                                  )),
                                  endConnector: const DashedLineConnector(
                                    color: AllColors.greyColor,
                                  )),
                            ),
                            TimelineTile(
                              nodeAlign: TimelineNodeAlign.start,
                              contents: Container(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //      "Destination Location",
                                    //     style: TextStyle(
                                    //       fontSize: smallFontSize,
                                    //       color: AllColors.greyColor,
                                    //       fontWeight: normalFontWeight,)),
                                    // const SizedBox(
                                    //   height: 3,
                                    // ),
                                    Text("Makarba, Ahmedabad, Gujarat 380051",
                                        style: TextStyle(
                                          fontSize: smallFontSize,
                                          color: AllColors.greyColor,
                                          fontWeight: normalFontWeight,
                                        )),
                                  ],
                                ),
                              ),
                              node: TimelineNode(
                                startConnector: const DashedLineConnector(
                                  color: AllColors.greyColor,
                                ),
                                indicator: ContainerIndicator(
                                    child: CircleAvatar(
                                  backgroundColor: AllColors.blueColor,
                                  radius: 4,
                                )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Expanded(flex: 2,
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //         color:Colors.grey.shade200,
                      //         borderRadius: BorderRadius.circular(5)
                      //     ),
                      //     padding: const EdgeInsets.only(left: 5,right: 5,bottom: 5,top: 5),
                      //     child: Center(child: const Text("Receipt",style: TextStyle(),)),
                      //   ),
                      // )
                    ],
                  ),
                ),
                AppButton(text: "ACCEPT", onPressed:  () {},color: AllColors.greenColor,),
                AppButton(onPressed: () {  },color: AllColors.blueColor,text: "IGNORE",),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
