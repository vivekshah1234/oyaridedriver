
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/image_assets.dart';
import 'package:oyaridedriver/Common/extension_widgets.dart';
import 'package:oyaridedriver/UIScreens/licence_details_screens.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey ,
      appBar: appBarWidget2(""),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: textWidget(
                  txt: "Personal informations",
                  fontSize: 26,
                  color: AllColors.blackColor,
                  bold: true,
                  italic: false),
            ),
            Center(
              child: textWidget(
                  txt: "and vehicle details",
                  fontSize: 25,
                  color: AllColors.blackColor,
                  bold: true,
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
                  bold: false,
                  italic: false),
            ),
            Center(
              child: textWidget(
                  txt: "details  are visible to clients during booking.",
                  fontSize: 16,
                  color: Colors.black54,
                  bold: false,
                  italic: false),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: detailForm(),
            )
          ],
        ),
      ),
    );
  }

  Widget detailForm() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: textField(
                    controller: txtFName, prefixIcon: ImageAssets.personIcon,labelText: "First Name")),
            const SizedBox(
              width: 7,
            ),
            Expanded(
                child: textFieldWithoutIcon(
              controller: txtLName,labelText: "Last Name"
            )),

            // textField(controller: txtLName,prefixIcon: ""),
          ],
        ),
        textField(controller: txtEmail, prefixIcon: ImageAssets.emailIcon,labelText: "Email"),
        textField(controller: txtCity, prefixIcon: ImageAssets.cityIcon,labelText: "City"),
        textField(controller: txtLanguage, prefixIcon: ImageAssets.languageIcon,labelText: "Language"),
        Column(
          children: [

            textFieldWithoutIcon(
                controller: txtReferralCode,labelText: "Referral code"
            ),
            textFieldWithoutIcon(
                controller: txtVehicleMF,labelText: "Vehicle manufacturer"
            ),
            textFieldWithoutIcon(
                controller: txtLName,labelText: "Vehicle model"
            ),textFieldWithoutIcon(
                controller: txtLName,labelText: "Vehicle year"
            )
            ,textFieldWithoutIcon(
                controller: txtLName,labelText: "License plate"
            ),
            textFieldWithoutIcon(
                controller: txtLName,labelText: "Vehicle color"
            ),
          ],
        ).putPadding(0, 20, 5, 25),
        greenButton(txt: "NEXT",function: (){
          Get.to(()=> const LicenceDetailScreen());
        }).paddingOnly(left: context.widthPct(.15),right: context.widthPct(.15) ),
       const SizedBox(height: 20,)
      ],
    );
  }



  Widget textField({controller, labelText, errorText, prefixIcon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Image.asset(
          prefixIcon,
          color:
              prefixIcon == ImageAssets.emailIcon ? Colors.black : Colors.black,
          scale: 10,
        ),
       const SizedBox(
          width: 8,
        ),
        Expanded(
          child: TextField(
            controller: controller,
            cursorColor: AllColors.blackColor,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle:const TextStyle(
                color: AllColors.greyColor,fontSize: 13
              ),
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: AllColors.greyColor),
              ),
              focusedBorder:const UnderlineInputBorder(
                borderSide: BorderSide(color: AllColors.greyColor),
              ),
              disabledBorder:const UnderlineInputBorder(
                borderSide: BorderSide(color: AllColors.greyColor),
              ),
              enabledBorder:const UnderlineInputBorder(
                borderSide: BorderSide(color: AllColors.greyColor),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget textFieldWithoutIcon({controller, labelText, errorText, prefixIcon}) {
    return TextField(
      controller: controller,
      cursorColor: AllColors.blackColor,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: AllColors.greyColor,fontSize: 13
        ),
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
