import 'package:flutter/material.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AllColors.whiteColor,
      appBar: appBarWidget2(
        "Help Center",
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0,right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Email",
                  style: TextStyle(color: AllColors.greenColor, fontSize: 18),
                ),
                Text(
                  "info@oyaride.com",
                  style: TextStyle(color: AllColors.blueColor, fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Fb",
                  style: TextStyle(color: AllColors.greenColor, fontSize: 18),
                ),
                Text(
                  "oyaride.ng",
                  style: TextStyle(color: AllColors.blueColor, fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "IG",
                  style: TextStyle(color: AllColors.greenColor, fontSize: 18),
                ),
                Text(
                  "Oyaride.ng",
                  style: TextStyle(color: AllColors.blueColor, fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Twitter",
                  style: TextStyle(color: AllColors.greenColor, fontSize: 18),
                ),
                Text(
                  "Oyaride.ng",
                  style: TextStyle(color: AllColors.blueColor, fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Customer support line",
                  style: TextStyle(color: AllColors.greenColor, fontSize: 18),
                ),
                Text(
                  "+2348052203828",
                  style: TextStyle(color: AllColors.blueColor, fontSize: 15),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
