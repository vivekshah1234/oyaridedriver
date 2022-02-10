import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:oyaridedriver/Common/allString.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/image_assets.dart';
import 'package:oyaridedriver/controllers/signup_controller.dart';
import 'package:sized_context/src/extensions.dart';
import 'package:sized_context/sized_context.dart';

// ignore_for_file: prefer_const_constructors
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPwd = TextEditingController();
  TextEditingController txtNum = TextEditingController();
  double mediumFontSize = 15.0;

  SignUpController signUpController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget2(""),
      body: GetX<SignUpController>(
          init: SignUpController(),
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
                      child: textWidget(
                          txt: "Sign Up",
                          fontSize: 32,
                          color: AllColors.greenColor,
                          bold: FontWeight.w600,
                          italic: false),
                    ),
                    SizedBox(
                      height: context.heightPct(.015),
                    ),
                    Center(
                      child: textWidget(
                          txt: "Earn More with your Vehicle",
                          fontSize: 18,
                          color: AllColors.blackColor,
                          bold: FontWeight.w600,
                          italic: false),
                    ),
                    SizedBox(
                      height: context.heightPct(.10),
                    ),
                    Expanded(
                        child: Container(
                      //height: double.infinity,
                      decoration: BoxDecoration(
                          color: AllColors.greenColor,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(40), topLeft: Radius.circular(40))),
                      padding: EdgeInsets.only(top: 50, bottom: 0, left: 25, right: 25),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
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
                                labelText: "Password",
                                errorText: "Please enter the password"),
                            SizedBox(
                              height: context.heightPct(.07),
                            ),
                            AppButton(
                                    onPressed: () {
                                      if (txtNum.text.isNotEmpty) {
                                        if (txtPwd.text.isNotEmpty) {
                                          Map<String, String> map = {};
                                          map["country_code"] = countryCode.toString();
                                          map["mobile_number"] = txtNum.text.toString();
                                          map["password"] = txtPwd.text.toString();
                                          map["role"] = "driver";

                                          signUpController.register1(map, context);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(whiteSnackBar(ErrorMessage.passwordError));
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(whiteSnackBar(ErrorMessage.numberError));
                                      }
                                    },
                                    text: "NEXT",
                                    color: AllColors.blueColor)
                                .paddingSymmetric(horizontal: 45),
                            SizedBox(
                              height: context.heightPct(.07),
                            ),
                            textWidget(
                                txt: "By signing up, you accept our Terms of ",
                                fontSize: mediumFontSize,
                                color: AllColors.whiteColor,
                                italic: false,
                                bold: FontWeight.normal),
                            textWidget(
                                txt: "Services and Privacy Policy.",
                                fontSize: mediumFontSize,
                                color: AllColors.whiteColor,
                                italic: false,
                                bold: FontWeight.w600),
                          ],
                        ),
                      ),
                    ))
                  ],
                ),
                Visibility(visible: controller.isLoading.value, child: Center(child: whiteLoadingWidget()))
              ],
            );
          }),
    );
  }

  bool showPassWord = true;

  Widget textField({controller, labelText, errorText, prefixIcon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Image.asset(
          prefixIcon,
          scale: 10,
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller,
                cursorColor: AllColors.whiteColor,
                obscureText: showPassWord ? true : false,
                style: TextStyle(color: AllColors.whiteColor),
                decoration: InputDecoration(
                  labelText: labelText,
                  //123456 filled: true,
                  suffixIcon: GestureDetector(
                      onTap: () {
                        showPassWord = !showPassWord;
                        setState(() {});
                      },
                      child: !showPassWord
                          ? Icon(
                              Icons.visibility,
                              color: AllColors.whiteColor,
                            )
                          : Icon(
                              Icons.visibility_off,
                              color: AllColors.whiteColor,
                            )),
                  labelStyle: TextStyle(color: AllColors.whiteColor, fontSize: mediumFontSize),
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
              scale: 10,
            ),
            const SizedBox(
              width: 8,
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
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.deny(RegExp(" ")),
                    FilteringTextInputFormatter.deny(RegExp("[a-zA-Z]")),
                    FilteringTextInputFormatter.deny(RegExp("[.,-,`,=,/]")),
                  ],
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return errorText;
                    }
                    return null;
                  },
                  style: TextStyle(color: AllColors.whiteColor),
                  decoration: InputDecoration(
                    labelText: labelText,
                    labelStyle: TextStyle(color: AllColors.whiteColor, fontSize: mediumFontSize),
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
                  style: TextStyle(color: AllColors.whiteColor, fontSize: mediumFontSize),
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

          countryCode = code!.dialCode.toString();
          setState(() {});
        },
        // Whether to allow the widget to set a custom UI overlay
        useUiOverlay: true,
        // Whether the country list should be wrapped in a SafeArea
        useSafeArea: false);
  }
}
