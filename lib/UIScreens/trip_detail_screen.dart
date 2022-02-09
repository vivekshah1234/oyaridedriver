import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:timelines/timelines.dart';

class TripDetailScreen extends StatefulWidget {
  const TripDetailScreen({Key? key}) : super(key: key);

  @override
  _TripDetailScreenState createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  late double latitude, longitude;
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

  @override
  void initState() {
    getCurrentPosition();
    setPolyline();
    super.initState();
  }

  getCurrentPosition() async {
    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    latitude = 22.6916;
    longitude = 72.8634;
    _kGooglePlex = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 14.4746,
    );

    isLoading = false;
    setState(() {});
  }

  setPolyline() async {
    var result = await polylinePoints.getRouteBetweenCoordinates(
        ApiKeys.mapApiKey,
        const PointLatLng(22.6916, 72.8634),
        const PointLatLng(23.0225, 72.5714));

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    setState(() {
      _polyLine.add(Polyline(
          polylineId: const PolylineId("poly"),
          color: AllColors.blueColor,
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
          isLoading
              ? const SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: GoogleMap(
                    mapType: MapType.terrain,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    markers: _markers,
                    polylines: _polyLine,
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    Text(
                      "29 Sept,2021, 9:29 PM",
                      style:
                          TextStyle(fontWeight: normalFontWeight, fontSize: smallFontSize),
                    ),
                    Text(
                      "\$60",
                      style:
                          TextStyle(fontWeight: normalFontWeight, fontSize: smallFontSize),
                    ),
                  ],
                ),
                const SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                     Text(
                      "Maruti Suzuki Wagon R",
                      style:
                      TextStyle(fontWeight: normalFontWeight, fontSize: smallFontSize,color: AllColors.greyColor),
                    ),
                    Text(
                      "Tip",
                      style:
                      TextStyle(fontWeight: normalFontWeight, fontSize: smallFontSize,color: AllColors.blueColor),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 25,right: 25,top: 15,bottom: 15),
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
                                        fontWeight: normalFontWeight,)),
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
                                    Text(
                                      "Makarba, Ahmedabad, Gujarat 380051",
                                        style: TextStyle(
                                          fontSize: smallFontSize,
                                          color: AllColors.greyColor,
                                          fontWeight: normalFontWeight,)),
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
                      Expanded(flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color:Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(5)
                        ),
                        padding: const EdgeInsets.only(left: 5,right: 5,bottom: 5,top: 5),
                        child: const Center(child: Text("Receipt",style: TextStyle(),)),
                      ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Charan rated you",
                      style:
                      TextStyle(fontWeight: normalFontWeight, fontSize: smallFontSize),
                    ),

                    RatingBar.builder(
                      initialRating: 3,
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemSize: 16,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: AllColors.greenColor,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                  ],
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}
