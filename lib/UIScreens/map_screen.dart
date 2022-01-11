import 'dart:async';
import 'dart:typed_data';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:oyaridedriver/ApiServices/notificationScreen.dart';
import 'package:oyaridedriver/Common/common_methods.dart';
import 'package:oyaridedriver/Common/image_assets.dart';
import 'package:oyaridedriver/UIScreens/drawer_screen.dart';
import 'package:oyaridedriver/UIScreens/rider_cart_screen.dart';
import 'package:oyaridedriver/UIScreens/rider_list_cart_screen.dart';
import 'package:sized_context/sized_context.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:timelines/timelines.dart';
import 'package:oyaridedriver/Common/extension_widgets.dart';
// ignore_for_file: prefer_const_constructors

class MapHomeScreen extends StatefulWidget {
  const MapHomeScreen({Key? key}) : super(key: key);

  @override
  _MapHomeScreenState createState() => _MapHomeScreenState();
}

bool isAccepted = false;

class _MapHomeScreenState extends State<MapHomeScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  late double latitude, longitude;
  late CameraPosition _kGooglePlex;

  bool isOnline = false;
  bool isLoading = true;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    getCurrentPosition();
  }

  List placesLatLng = [LatLng(23.0122, 72.5064), LatLng(23.0004, 72.4997),LatLng(22.9960, 72.4997)];

  getCurrentPosition() async {
    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    latitude = 22.9948;
    longitude = 72.4993;
    _kGooglePlex = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 14.4746,
    );

    Uint8List? imageData =
        await getBytesFromAsset(ImageAssets.driverCarIcon, 100);
    for (int i = 0; i < placesLatLng.length; i++) {
      _markers.add(Marker(
          markerId: MarkerId("marker${i.toString()}"),
          position: placesLatLng[i],
          onTap: () {},
          draggable: false,
          zIndex: 2,
          rotation: 120,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(
            imageData!,
          )));
    }
    isLoading = false;
    setState(() {});
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                Get.to(() => NotificationScreen());
              },
              child: CircleAvatar(
                backgroundColor: AllColors.whiteColor,
                child: const Icon(
                  Icons.notifications_none_sharp,
                  size: 30,
                  color: AllColors.blackColor,
                ),
              ),
            ),
          ),
          !isOnline
              ? GestureDetector(
                  onTap: () {
                    isOnline = !isOnline;
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: AllColors.blackColor,
                        borderRadius: BorderRadius.circular(13)),
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
                    isOnline = !isOnline;
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: AllColors.blackColor,
                        borderRadius: BorderRadius.circular(13)),
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
              ? Container(
                  height: double.infinity,
                  width: double.infinity,
                 // color: Colors.red,
                )
              : GoogleMap(
                  mapType: MapType.terrain,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: _markers,
                ),
          Positioned(

            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
                //  height: MediaQuery.of(context).size.height*0.40,
                 // color: AllColors.redColor,
                child: RiderCartScreen()),
          )
        ],
      ),
    );
  }

  Widget textWidget(
      {required String txt,
      required double fontSize,
      required Color color,
      required FontWeight bold,
      required bool italic}) {
    return Text(
      txt,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: bold,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
