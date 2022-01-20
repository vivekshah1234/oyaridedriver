import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/extension_widgets.dart';
import 'package:oyaridedriver/UIScreens/change_password_screen.dart';
import 'package:oyaridedriver/UIScreens/rider_cart_screen.dart';
import 'package:sized_context/src/extensions.dart';
// ignore_for_file: prefer_const_constructors
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
              txt: "Forget Password",
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
          const Text(
            "Please enter your email abov to receiver your password reset instruction.",
            textAlign: TextAlign.center,
            style: TextStyle(color: AllColors.greyColor, fontSize: 13),
          ).putPadding(5, 3, 5, 5),

          SizedBox(
            height: context.heightPct(0.1),
          ),
          AppButton(text: "SEND MAIL", onPressed:  () {
            //Get.to(()=> ChangePasswordScreen());
          },color: AllColors.greenColor),
          SizedBox(
            height: 40,
          ),
        ],
      ).putPadding(0, 0, 30, 30),
    );
  }
}
