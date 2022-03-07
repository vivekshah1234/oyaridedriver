import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/image_assets.dart';
import 'package:oyaridedriver/controllers/check_verification_controller.dart';

class DocumentSentScreen extends StatefulWidget {
  const DocumentSentScreen({Key? key}) : super(key: key);

  @override
  _DocumentSentScreenState createState() => _DocumentSentScreenState();
}

class _DocumentSentScreenState extends State<DocumentSentScreen> {

  CheckVerificationController checkVerificationController=Get.put(CheckVerificationController());
  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              ImageAssets.documentSentICon,
              scale: 10,
            ),
            const SizedBox(
              height: 25,
            ),
            textWidget(
                txt: "Documents", fontSize: 35, color: AllColors.blackColor, bold: FontWeight.w600, italic: false),
            textWidget(
                txt: "has sent", fontSize: 35, color: AllColors.blackColor, bold: FontWeight.w600, italic: false),
          ],
        ),
      ),
    );
  }
}
