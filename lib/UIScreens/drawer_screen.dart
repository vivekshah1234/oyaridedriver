import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/image_assets.dart';
import 'package:oyaridedriver/UIScreens/chat_screen.dart';
import 'package:oyaridedriver/UIScreens/licence_details_screens.dart';
import 'package:oyaridedriver/UIScreens/map_screen.dart';
import 'package:oyaridedriver/UIScreens/payment_history_screen.dart';
import 'package:oyaridedriver/UIScreens/settings_screen.dart';
import 'package:oyaridedriver/UIScreens/vehicle_management_screen.dart';
import 'package:oyaridedriver/UIScreens/your_tripe_screen.dart';

import 'package:sized_context/src/extensions.dart';

import 'document_management_screen.dart';
import 'edit_profile_screen.dart';
import 'help_screen.dart';
// ignore_for_file: prefer_const_constructors

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
   List<DrawerItems> drawerList = [
    DrawerItems(
        0, ImageAssets.paymentIcon, "Home", MapHomeScreen()),

    DrawerItems(2, ImageAssets.yourTripeIcon, "Your Trip", YourTripScreen()),
    DrawerItems(3, ImageAssets.yourTripeIcon, "Vehicle Management",
        VehicleManagementScreen()),
    DrawerItems(4, ImageAssets.yourTripeIcon, "Document Management",
        DocumentManagementScreen(true)),
    DrawerItems(5, ImageAssets.chatIcon, "Message", ChatScreen()),
    DrawerItems(6, ImageAssets.settingIcon, "Settings", SettingScreen()),
    DrawerItems(8, ImageAssets.logoutIcon, "Logout",  Container()),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
                  CircleAvatar(
                    backgroundImage: NetworkImage(imgUrl),
                    radius: 28,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  textWidget(
                      txt: "Bernard Alverdaro",
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
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      child: ListView.builder(
          itemCount: drawerList.length,
          itemBuilder: (context, index) {
            return ListTile(
              //minVerticalPadding: 10,
              title: Text(
                drawerList[index].name,
                style: TextStyle(
                    color: AllColors.whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              leading: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Image.asset(
                  drawerList[index].iconData,
                  color: AllColors.whiteColor,
                  scale: 5,
                ),
              ),
              onTap: () {
                Get.offAll(() => drawerList[index].screen);
              },
            );
          }),
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
}

class DrawerItems {
  late int id;
  late String iconData;
  late String name;
  Widget screen;

  DrawerItems(this.id, this.iconData, this.name, this.screen);
}
