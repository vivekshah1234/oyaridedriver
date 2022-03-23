import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/dynamic_extensions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/image_assets.dart';
import 'package:oyaridedriver/Models/request_model.dart';
import 'package:timelines/timelines.dart';

class RiderDetailScreen extends StatefulWidget {
  final RequestModel requestModel;

  const RiderDetailScreen(this.requestModel);

  @override
  _RiderDetailScreenState createState() => _RiderDetailScreenState();
}

class _RiderDetailScreenState extends State<RiderDetailScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  // late double latitude, longitude;
  late CameraPosition _kGooglePlex;
  final List<LatLng> _polylineCoordinates = [];
  bool _isLoading = true;
  final Set<Marker> _markers = {};
  late final Set<Polyline> _polyLine = <Polyline>{};
  final PolylinePoints _polylinePoints = PolylinePoints();

  final double _smallFontSize = 15;

  final FontWeight _normalFontWeight = FontWeight.normal;

  // final double _sourceLatitude = 22.6916;
  // final double _sourceLongitude = 72.8634;
  // final double _destinationLatitude = 23.0225;
  // final double _destinationLongitude = 72.5714;

  @override
  void initState() {
    getCurrentPosition();
    setMarker();
    setPolyline();
    super.initState();
  }

  getCurrentPosition() async {
    _kGooglePlex = CameraPosition(
      target:
          LatLng(double.parse(widget.requestModel.sourceLatitude), double.parse(widget.requestModel.sourceLongitude)),
      zoom: 14.4746,
    );

    _isLoading = false;
    setState(() {});
  }

  setMarker() {
    _markers.add(Marker(
        markerId: const MarkerId("source"),
        position:
            LatLng(double.parse(widget.requestModel.sourceLatitude), double.parse(widget.requestModel.sourceLongitude)),
        onTap: () {},
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: const Offset(0.5, 0.5),
        icon: BitmapDescriptor.defaultMarkerWithHue(120)));

    _markers.add(Marker(
        markerId: const MarkerId("destination"),
        position: LatLng(double.parse(widget.requestModel.destinationLatitude),
            double.parse(widget.requestModel.destinationLongitude)),
        onTap: () {},
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: const Offset(0.5, 0.5),
        icon: BitmapDescriptor.defaultMarker));
  }

  setPolyline() async {
    var result = await _polylinePoints.getRouteBetweenCoordinates(
        ApiKeys.mapApiKey,
        PointLatLng(
            double.parse(widget.requestModel.sourceLatitude), double.parse(widget.requestModel.sourceLongitude)),
        PointLatLng(double.parse(widget.requestModel.destinationLatitude),
            double.parse(widget.requestModel.destinationLongitude)));
    printInfo(info: result.errorMessage.toString());
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    setState(() {
      _polyLine.add(Polyline(
          polylineId: const PolylineId("poly"), color: AllColors.greenColor, width: 3, points: _polylineCoordinates));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget2("Rider Details"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AllColors.greyColor,
                  backgroundImage: NetworkImage(widget.requestModel.profilePic.toString()),
                  radius: 32,
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Text(widget.requestModel.userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w800, fontSize: ScreenUtil().setSp(17), color: AllColors.blackColor)),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      textWidget(
                          txt: "₦${widget.requestModel.price}",
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
          _isLoading
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
                          decoration: BoxDecoration(color: AllColors.blueColor, borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
                          child: textWidget(
                              txt: "Kilometer : ${widget.requestModel.kilometer} km",
                              fontSize: ScreenUtil().setSp(15),
                              color: AllColors.whiteColor,
                              bold: FontWeight.w600,
                              italic: false),
                        ),
                      ),
                    ],
                  ),
                ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25, top: 0, bottom: 15),
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
                                      Text(widget.requestModel.sourceAddress,
                                          style: TextStyle(
                                            fontSize: _smallFontSize,
                                            color: AllColors.greyColor,
                                            fontWeight: _normalFontWeight,
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
                                      Text(widget.requestModel.destinationAddress,
                                          style: TextStyle(
                                            fontSize: _smallFontSize,
                                            color: AllColors.greyColor,
                                            fontWeight: _normalFontWeight,
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
                      ],
                    ),
                  ),
                  widget.requestModel.vehicleType == 1
                      ? Center(
                          child: Image.asset(
                            ImageAssets.liteCarIcon,
                            scale: 10,
                          ),
                        )
                      : widget.requestModel.vehicleType == 2
                          ? Center(
                              child: Image.asset(
                                ImageAssets.familyCarIcon,
                                scale: 10,
                              ),
                            )
                          : Center(
                              child: Image.asset(
                                ImageAssets.businessCarIcon,
                                scale: 10,
                              ),
                            )
                  // AppButton(
                  //   text: "ACCEPT",
                  //   onPressed: () {},
                  //   color: AllColors.greenColor,
                  // ),
                  // AppButton(
                  //   onPressed: () {},
                  //   color: AllColors.blueColor,
                  //   text: "IGNORE",
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
