import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/Common/allString.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_methods.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/image_assets.dart';
import 'package:oyaridedriver/UIScreens/search_city_screen.dart';
import 'package:oyaridedriver/controllers/signup_controller.dart';
import 'package:sized_context/src/extensions.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({Key? key}) : super(key: key);

  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  TextEditingController txtFName = TextEditingController();
  TextEditingController txtLName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtCity = TextEditingController();
  TextEditingController txtLanguage = TextEditingController();
  TextEditingController txtReferralCode = TextEditingController();
  TextEditingController txtVehicleMF = TextEditingController();
  TextEditingController txtVehicleModel = TextEditingController();
  TextEditingController txtVehicleYear = TextEditingController();
  TextEditingController txtLicensePlate = TextEditingController();
  TextEditingController txtVehicleColor = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SignUpController signUpController = Get.put(SignUpController());
  final formKey = GlobalKey<FormState>();
  double cityLatitude = 0.0, cityLongitude = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarWidget2(""),
      body: GetX<SignUpController>(
          init: SignUpController(),
          builder: (controller) {
            return Stack(
              alignment: Alignment.center,
              children: [
                SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: textWidget(
                              txt: "Personal information",
                              fontSize: 26,
                              color: AllColors.blackColor,
                              bold: FontWeight.w600,
                              italic: false),
                        ),
                        Center(
                          child: textWidget(
                              txt: "and vehicle details",
                              fontSize: 25,
                              color: AllColors.blackColor,
                              bold: FontWeight.w600,
                              italic: false),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: textWidget(
                              txt: "Only your first name and Vehicle",
                              fontSize: 16,
                              color: Colors.black54,
                              bold: FontWeight.normal,
                              italic: false),
                        ),
                        Center(
                          child: textWidget(
                              txt: "details  are visible to clients during booking.",
                              fontSize: 16,
                              color: Colors.black54,
                              bold: FontWeight.normal,
                              italic: false),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: textField(
                                        controller: txtFName,
                                        prefixIcon: ImageAssets.personIcon,
                                        errorText: ErrorMessage.fNameError,
                                        labelText: "First Name")),
                                const SizedBox(
                                  width: 7,
                                ),
                                Expanded(
                                    child: textFieldWithoutIcon(
                                        controller: txtLName,
                                        errorText: ErrorMessage.lNameError,
                                        labelText: "Last Name")),

                                // textField(controller: txtLName,prefixIcon: ""),
                              ],
                            ),
                            textField(
                                controller: txtEmail,
                                prefixIcon: ImageAssets.emailIcon,
                                errorText: ErrorMessage.emailError,
                                labelText: "Email"),
                            textFieldForCity(
                                controller: txtCity,
                                prefixIcon: ImageAssets.cityIcon,
                                errorText: ErrorMessage.cityError,
                                labelText: "City"),
                            Column(
                              children: [
                                referralCode(controller: txtReferralCode, labelText: "Referral code"),
                                textFieldWithoutIcon(
                                    controller: txtVehicleMF,
                                    errorText: ErrorMessage.vmanuFactureError,
                                    labelText: "Vehicle manufacturer"),
                                textFieldWithoutIcon(
                                    controller: txtVehicleModel,
                                    errorText: ErrorMessage.vModel,
                                    labelText: "Vehicle model"),
                                textFieldWithoutIcon(
                                    controller: txtVehicleYear,
                                    errorText: ErrorMessage.vYear,
                                    labelText: "Vehicle year"),
                                textFieldWithoutIcon(
                                    controller: txtLicensePlate,
                                    errorText: ErrorMessage.licencePlate,
                                    labelText: "License plate"),
                                textFieldWithoutIcon(
                                    controller: txtVehicleColor,
                                    errorText: ErrorMessage.vColor,
                                    labelText: "Vehicle color"),
                              ],
                            ).paddingOnly(bottom: 20, left: 25, right: 5),
                            AppButton(text: "NEXT", color: AllColors.greenColor, onPressed: registerPersonalInfo)
                                .paddingOnly(left: context.widthPct(.15), right: context.widthPct(.15)),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ).paddingAll(15)
                      ],
                    ),
                  ),
                ),
                Visibility(visible: controller.isLoading.value, child: Center(child: greenLoadingWidget()))
              ],
            );
          }),
    );
  }

  registerPersonalInfo() {
    if (formKey.currentState!.validate()) {
      bool isValid = isValidEmail(txtEmail.text);
      if (isValid) {
        Map<String, String> _map = {
          "id": AppConstants.userID,
          "first_name": txtFName.text.toString(),
          "last_name": txtLName.text.toString(),
          "email": txtEmail.text.toString(),
          "city": txtCity.text.toString(),
          "language": "english",
          "referral_code": txtReferralCode.text.isNotEmpty ? txtReferralCode.text : "referralCode",
          "vehicle_manufacturer": txtVehicleMF.text.toString(),
          "vehicle_model": txtVehicleModel.text.toString(),
          "vehicle_year": txtVehicleYear.text.toString(),
          "licence_plate": txtLicensePlate.text.toString(),
          "vehicle_color": txtVehicleColor.text.toString()
        };
        printInfo(info: _map.toString());
        signUpController.register2(_map, context);
        // Get.to(() => const LicenceDetailScreen());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(greenSnackBar(ErrorMessage.emailError2));
      }
    }
  }

  Widget textFieldForCity({controller, labelText, errorText, prefixIcon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Image.asset(
          prefixIcon,
          color: prefixIcon == ImageAssets.emailIcon ? Colors.black : Colors.black,
          scale: 10,
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            cursorColor: AllColors.blackColor,
            validator: (value) {
              if (value!.isEmpty) {
                return errorText;
              }
              return null;
            },
            onTap: () {
              Get.to(() => SearchCity((val) {
                    printInfo(info: val.toString());
                    txtCity.text = val["cityName"];
                    //txtCity.text=val;
                  }));
            },
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: labelText,
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
          ),
        ),
      ],
    );
  }

  Widget textField({controller, labelText, errorText, prefixIcon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Image.asset(
          prefixIcon,
          color: prefixIcon == ImageAssets.emailIcon ? Colors.black : Colors.black,
          scale: 10,
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            cursorColor: AllColors.blackColor,
            validator: (value) {
              if (value!.isEmpty) {
                return errorText;
              }
              return null;
            },
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: labelText,
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
          ),
        ),
      ],
    );
  }

  Widget textFieldWithoutIcon({controller, labelText, errorText, prefixIcon}) {
    return TextFormField(
      controller: controller,
      cursorColor: AllColors.blackColor,
      validator: (value) {
        if (value!.isEmpty) {
          return errorText;
        }
        return null;
      },
      textInputAction: controller == txtVehicleColor ? TextInputAction.done : TextInputAction.next,
      decoration: InputDecoration(
        labelText: labelText,
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

  Widget referralCode({controller, labelText, errorText, prefixIcon}) {
    return TextFormField(
      controller: controller,
      cursorColor: AllColors.blackColor,
      validator: (value) {
        if (value!.isEmpty) {
          return errorText;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: labelText,
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

  @override
  void dispose() {
    txtFName.dispose();
    txtLName.dispose();
    txtEmail.dispose();
    txtCity.dispose();
    txtLanguage.dispose();
    txtReferralCode.dispose();
    txtVehicleMF.dispose();
    txtVehicleModel.dispose();
    txtVehicleYear.dispose();
    txtLicensePlate.dispose();
    txtVehicleColor.dispose();
    super.dispose();
  }
}
