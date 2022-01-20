import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/image_assets.dart';
import 'package:oyaridedriver/UIScreens/login_screen.dart';
import 'package:oyaridedriver/UIScreens/rider_cart_screen.dart';
import 'package:oyaridedriver/UIScreens/sign_up_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Expanded(flex: 2,child: Container(),),
          Center(
              child: Image.asset(
            ImageAssets.oyaRideIcon,
            scale: 9,
          )),
          Expanded(flex: 1,child: Container(),),

          driverText(),
          Expanded(flex: 3,child: Container(),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            textWidget(txt: "Earn More,", fontSize: 22, color: AllColors.blackColor,
                bold: true,italic: false),
            textWidget(txt: " when you", fontSize: 22, color: AllColors.blackColor,
                bold: false,italic: true)
          ],),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textWidget(txt: "drive with ", fontSize: 22, color: AllColors.blackColor,
                  bold: false,italic: true),
              textWidget(txt: "Oyaride", fontSize: 22, color: AllColors.blackColor,
                  bold: true,italic: false)
            ],),
          Expanded(flex: 4,child: Container(),),
          AppButton(text: "LOGIN",onPressed:  (){
            Get.to(()=>  const LoginScreen());


          },color: AllColors.greenColor).paddingOnly(left:40,right: 40),
          Expanded(flex: 4,child: Container(),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textWidget(txt: "Need to create an account?", fontSize: 15, color: AllColors.blackColor
                  , bold: false, italic: false),
              GestureDetector(
                onTap: (){
                  Get.to(()=>  SignUpScreen());

                },
                child: textWidget(txt: " Register Here", fontSize: 15, color: AllColors.greenColor
                    , bold: false, italic: false),
              )
            ],
          ),
          Expanded(flex: 2,child: Container(),),
        ],
      ),
    );
  }

  Widget driverText() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: AllColors.greenColor, width: 1),
          borderRadius: BorderRadius.circular(25)),
      padding: const EdgeInsets.symmetric(horizontal: 37, vertical: 5),
      child: Text(
        "DRIVER",
        style: TextStyle(
            color: AllColors.greenColor,
            fontSize: 30,
            fontWeight: FontWeight.w900),
      ),
    );
  }
}
