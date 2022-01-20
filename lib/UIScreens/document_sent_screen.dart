import 'package:flutter/material.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/image_assets.dart';
// ignore_for_file: prefer_const_constructors


class DocumentSentScreen extends StatefulWidget {
  const DocumentSentScreen({Key? key}) : super(key: key);

  @override
  _DocumentSentScreenState createState() => _DocumentSentScreenState();
}

class _DocumentSentScreenState extends State<DocumentSentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [

          Image.asset(ImageAssets.documentSentICon,scale: 10,),
          const SizedBox(height: 25,),
          textWidget(txt: "Documents", fontSize: 35, color: AllColors.blackColor,
              bold: FontWeight.w600, italic: false),
          textWidget(txt: "has sent", fontSize: 35, color: AllColors.blackColor,
              bold: FontWeight.w600, italic: false),
        ],),
      ),

    );
  }
}
