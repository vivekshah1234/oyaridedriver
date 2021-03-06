import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oyaridedriver/Common/allString.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_methods.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/extension_widgets.dart';
import 'package:oyaridedriver/controllers/forget_password_controller.dart';
import 'package:sized_context/src/extensions.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _txtEmailId = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ForgotPasswordController forgetPasswordController = Get.put(ForgotPasswordController());
  TextEditingController txtResetCode = TextEditingController();
  TextEditingController txtNewPwd = TextEditingController();
  TextEditingController txtNewRPwd = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarWidget2(""),
      body: GetX<ForgotPasswordController>(
          init: ForgotPasswordController(),
          builder: (controller) {
            return Stack(
              children: [
                Column(
                  //  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: context.heightPct(.13),
                    ),
                    textWidget(
                        txt: "Forget Password",
                        fontSize: 25,
                        color: AllColors.blackColor,
                        bold: FontWeight.w600,
                        italic: false),
                    const SizedBox(
                      height: 20,
                    ),
                    textFieldWithoutIcon(
                        controller: _txtEmailId, labelText: "Email id", errorText: "Please enter Email id."),
                    const Text(
                      "Please enter your email abov to receiver your password reset instruction.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AllColors.greyColor, fontSize: 13),
                    ).putPadding(5, 3, 5, 5),
                    SizedBox(
                      height: context.heightPct(0.1),
                    ),
                    AppButton(
                        text: "SEND MAIL",
                        onPressed: () {
                          bool isValid = isValidEmail(_txtEmailId.text);
                          if (isValid) {
                            forgetPasswordController.sendEmail(_txtEmailId.text, context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(greenSnackBar("Please enter valid Email."));
                          }
                          //Get.to(()=> ChangePasswordScreen());
                        },
                        color: AllColors.greenColor),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ).putPadding(0, 0, 30, 30),
                Visibility(visible: controller.isLoading.value, child: greenLoadingWidget())
              ],
            );
          }),
    );
  }
}
