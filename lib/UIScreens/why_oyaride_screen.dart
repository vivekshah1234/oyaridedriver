import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/image_assets.dart';

class WhyOyaRideScren extends StatefulWidget {
  const WhyOyaRideScren({Key? key}) : super(key: key);

  @override
  _WhyOyaRideScrenState createState() => _WhyOyaRideScrenState();
}

class _WhyOyaRideScrenState extends State<WhyOyaRideScren> {
  double bigFontSize = 28.0;
  double mediumFontSize = 21.0;

  FontWeight bold1 = FontWeight.w800;
  FontWeight bold2 = FontWeight.w600;
  FontWeight bold3 = FontWeight.normal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(children: [
        whyOyaRide(),
        Expanded(
          flex: 2,
          child: Container(),
        ),
        makeMoney(),
        Expanded(
          flex: 3,
          child: Container(),
        ),
        setHours(),
        Expanded(
          flex: 3,
          child: Container(),
        ),
        noFees(),
        Expanded(
          flex: 4,
          child: Container(),
        ),
      ],).paddingSymmetric(horizontal: 25)
    );
  }

  Widget whyOyaRide(){
    return   Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        textWidget(
          txt: "Why ",
          fontSize: bigFontSize,
          color: AllColors.blueColor,
          bold: bold1,
        ),
        textWidget(
          txt: "Oyaride?",
          fontSize: bigFontSize,
          color: AllColors.greenColor,
          bold: bold1,
        )
      ],
    );
  }
  Widget makeMoney() {
    return Column(
      children: [

        Image.asset(
          ImageAssets.makeMoneyIcon,
          scale: 7,
        ),
        textWidget(
          txt: "Make Money",
          fontSize: bigFontSize,
          color: AllColors.greenColor,
          bold: bold1,
        ),
        textWidget(
          txt: "Make more with Oyaride",
          fontSize: mediumFontSize,
          color: AllColors.blackColor,
          bold: bold3,
        ),
      ],
    );
  }

  Widget setHours() {
    return Column(
      children: [

        textWidget(
          txt: "Set your hours",
          fontSize: bigFontSize,
          color: AllColors.greenColor,
          bold: bold1,
        ),
        textWidget(
          txt: "Work with your own schedule",
          fontSize: mediumFontSize,
          color: AllColors.blackColor,
          bold: bold3,
        ),
        textWidget(
          txt: "no minimum hours and no boss.",
          fontSize: mediumFontSize,
          color: AllColors.blackColor,
          bold: bold3,
        ),
      ],
    );
  }

  Widget noFees() {
    return Column(
      children: [
        Image.asset(
          ImageAssets.noFeesIcon,
          scale: 7,
        ),
        textWidget(
          txt: "No monthly fees",
          fontSize: bigFontSize,
          color: AllColors.greenColor,
          bold: bold1,
        ),
        textWidget(
          txt: "No risk, you only pay",
          fontSize: mediumFontSize,
          color: AllColors.blackColor,
          bold: bold3,
        ),
        textWidget(
          txt: "when you earn.",
          fontSize: mediumFontSize,
          color: AllColors.blackColor,
          bold: bold3,
        ),
      ],
    );
  }

  Widget textWidget({
    required String txt,
    required double fontSize,
    required Color color,
    required FontWeight bold,
  }) {
    return Text(
      txt,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: bold,
      ),
    );
  }
}
