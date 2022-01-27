import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oyaridedriver/Common/allString.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/image_assets.dart';
import 'package:oyaridedriver/UIScreens/forgot_password_screen.dart';
import 'package:oyaridedriver/UIScreens/rider_cart_screen.dart';
import 'package:oyaridedriver/UIScreens/sign_up_screen.dart';
import 'package:oyaridedriver/controllers/login_controller.dart';
import 'package:sized_context/src/extensions.dart';
import 'package:sized_context/sized_context.dart';

import 'map_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPwd = TextEditingController();
  TextEditingController txtNum = TextEditingController();
  double mediumFontSize = 15.0;
  LoginController loginController = Get.put(LoginController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget2(""),
      body: GetX<LoginController>(
          init: LoginController(),
          builder: (controller) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: context.heightPct(.02),
                    ),
                    Center(
                        child: Image.asset(
                      ImageAssets.oyaRideIcon,
                      scale: 9,
                    )),
                    SizedBox(
                      height: context.heightPct(.10),
                    ),
                    Expanded(
                        child: Form(
                      key: formKey,
                      child: Container(
                        //height: double.infinity,
                        decoration: BoxDecoration(
                            color: AllColors.greenColor,
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(40),
                                topLeft: Radius.circular(40))),
                        padding: const EdgeInsets.only(
                            top: 50, bottom: 0, left: 25, right: 25),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const Text(
                                "Welcome!",
                                style: TextStyle(
                                    fontSize: 27,
                                    color: AllColors.whiteColor,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              textFieldForNum(
                                  controller: txtNum,
                                  labelText: "Phone Number",
                                  errorText: ErrorMessage.numberError,
                                  prefixIcon: ImageAssets.phoneIcon),
                              const SizedBox(
                                height: 25,
                              ),
                              textField(
                                  controller: txtPwd,
                                  prefixIcon: ImageAssets.passwordIcon,
                                  errorText: ErrorMessage.passwordError,
                                  labelText: "Password"),
                              SizedBox(
                                height: context.heightPct(.04),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Get.to(() => const ForgotPasswordScreen());
                                  },
                                  child: textWidget(
                                      txt: "Forget Password ?",
                                      fontSize: mediumFontSize,
                                      color: AllColors.whiteColor,
                                      italic: false,
                                      bold: FontWeight.normal)),
                              SizedBox(
                                height: context.heightPct(.02),
                              ),
                              AppButton(
                                      onPressed: login,
                                      text: "LOGIN",
                                      color: AllColors.blueColor)
                                  .paddingSymmetric(horizontal: 45),
                              SizedBox(
                                height: context.heightPct(.02),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  textWidget(
                                      txt: "Need to create an account? ",
                                      fontSize: mediumFontSize,
                                      color: AllColors.whiteColor,
                                      italic: false,
                                      bold: FontWeight.normal),
                                  Expanded(
                                    child: GestureDetector(
                                        onTap: () {
                                          Get.to(() => const SignUpScreen());
                                        },
                                        child: Text("Register Here",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: mediumFontSize,
                                              color: AllColors.blueColor,
                                            ))),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: context.heightPct(.02),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ))
                  ],
                ),
                Visibility(
                    visible: controller.isLoading.value,
                    child: whiteLoadingWidget())
              ],
            );
          }),
    );
  }

  login() {
    if (formKey.currentState!.validate()) {
      Map<String, String> _map = {
        "mobile_number": txtNum.text.toString(),
        "country_code": countryCode.toString(),
        "password": txtPwd.text.toString(),
        "role": "driver"
      };

      loginController.login(_map, context);
    }
  }

  bool showPassWord = true;

  Widget textField({controller, labelText, errorText, prefixIcon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Image.asset(
          prefixIcon,
          scale: 8,
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: controller,
                cursorColor: AllColors.whiteColor,
                validator: (value) {
                  if (value!.isEmpty) {
                    return errorText;
                  }
                  return null;
                },
                style: TextStyle(color: AllColors.whiteColor),
                obscureText: showPassWord ? true : false,
                decoration: InputDecoration(
                  labelText: labelText,
                  suffixIcon: GestureDetector(
                      onTap: () {
                        showPassWord = !showPassWord;
                        setState(() {});
                      },
                      child: !showPassWord
                          ? const Icon(
                              Icons.visibility,
                              color: AllColors.whiteColor,
                            )
                          : const Icon(
                              Icons.visibility_off,
                              color: AllColors.whiteColor,
                            )),
                  labelStyle: TextStyle(
                      color: AllColors.whiteColor, fontSize: mediumFontSize),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AllColors.whiteColor),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AllColors.whiteColor),
                  ),
                  disabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AllColors.whiteColor),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AllColors.whiteColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String countryCode = "+39";

  Widget textFieldForNum({controller, labelText, errorText, prefixIcon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Image.asset(
              prefixIcon,
              scale: 8,
            ),
            const SizedBox(
              width: 3,
            ),
            pickCountry(),
          ],
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: controller,
                  cursorColor: AllColors.whiteColor,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return errorText;
                    }
                    return null;
                  },
                  style: TextStyle(color: AllColors.whiteColor),
                  decoration: InputDecoration(
                    labelText: labelText,
                    labelStyle: TextStyle(
                        color: AllColors.whiteColor, fontSize: mediumFontSize),
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AllColors.whiteColor),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AllColors.whiteColor),
                    ),
                    disabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AllColors.whiteColor),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AllColors.whiteColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget pickCountry() {
    return CountryListPick(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          title: const Text('Select your country code'),
        ),
        pickerBuilder: (context, CountryCode? countryCode) {
          return Container(
            decoration: const BoxDecoration(
                border: Border(
              bottom: BorderSide(color: Colors.white),
            )),
            child: Row(
              children: [
                Text(
                  countryCode!.dialCode.toString(),
                  style: TextStyle(
                      color: AllColors.whiteColor, fontSize: mediumFontSize),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AllColors.whiteColor,
                )
                //  Text("countryCode.dialCode"),
              ],
            ),
          );
        },

        // To disable option set to false
        theme: CountryTheme(
          isShowFlag: true,
          isShowTitle: true,
          isShowCode: true,
          isDownIcon: true,
          showEnglishName: true,
        ),

        // Set default value
        initialSelection: countryCode,
        // or
        // initialSelection: 'US'
        onChanged: (CountryCode? code) {
          // print(code!.name);
          // print(code.code);
          // print(code.dialCode);
          // print(code.flagUri);
          countryCode = code!.dialCode.toString();
          setState(() {});
        },
        // Whether to allow the widget to set a custom UI overlay
        useUiOverlay: true,
        // Whether the country list should be wrapped in a SafeArea
        useSafeArea: false);
  }
}
