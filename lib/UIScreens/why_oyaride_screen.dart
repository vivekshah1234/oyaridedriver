import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/image_assets.dart';

class WhyOyaRideScreen extends StatefulWidget {
  const WhyOyaRideScreen({Key? key}) : super(key: key);

  @override
  _WhyOyaRideScreenState createState() => _WhyOyaRideScreenState();
}

class _WhyOyaRideScreenState extends State<WhyOyaRideScreen> {
  final double _bigFontSize = 28.0;
  final double _mediumFontSize = 21.0;

  final FontWeight _bold1 = FontWeight.w800;
  final FontWeight _bold3 = FontWeight.normal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          children: [
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
          ],
        ).paddingSymmetric(horizontal: 25));
  }

  Widget whyOyaRide() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        textWidget(
          txt: "Why ",
          fontSize: _bigFontSize,
          color: AllColors.blueColor,
          bold: _bold1,
        ),
        textWidget(
          txt: "Oyaride?",
          fontSize: _bigFontSize,
          color: AllColors.greenColor,
          bold: _bold1,
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
          fontSize: _bigFontSize,
          color: AllColors.greenColor,
          bold: _bold1,
        ),
        textWidget(
          txt: "Make more with Oyaride",
          fontSize: _mediumFontSize,
          color: AllColors.blackColor,
          bold: _bold3,
        ),
      ],
    );
  }

  Widget setHours() {
    return Column(
      children: [
        textWidget(
          txt: "Set your hours",
          fontSize: _bigFontSize,
          color: AllColors.greenColor,
          bold: _bold1,
        ),
        textWidget(
          txt: "Work with your own schedule",
          fontSize: _mediumFontSize,
          color: AllColors.blackColor,
          bold: _bold3,
        ),
        textWidget(
          txt: "no minimum hours and no boss.",
          fontSize: _mediumFontSize,
          color: AllColors.blackColor,
          bold: _bold3,
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
          fontSize: _bigFontSize,
          color: AllColors.greenColor,
          bold: _bold1,
        ),
        textWidget(
          txt: "No risk, you only pay",
          fontSize: _mediumFontSize,
          color: AllColors.blackColor,
          bold: _bold3,
        ),
        textWidget(
          txt: "when you earn.",
          fontSize: _mediumFontSize,
          color: AllColors.blackColor,
          bold: _bold3,
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
