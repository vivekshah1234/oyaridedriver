import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/ApiServices/networkcall.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_methods.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/extension_widgets.dart';
import 'package:oyaridedriver/Common/image_assets.dart';
import 'package:oyaridedriver/UIScreens/chat_list_screen.dart';
import 'package:oyaridedriver/UIScreens/mapScreens/map_screen.dart';
import 'package:oyaridedriver/UIScreens/settings_screen.dart';
import 'package:oyaridedriver/UIScreens/vehicle_management_screen.dart';
import 'package:oyaridedriver/UIScreens/your_trip_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sized_context/src/extensions.dart';

import 'driver_payment_list_screen.dart';
import 'home_screen.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final List<DrawerItems> _drawerList = [
    DrawerItems(
        0,
        ImageAssets.addHomeIcon,
        "Home",
        const MapHomeScreen(
          isFromNotification: false,
        )),
    DrawerItems(1, ImageAssets.paymentIcon, "Payment", const DriverPaymentListScreen()),
    DrawerItems(2, ImageAssets.yourTripeIcon, "Your Trip", const YourTripScreen()),
    DrawerItems(3, ImageAssets.yourTripeIcon, "Vehicle Management", const VehicleManagementScreen()),
    DrawerItems(5, ImageAssets.chatIcon, "Message", const ChatListScreen()),
    DrawerItems(6, ImageAssets.settingIcon, "Settings", const SettingScreen()),
    DrawerItems(7, ImageAssets.logoutIcon, "Logout", Container()),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AllColors.whiteColor,
        padding: EdgeInsets.only(top: context.heightPct(0.07)),
        child: Column(
          // Important: Remove any padding from the ListView.
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30.0, bottom: 20),
              child: Row(
                children: [
                  AppConstants.profilePic != "profilePic"
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(AppConstants.profilePic),
                          backgroundColor: AllColors.greenColor,
                          radius: 28,
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(imgUrl),
                          backgroundColor: AllColors.blueColor,
                          radius: 28,
                        ),
                  const SizedBox(
                    width: 15,
                  ),
                  textWidget(
                      txt: AppConstants.fullName,
                      fontSize: 18,
                      color: AllColors.blackColor,
                      bold: FontWeight.w900,
                      italic: false)
                ],
              ),
            ),
            Expanded(child: listView())
          ],
        ),
      ),
    );
  }

  Widget listView() {
    return Container(
      decoration: BoxDecoration(
          color: AllColors.greenColor,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      child: ListView.builder(
          itemCount: _drawerList.length,
          itemBuilder: (context, index) {
            return ListTile(
              //minVerticalPadding: 10,
              title: Text(
                _drawerList[index].name,
                style: const TextStyle(color: AllColors.whiteColor, fontSize: 16, fontWeight: FontWeight.w700),
              ),
              leading: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Image.asset(
                  _drawerList[index].iconData,
                  color: AllColors.whiteColor,
                  scale: index == 0 ? 7 : 5,
                ),
              ),
              onTap: () {
                if (_drawerList[index].id < 7) {
                  Get.offAll(() => _drawerList[index].screen);
                } else {
                  logoutDialog();
                }
              },
            );
          }),
    );
  }

  logoutDialog() {
    showAnimatedDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Column(
          children: [
            textWidget(
                txt: "Are you sure you want to logout?",
                fontSize: 14,
                color: AllColors.blueColor,
                bold: FontWeight.bold,
                italic: false),
            const SizedBox(
              height: 15,
            ),
            AppButton(
                text: "Logout".toUpperCase(),
                color: AllColors.greenColor,
                onPressed: () async {
                  Map<String, String> map = {};
                  map["is_available"] = "0";
                  await changeUserStatus(map);
                  AppConstants.userToken = "userToken";
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
                  _firebaseMessaging.deleteToken();

                  destroyData();
                  sp.remove("token");
                  sp.remove("userData");
                  sp.remove("currentRole");

                  Get.offAll(() => const HomeScreen());
                })
          ],
        ).alertCard(context);
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
    );
  }
}

changeUserStatus(Map<String, String> map) async {
  bool hasExpired = JwtDecoder.isExpired(AppConstants.userToken);
//  printInfo(info: "expire token====" + hasExpired.toString());
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
        } else {
          print(valueMap["message"].toString());
        }
      } else {
        //     handleError(value.error.toString(), context);
        print(value.error.toString());
      }
    });
  }
}

destroyData() {
  AppConstants.userToken = "userToken";
  AppConstants.profilePic = "profilePic";
  AppConstants.userID = "user_id";
  AppConstants.email = "email_id";
  AppConstants.fullName = "fullName";
  AppConstants.countryCode = "countryCode";
  AppConstants.mobileNo = "mobileNo";
  AppConstants.isVerified = false;
}

class DrawerItems {
  late int id;
  late String iconData;
  late String name;
  Widget screen;

  DrawerItems(this.id, this.iconData, this.name, this.screen);
}
