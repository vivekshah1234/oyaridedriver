import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/extension_widgets.dart';
import 'package:oyaridedriver/controllers/changePasswordController.dart';
import 'package:sized_context/sized_context.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController currentPwd = TextEditingController();
  TextEditingController newPwd = TextEditingController();
  TextEditingController newCPwd = TextEditingController();
  ChangePasswordController changePasswordController = ChangePasswordController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    currentPwd.dispose();
    newCPwd.dispose();
    newPwd.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColors.whiteColor,
      appBar: appBarWidget2(""),
      body: GetX<ChangePasswordController>(
          init: ChangePasswordController(),
          builder: (controller) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      //  mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: context.heightPct(.13),
                        ),
                        textWidget(
                            txt: "Change Password",
                            fontSize: 25,
                            color: AllColors.blackColor,
                            bold: FontWeight.bold,
                            italic: false),
                        const SizedBox(
                          height: 20,
                        ),
                        textFieldForCurrentPWD(
                            controller: currentPwd, hintText: "Old password", errorMSG: "Please enter old password."),
                        textFieldForNewPWD(
                            controller: newPwd, hintText: "New Password", errorMSG: "Please enter new password."),
                        textFieldForNewCPWD(
                            controller: newCPwd,
                            hintText: "Re-Enter new Password",
                            errorMSG: "Please enter re-enter new password."),
                        const SizedBox(
                          height: 40,
                        ),
                        AppButton(text: "CHANGE PASSWORD", color: AllColors.greenColor, onPressed: changePasswordFunction),
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
          }),
    );
  }

  changePasswordFunction() {
    if (formKey.currentState!.validate()) {
      if (newPwd.text.trim() == newCPwd.text.trim()) {
        changePasswordController.changePassword(currentPwd.text.trim(), newPwd.text.trim(), context);

      } else {
        toast("New password and confirm password does not match.");
      }
    }
  }

  bool showPassWord = true;

  Widget textFieldForCurrentPWD({controller, hintText, errorMSG}) {
    return TextField(
      controller: controller,
      obscureText: showPassWord ? true : false,
      cursorColor: AllColors.blackColor,
      decoration: InputDecoration(
        labelText: hintText,
        suffixIcon: GestureDetector(
            onTap: () {
              showPassWord = !showPassWord;
              setState(() {});
            },
            child: showPassWord
                ? const Icon(
              Icons.visibility,
              color: AllColors.greyColor,
            )
                : const Icon(
              Icons.visibility_off,
              color: AllColors.greyColor,
            )),
        labelStyle: const TextStyle(color: AllColors.greyColor, fontSize: 13),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: AllColors.greyColor),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AllColors.greyColor),
        ),
        disabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AllColors.greyColor),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AllColors.greyColor),
        ),
      ),
    );
  }

  bool showPassWord2 = true;

  Widget textFieldForNewPWD({controller, hintText, errorMSG}) {
    return TextField(
      controller: controller,
      obscureText: showPassWord2 ? true : false,
      cursorColor: AllColors.blackColor,
      decoration: InputDecoration(
        labelText: hintText,
        suffixIcon: GestureDetector(
            onTap: () {
              showPassWord2 = !showPassWord2;
              setState(() {});
            },
            child: showPassWord2
                ? const Icon(
              Icons.visibility,
              color: AllColors.greyColor,
            )
                : const Icon(
              Icons.visibility_off,
              color: AllColors.greyColor,
            )),
        labelStyle: const TextStyle(color: AllColors.greyColor, fontSize: 13),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: AllColors.greyColor),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AllColors.greyColor),
        ),
        disabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AllColors.greyColor),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AllColors.greyColor),
        ),
      ),
    );
  }

  bool showPassWord3 = true;

  Widget textFieldForNewCPWD({controller, hintText, errorMSG}) {
    return TextField(
      controller: controller,
      cursorColor: AllColors.blackColor,
      obscureText: showPassWord3 ? true : false,
      decoration: InputDecoration(
        labelText: hintText,
        suffixIcon: GestureDetector(
            onTap: () {
              showPassWord3 = !showPassWord3;
              setState(() {});
            },
            child: showPassWord3
                ? const Icon(
              Icons.visibility,
              color: AllColors.greyColor,
            )
                : const Icon(
              Icons.visibility_off,
              color: AllColors.greyColor,
            )),
        labelStyle: const TextStyle(color: AllColors.greyColor, fontSize: 13),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: AllColors.greyColor),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AllColors.greyColor),
        ),
        disabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AllColors.greyColor),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AllColors.greyColor),
        ),
      ),
    );
  }
}
