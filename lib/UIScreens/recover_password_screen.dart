import 'package:flutter/material.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';

import 'package:oyaridedriver/Common/extension_widgets.dart';
import 'package:sized_context/src/extensions.dart';

class RecoverPasswordScreen extends StatefulWidget {
  const RecoverPasswordScreen({Key? key}) : super(key: key);

  @override
  _RecoverPasswordScreenState createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen> {
  TextEditingController txtResetCode = TextEditingController();
  TextEditingController txtNewPwd = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey =  GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey ,
      appBar: appBarWidget2(""),
      body: Column(
      //  mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: context.heightPct(.13),
          ),
          textWidget(
              txt: "Recover Password",
              fontSize: 25,
              color: AllColors.blackColor,
              bold: FontWeight.w600,
              italic: false),
          SizedBox(
            height: 20,
          ),
          textFieldWithoutIcon(
              controller: txtResetCode,
              labelText: "Reset Code",
              errorText: "Please enter reset code."),
          const Text(
            "Reset code was sent to your email. Please enter the code and create new password.",
            textAlign: TextAlign.center,
            style: TextStyle(color: AllColors.greyColor, fontSize: 13),
          ).putPadding(5, 3, 5, 5),
          textFieldWithoutIcon(
              controller: txtNewPwd,
              labelText: "New Password",
              errorText: "Please enter new password."),
          SizedBox(
            height: 40,
          ),
          AppButton(text: "CHANGE PASSWORD", onPressed: () {},color: AllColors.greenColor),
          SizedBox(
            height: 40,
          ),
        ],
      ).putPadding(0, 0, 30, 30),
    );
  }
}
