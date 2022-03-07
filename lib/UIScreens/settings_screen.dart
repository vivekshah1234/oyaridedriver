import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/UIScreens/authScreens/change_password_screen.dart';

import 'drawer_screen.dart';
import 'authScreens/edit_profile_screen.dart';
import 'help_center_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarWidget("Settings", _scaffoldKey),
      drawer: const DrawerScreen(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 20, bottom: 20),
            child: GestureDetector(
              onTap: () {
                Get.to(() => const EditProfileScreen());
              },
              child: const SettingOptions("Edit Profile"),
            ),
          ),
          const Divider(
            color: AllColors.greyColor,
            height: 7,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 20, bottom: 20),
            child: GestureDetector(
                onTap: () {
                  Get.to(() => const ChangePasswordScreen());
                },
                child: const SettingOptions("Change Password")),
          ),
          const Divider(
            color: AllColors.greyColor,
            height: 7,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 20, bottom: 20),
            child: GestureDetector(
                onTap: () {
                  Get.to(() => const EditProfileScreen());
                },
                child: const SettingOptions("Terms and Conditions")),
          ),
          const Divider(
            color: AllColors.greyColor,
            height: 7,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 20, bottom: 20),
            child: GestureDetector(
                onTap: () {
                  Get.to(() => const HelpCenterScreen());
                },
                child: const SettingOptions("Help")),
          ),
        ],
      ),
    );
  }
}

class SettingOptions extends StatelessWidget {
  final String title;

  const SettingOptions(this.title);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        textWidget(txt: title, fontSize: 16, color: AllColors.greenColor, bold: FontWeight.w600, italic: false),
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: Icon(
            Icons.arrow_forward_ios,
            color: AllColors.greenColor,
          ),
        ),
      ],
    );
  }
}
