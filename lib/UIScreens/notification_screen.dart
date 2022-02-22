// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/image_assets.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  double mediumFont = 15.0;
  double smallFont = 12.0;
  TextEditingController txtSearch=TextEditingController();
  final border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(
        color: Colors.transparent,
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget2("Notifications"),
      body: Column(
        children: [searchTextField(),
          SizedBox(height: 15,),
          Expanded(child: notificationList())
        ],
      ).paddingSymmetric(horizontal: 25),
    );
  }


  Widget notificationList(){
    return ListView.builder(
        itemCount: 3,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context,index){

          return Card(
            shadowColor:  Colors.grey.withOpacity(1),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(imgUrl,width: 55,height: 50,)),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      textWidget(txt: "Robin Banks", fontSize: mediumFont, color: AllColors.blackColor, bold: FontWeight.w700,),
                      textWidget(txt: "Received Payment", fontSize: smallFont, color: AllColors.blackColor, bold: FontWeight.normal,),
                    ],),
                  ],
                ),
                Column(children: [
                  CircleAvatar(backgroundColor: AllColors.greenColor,radius: 10,),
                  SizedBox(height: 10,),
                  textWidget(txt: "45 min ago", fontSize: smallFont, color: AllColors.greyColor, bold: FontWeight.normal,),
                ],)

              ],),
            ),

          );

        });
  }

  Widget searchTextField() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      height: 45,
      child: TextField(
        controller: txtSearch,
        decoration: InputDecoration(
            hintText: "Search",
            filled: true,
            fillColor: Colors.white,
            focusedBorder: border,
            enabledBorder: border,
            border: border,
            hintStyle: TextStyle(
                fontSize: mediumFont,
                fontWeight: FontWeight.w600,
                color: AllColors.blackColor)),
      ),
    );
  }
  Widget textWidget(
      {required String txt,
        required double fontSize,
        required Color color,
        required FontWeight bold,
       }) {
    return Text(
      txt,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: bold ,

      ),
    );
  }

}
