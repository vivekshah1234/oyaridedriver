import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_methods.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';

import 'package:oyaridedriver/Common/extension_widgets.dart';
import 'package:oyaridedriver/controllers/recoverPasswordController.dart';
import 'package:sized_context/src/extensions.dart';

class RecoverPasswordScreen extends StatefulWidget {
  final String email;

  const RecoverPasswordScreen({required this.email});

  @override
  _RecoverPasswordScreenState createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen> {
  TextEditingController txtResetCode = TextEditingController();
  TextEditingController txtNewPwd = TextEditingController();
  TextEditingController txtNewRPwd = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  RecoverPasswordController recoverPasswordController = Get.put(RecoverPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget2(""),
        body: GetX<RecoverPasswordController>(
            init: RecoverPasswordController(),
            builder: (controller) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        //  mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: context.heightPct(.13),
                          ),
                          textWidget(
                              txt: "Recover Password",
                              fontSize: 25,
                              color: AllColors.blackColor,
                              bold: FontWeight.bold,
                              italic: false),
                          const SizedBox(
                            height: 20,
                          ),
                          textFieldWithoutIcon(
                              controller: txtResetCode, labelText: "Reset Code", errorText: "Please enter reset code."),
                          const Text(
                            "Reset code was sent to your email. Please enter the code and create new password.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AllColors.greyColor, fontSize: 13),
                          ).putPadding(5, 3, 5, 5),
                          textFieldWithoutIcon(
                              controller: txtNewPwd,
                              labelText: "New Password",
                              errorText: "Please enter new password."),
                          textFieldWithoutIcon(
                              controller: txtNewRPwd,
                              labelText: "Re-Enter new Password",
                              errorText: "Please enter re-enter new password."),
                          const SizedBox(
                            height: 40,
                          ),
                          AppButton(text: "CHANGE PASSWORD", color: AllColors.greenColor, onPressed: () {}),
                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      ).putPadding(0, 0, 30, 30),
                    ),
                  ),
                  Visibility(visible: controller.isLoading.value, child: greenLoadingWidget())
                ],
              );
            }));
  }

  void changePWD() {
    bool isValidPwd = isValidPassword(txtNewPwd.text);
    if (formKey.currentState!.validate()) {
      if (isValidPwd) {
        if (txtNewPwd.text == txtNewRPwd.text) {
          recoverPasswordController.changePassword(txtResetCode.text, widget.email, txtNewPwd.text, context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(greenSnackBar("Password and Confirm Password should match."));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            greenSnackBar("The Password must contain at least 1 lowercase,uppercase,numeric,special character."));
      }
    }
  }
}
