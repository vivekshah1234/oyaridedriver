import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/image_assets.dart';

import 'drawer_screen.dart';

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
  final border = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(
        color: Colors.transparent,
      ));

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarWidget("Message", _scaffoldKey),
      drawer: const DrawerScreen(),
      body: Column(
        children: [
          searchTextField().paddingSymmetric(horizontal: 25, vertical: 15),
          Expanded(child: messageUserList())
        ],
      ),
    );
  }

  Widget messageUserList() {
    return ListView.builder(
        itemCount: 5,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(imgUrl),
                        radius: 24,
                      ),
                      const SizedBox(
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
                            italic: false,
                          ),
                          textWidget(
                            txt: "Hey",
                            fontSize: smallFont,
                            color: AllColors.blackColor,
                            bold: FontWeight.normal,
                            italic: false,
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
            offset: const Offset(0, 3), // changes position of shadow
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
            suffixIcon: Icon(
              Icons.search,
              color: Colors.grey.shade300,
            ),
            hintStyle: TextStyle(fontSize: mediumFont, fontWeight: FontWeight.w600, color: AllColors.blackColor)),
      ),
    );
  }
}
