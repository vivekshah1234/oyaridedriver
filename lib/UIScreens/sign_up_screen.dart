import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/image_assets.dart';
import 'package:oyaridedriver/UIScreens/personal_info_screen.dart';
import 'package:sized_context/src/extensions.dart';
import 'package:sized_context/sized_context.dart';

import 'otp_screen.dart';

// ignore_for_file: prefer_const_constructors
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPwd = TextEditingController();
  TextEditingController txtNum = TextEditingController();
  double mediumFontSize=15.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget2(""),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: context.heightPct(.02),
          ),
          Center(
            child: textWidget(
                txt: "Sign Up",
                fontSize: 32,
                color: AllColors.greenColor,
                bold: true,
                italic: false),
          ),
          SizedBox(
            height: context.heightPct(.015),
          ),
          Center(
            child: textWidget(
                txt: "Earn More with your Vehicle",
                fontSize: 18,
                color: AllColors.blackColor,
                bold: true,
                italic: false),
          ),
          SizedBox(
            height: context.heightPct(.10),
          ),
          Expanded(child: signUpForm())
        ],
      ),
    );
  }

  Widget signUpForm() {
    return Container(
      //height: double.infinity,
      decoration: BoxDecoration(
          color: AllColors.greenColor,
          borderRadius:  BorderRadius.only(
              topRight: Radius.circular(40), topLeft: Radius.circular(40))),
      padding:  EdgeInsets.only(top: 50, bottom: 0, left: 25, right: 25),
      child: SingleChildScrollView(
        child: Column(
          children: [

            textFieldForNum(
                controller: txtNum,
                labelText: "Phone Number",
                prefixIcon: ImageAssets.phoneIcon),
            const SizedBox(
              height: 25,
            ),
            textField(
                controller: txtPwd,
                prefixIcon: ImageAssets.passwordIcon,
                labelText: "Password",
                errorText: "Please enter the password"),
            SizedBox(
              height: context.heightPct(.07),
            ),
            nextButton(),
            SizedBox(
              height: context.heightPct(.07),
            ),
            textWidget(
                txt: "By signing up, you accept our Terms of ",
                fontSize: mediumFontSize,
                color: AllColors.whiteColor,
                italic: false,
                bold: false),
            textWidget(
                txt: "Services and Privacy Policy.",
                fontSize: mediumFontSize,
                color: AllColors.whiteColor,
                italic: false,
                bold: false),
          ],
        ),
      ),
    );
  }

  Widget nextButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 45, right: 45),
      child: ElevatedButton(
        onPressed: () {
          Get.to(() => const PersonalInfoScreen());
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(AllColors.blueColor),
            shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
              return RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25));
            }),
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.only(top: 10, bottom: 10))),
        child: const Text(
          "NEXT",
          style: TextStyle(
              color: AllColors.whiteColor,
              fontSize: 17,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget textField({controller, labelText, errorText, prefixIcon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Image.asset(
          prefixIcon,
          scale: 10,
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller,
                cursorColor: AllColors.whiteColor,
                style: TextStyle(color: AllColors.whiteColor),
                decoration: InputDecoration(
                  labelText: labelText,
                  labelStyle:  TextStyle(
                      color: AllColors.whiteColor, fontSize: mediumFontSize),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AllColors.whiteColor),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AllColors.whiteColor),
                  ),
                  disabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AllColors.whiteColor),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AllColors.whiteColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String countryCode = "+39";

  Widget textFieldForNum({controller, labelText, errorText, prefixIcon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Image.asset(
              prefixIcon,
              scale: 10,
            ),
            const SizedBox(
              width: 8,
            ),
            pickCountry(),
          ],
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: controller,
                  cursorColor: AllColors.whiteColor,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: AllColors.whiteColor),
                  decoration: InputDecoration(
                    labelText: labelText,
                    labelStyle:  TextStyle(
                        color: AllColors.whiteColor, fontSize: mediumFontSize),
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AllColors.whiteColor),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AllColors.whiteColor),
                    ),
                    disabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AllColors.whiteColor),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AllColors.whiteColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget pickCountry() {
    return CountryListPick(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          title: const Text('Select your country code'),
        ),
        pickerBuilder: (context, CountryCode? countryCode) {
          return Container(
            decoration: const BoxDecoration(
                border: Border(
              bottom: BorderSide(color: Colors.white),
            )),
            child: Row(
              children: [
                Text(
                  countryCode!.dialCode.toString(),
                  style:  TextStyle(color: AllColors.whiteColor,fontSize: mediumFontSize),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AllColors.whiteColor,
                )
                //  Text("countryCode.dialCode"),
              ],
            ),
          );
        },

        // To disable option set to false
        theme: CountryTheme(
          isShowFlag: true,
          isShowTitle: true,
          isShowCode: true,
          isDownIcon: true,
          showEnglishName: true,
        ),

        // Set default value
        initialSelection: '+62',
        // or
        // initialSelection: 'US'
        onChanged: (CountryCode? code) {
          // print(code!.name);
          // print(code.code);
          // print(code.dialCode);
          // print(code.flagUri);
          countryCode = code!.dialCode.toString();
          setState(() {});
        },
        // Whether to allow the widget to set a custom UI overlay
        useUiOverlay: true,
        // Whether the country list should be wrapped in a SafeArea
        useSafeArea: false);
  }
}