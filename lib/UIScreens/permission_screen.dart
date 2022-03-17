import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:oyaridedriver/Common/allString.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/UIScreens/home_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllPermissionPage extends StatefulWidget {
  const AllPermissionPage({Key? key}) : super(key: key);

  @override
  _AllPermissionPageState createState() => _AllPermissionPageState();
}

class _AllPermissionPageState extends State<AllPermissionPage> {
  bool allowedAllPermission = false;

  @override
  void initState() {
    setPermissionSP();
    super.initState();
  }

  setPermissionSP() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool("allPermission", allowedAllPermission);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColors.whiteColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AllStrings.ok.tr,
                textAlign: TextAlign.center,
                style: TextStyle(color: AllColors.greenColor, fontSize: 25, fontWeight: FontWeight.w800),
              ),
              Text(
                AllStrings.permissionText.tr,
                textAlign: TextAlign.center,
                style:  TextStyle(color: AllColors.blueColor, fontSize: 18, fontWeight: FontWeight.w400),
              )
            ],
          ),
          Expanded(flex: 2, child: Container()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.camera,
                color: AllColors.greenColor,
                size: 30,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AllStrings.permissionTitle1.tr,
                      // textAlign: TextAlign.center,
                      style: TextStyle(color: AllColors.greenColor, fontSize: 17, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      AllStrings.permissionText1.tr,
                      // textAlign: TextAlign.center,
                      style:  TextStyle(color: AllColors.blueColor, fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )
            ],
          ).paddingSymmetric(horizontal: 25, vertical: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.storage_outlined,
                color: AllColors.greenColor,
                size: 30,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AllStrings.permissionTitle2.tr,
                      // textAlign: TextAlign.center,
                      style: TextStyle(color: AllColors.greenColor, fontSize: 17, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      AllStrings.permissionText2.tr,
                      // textAlign: TextAlign.center,
                      style:  TextStyle(color: AllColors.blueColor, fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )
            ],
          ).paddingSymmetric(horizontal: 25, vertical: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.call,
                color: AllColors.greenColor,
                size: 30,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AllStrings.permissionTitle3.tr,
                      // textAlign: TextAlign.center,
                      style: TextStyle(color: AllColors.greenColor, fontSize: 17, fontWeight: FontWeight.w800),
                    ),
                    const   SizedBox(
                      height: 5,
                    ),
                    Text(
                      AllStrings.permissionText3.tr,
                      // textAlign: TextAlign.center,
                      style: TextStyle(color: AllColors.blueColor, fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )
            ],
          ).paddingSymmetric(horizontal: 25, vertical: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_pin,
                color: AllColors.greenColor,
                size: 30,
              ),
              const  SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AllStrings.permissionTitle4,
                      // textAlign: TextAlign.center,
                      style: TextStyle(color: AllColors.greenColor, fontSize: 17, fontWeight: FontWeight.w800),
                    ),
                    const   SizedBox(
                      height: 5,
                    ),
                    Text(
                      AllStrings.permissionText4, // textAlign: TextAlign.center,
                      style:  TextStyle(color: AllColors.blueColor, fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )
            ],
          ).paddingSymmetric(horizontal: 25, vertical: 15),
          Expanded(flex: 2, child: Container()),
          AppButton(
              text: AllStrings.allowAllAccess,
              color: AllColors.greenColor,
              onPressed:  () async {
                bool permissionAllowed = await determinePosition(context);
                printInfo(info: "Final location permission decision====" + permissionAllowed.toString());
                if (permissionAllowed == true) {
                  bool mediaPermissionAllowed = await checkMediaPermission();
                  printInfo(info: "Final media permission decision====" + mediaPermissionAllowed.toString());
                  if (mediaPermissionAllowed) {
                    bool cameraPermissionAllowed = await checkCameraPermission();
                    printInfo(info: "Final camera permission decision====" + mediaPermissionAllowed.toString());
                    if (cameraPermissionAllowed) {
                      allowedAllPermission = true;
                      SharedPreferences sp = await SharedPreferences.getInstance();
                      sp.setBool("allPermission", allowedAllPermission);
                      Get.offAll(const HomeScreen());
                    }
                  }
                }
              }).paddingSymmetric(horizontal: 20),
          Expanded(flex: 1, child: Container()),
        ],
      ),
    );
  }

  Future<bool> determinePosition(context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      permission = await Geolocator.checkPermission();
      permission = await Geolocator.requestPermission();

      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      ScaffoldMessenger.of(context).showSnackBar(greenSnackBar("Please turn on the location"));
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        permission = await Geolocator.checkPermission();
        permission = await Geolocator.requestPermission();

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      permission = await Geolocator.checkPermission();
      permission = await Geolocator.requestPermission();
      ScaffoldMessenger.of(context).showSnackBar(greenSnackBar(
          "'Location permissions are permanently denied, we cannot request permissions.Please allow it from app info."));
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return serviceEnabled;
  }

  Future<bool> checkMediaPermission() async {
    PermissionStatus status = await Permission.mediaLibrary.status;
    if (status.isPermanentlyDenied) return openAppSettings();
    status = await Permission.mediaLibrary.request();
    printInfo(info: "ssss==" + status.toString());
    if (status.isDenied) {
      status = await Permission.mediaLibrary.request();
      return false;
    } else if (status.isGranted) {
      return true;
    }
    return false;
  }

  Future<bool> checkCameraPermission() async {
    PermissionStatus status = await Permission.camera.status;
    if (status.isPermanentlyDenied) return openAppSettings();
    status = await Permission.camera.request();
    printInfo(info: "ssss==" + status.toString());
    if (status.isDenied) {
      status = await Permission.camera.request();
      return false;
    } else if (status.isGranted) {
      return true;
    }
    return false;
  }
}
