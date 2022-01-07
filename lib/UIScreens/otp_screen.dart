import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/UIScreens/personal_info_screen.dart';
// ignore_for_file: prefer_const_constructors
class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key}) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

  var pin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        OTPTextField(
          length: 4,
          width: MediaQuery.of(context).size.width,
          fieldWidth: 50,
          style: TextStyle(
              fontSize: 17
          ),
          textFieldAlignment: MainAxisAlignment.spaceAround,
          fieldStyle: FieldStyle.box,
          otpFieldStyle: OtpFieldStyle( borderColor:AllColors.blueColor,enabledBorderColor: AllColors.blueColor,focusBorderColor: AllColors.blueColor, ),
          onChanged: (pin) {
          },
          onCompleted: (pin2) {
            pin=pin2;
            setState(() {

            });
          },
        ),
        SizedBox(height: 40,),
        nextButton()
      ],),
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
          "SUBMIT",
          style: TextStyle(
              color: AllColors.whiteColor,
              fontSize: 17,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

}
