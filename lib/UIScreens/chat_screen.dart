import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/image_assets.dart';

import 'drawer_screen.dart';
// ignore_for_file: prefer_const_constructors
class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  double mediumFont = 15.0;
  double smallFont = 12.0;
  TextEditingController txtSearch = TextEditingController();
  final border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(
        color: Colors.transparent,
      ));

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarWidget("Message", _scaffoldKey),
      drawer: DrawerScreen(),
      body: Column(
        children: [
          searchTextField().paddingSymmetric(horizontal: 25, vertical: 15),
          Expanded(child: MessageList())
        ],
      ),
    );
  }

  Widget MessageList() {
    return ListView.builder(
        itemCount: 5,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
                border:
                Border(bottom: BorderSide(color: Colors.grey.shade300))),
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(imgUrl),
                        radius: 24,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textWidget(
                            txt: "Robin Banks",
                            fontSize: mediumFont,
                            color: AllColors.blackColor,
                            bold: FontWeight.w700,
                          ),
                          textWidget(
                            txt: "Hey",
                            fontSize: smallFont,
                            color: AllColors.blackColor,
                            bold: FontWeight.normal,
                          ),
                        ],
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: AllColors.greenColor,
                    radius: 10,
                  )
                ],
              ),
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
            suffixIcon: Icon(Icons.search,color: Colors.grey.shade300,),
            hintStyle: TextStyle(
                fontSize: mediumFont,
                fontWeight: FontWeight.w600,
                color: AllColors.blackColor)),
      ),
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
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: bold,
      ),
    );
  }


}
