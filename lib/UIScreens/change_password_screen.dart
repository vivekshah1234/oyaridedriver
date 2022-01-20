import 'package:flutter/material.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/extension_widgets.dart';
import 'package:oyaridedriver/UIScreens/rider_cart_screen.dart';
import 'package:sized_context/src/extensions.dart';
// ignore_for_file: prefer_const_constructors


class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController txtEmailId = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey ,
      appBar: appBarWidget2(""),
      body: Column(
        //  mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: context.heightPct(.13),
          ),
          textWidget(
              txt: "Change Password",
              fontSize: 25,
              color: AllColors.blackColor,
              bold: true,
              italic: false),
          SizedBox(
            height: 20,
          ),
          textFieldWithoutIcon(
              controller: txtEmailId,
              labelText: "Email id",
              errorText: "Please enter Email id."),
           Text(
            "Please enter your email above to receiver your password reset instruction.",
            textAlign: TextAlign.center,
            style: TextStyle(color: AllColors.greyColor, fontSize: 13),
          ).putPadding(5, 3, 5, 5),

          SizedBox(
            height: context.heightPct(0.1),
          ),
          AppButton(text: "SEND MAIL", onPressed:  () {},color: AllColors.greenColor),
          SizedBox(
            height: 40,
          ),
        ],
      ).putPadding(0, 0, 30, 30),
    );
  }
}
