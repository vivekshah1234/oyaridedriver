import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/image_assets.dart';
import 'package:oyaridedriver/Models/YourTripHistoryModel.dart';
import 'package:oyaridedriver/Models/trip_history_list_model.dart';
import 'package:timelines/timelines.dart';

class TripDetailScreen extends StatefulWidget {
  final TripHistoryModel tripDetails;

  const TripDetailScreen({required this.tripDetails});

  @override
  _TripDetailScreenState createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  late double sourceLatitude, sourceLongitude, destinationLatitude, destinationLongitude;
  late CameraPosition _kGooglePlex;
  final List<LatLng> _polylineCoordinates = [];
  bool _isLoading = true;
  final Set<Marker> _markers = {};
  late final Set<Polyline> _polyLine = <Polyline>{};
  final PolylinePoints _polylinePoints = PolylinePoints();

  final double _smallFontSize = 15;

  final FontWeight _normalFontWeight = FontWeight.normal;
  List feedBackList = [];

  @override
  void initState() {
    if (widget.tripDetails.feedBackData != null) {
      print("aa==="+widget.tripDetails.feedBackData!.description.toString());
      feedBackList.addAll(widget.tripDetails.feedBackData!.description!.split(","));
      print("feedback length==" + feedBackList.length.toString());
    }
    getCurrentPosition();
    setPolyline();
    super.initState();
  }

  getCurrentPosition() async {
    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    sourceLatitude = double.parse(widget.tripDetails.sourceLatitude);
    sourceLongitude = double.parse(widget.tripDetails.sourceLongitude);
    destinationLatitude = double.parse(widget.tripDetails.destinationLatitude);
    destinationLongitude = double.parse(widget.tripDetails.destinationLongitude);
    _kGooglePlex = CameraPosition(
      target: LatLng(sourceLatitude, sourceLongitude),
      zoom: 14.4746,
    );
    //.  final GoogleMapController controller = await _controller.future;
    // await updateCameraLocation(LatLng(sourceLatitude, sourceLongitude), LatLng(destinationLatitude, destinationLongitude), controller);
    _markers.add(Marker(
        markerId: const MarkerId("source"),
        position: LatLng(sourceLatitude, sourceLongitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(129)));
    _markers.add(Marker(
        markerId: const MarkerId("destination"),
        position: LatLng(destinationLatitude, destinationLongitude),
        icon: BitmapDescriptor.defaultMarker));

    _isLoading = false;
    setState(() {});
  }

  setPolyline() async {
    var result = await _polylinePoints.getRouteBetweenCoordinates(ApiKeys.mapApiKey,
        PointLatLng(sourceLatitude, sourceLongitude), PointLatLng(destinationLatitude, destinationLongitude));

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    setState(() {
      _polyLine.add(Polyline(
          polylineId: const PolylineId("poly"), color: AllColors.blueColor, width: 3, points: _polylineCoordinates));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget2("Trip Details"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                            left: 10,
                            bottom: 10,
                            child: Container(
                              decoration:
                                  BoxDecoration(color: AllColors.blueColor, borderRadius: BorderRadius.circular(5)),
                              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
                              child: textWidget(
                                  txt: "Distance : ${widget.tripDetails.kilometer.toString()} KM",
                                  fontSize: _smallFontSize,
                                  color: AllColors.whiteColor,
                                  bold: _normalFontWeight,
                                  italic: false),
                            ))
                      ],
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.tripDetails.createdAt.substring(0, 10) +
                            "," +
                            widget.tripDetails.createdAt.substring(12, 19),
                        style: TextStyle(fontWeight: _normalFontWeight, fontSize: _smallFontSize),
                      ),
                      Text(
                        "₦${widget.tripDetails.price}",
                        style: TextStyle(fontWeight: _normalFontWeight, fontSize: _smallFontSize),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.tripDetails.vehicleDetail.vehicleModel +
                            "," +
                            widget.tripDetails.vehicleDetail.vehicleManufacturer +
                            "," +
                            widget.tripDetails.vehicleDetail.vehicleColor,
                        style: TextStyle(
                            fontWeight: _normalFontWeight, fontSize: _smallFontSize, color: AllColors.greyColor),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 15),
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
                                      Text(widget.tripDetails.sourceAddress,
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
                                      Text(widget.tripDetails.destinationAddress,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${widget.tripDetails.userDetail.firstName} rated you",
                        style: TextStyle(fontWeight: _normalFontWeight, fontSize: _smallFontSize),
                      ),
                      RatingBar.builder(
                        initialRating: widget.tripDetails.feedBackData == null
                            ? 0
                            : double.parse(widget.tripDetails.feedBackData!.userFeedback!),
                        minRating: 1,
                        direction: Axis.horizontal,
                        itemSize: 16,
                        allowHalfRating: true,
                        tapOnlyMode: false,
                        ignoreGestures: true,
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
                  widget.tripDetails.feedBackData != null && widget.tripDetails.feedBackData!.description != " "
                      ? Container(
                          //color: Colors.red,
                          height: 40,
                          child: ListView.builder(
                              itemCount: feedBackList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                      color: AllColors.greenColor,
                                      borderRadius: BorderRadius.circular(7),
                                      border: Border.all(color: AllColors.greenColor)),
                                  margin: const EdgeInsets.only(top: 10, right: 10),
                                  padding: const EdgeInsets.only(bottom: 4, top: 4, left: 10, right: 10),
                                  child: textWidget(
                                      txt: feedBackList[index],
                                      fontSize: 16,
                                      color: AllColors.whiteColor,
                                      bold: FontWeight.w500,
                                      italic: false),
                                );
                              }),
                        )
                      : Container(),
                  widget.tripDetails.status == 8
                      ? Container(
                    decoration: BoxDecoration(
                      color: AllColors.blueColor,
                    ),
                    width: double.infinity,

                    padding: const EdgeInsets.only(
                      top: 7,
                      bottom: 7,
                    ),
                    //   margin: const EdgeInsets.only(bottom: 10),
                    child: Center(
                      child: Text(
                        "This trip has been cancelled.",
                        style: TextStyle(
                            color: AllColors.greenColor, fontSize: _smallFontSize, fontWeight: FontWeight.w800),
                      ),
                    ),
                  )
                      : widget.tripDetails.vehicleType == 1
                      ? Center(
                    child: Image.asset(
                      ImageAssets.liteCarIcon,
                      scale: 10,
                    ),
                  )
                      : widget.tripDetails.vehicleType == 2
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
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Future<void> updateCameraLocation(
    LatLng source,
    LatLng destination,
    GoogleMapController mapController,
  ) async {
    if (mapController == null) return;

    LatLngBounds bounds;

    if (source.latitude > destination.latitude && source.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: destination, northeast: source);
    } else if (source.longitude > destination.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(source.latitude, destination.longitude),
          northeast: LatLng(destination.latitude, source.longitude));
    } else if (source.latitude > destination.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(destination.latitude, source.longitude),
          northeast: LatLng(source.latitude, destination.longitude));
    } else {
      bounds = LatLngBounds(southwest: source, northeast: destination);
    }

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 70);

    return checkCameraLocation(cameraUpdate, mapController);
  }

  Future<void> checkCameraLocation(CameraUpdate cameraUpdate, GoogleMapController mapController) async {
    mapController.animateCamera(cameraUpdate);
    LatLngBounds l1 = await mapController.getVisibleRegion();
    LatLngBounds l2 = await mapController.getVisibleRegion();

    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
      return checkCameraLocation(cameraUpdate, mapController);
    }
  }
}
