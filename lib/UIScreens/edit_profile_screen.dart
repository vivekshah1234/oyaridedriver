import 'dart:io';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/extension_widgets.dart';
import 'package:oyaridedriver/Common/image_assets.dart';
import 'package:oyaridedriver/UIScreens/drawer_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController txtFName = TextEditingController();
  TextEditingController txtLName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtNum = TextEditingController();
  TextEditingController txtPwd = TextEditingController();
  TextEditingController txtCPwd = TextEditingController();
  double mediumFontSize = 15.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: appBarWidget2("Edit Profile"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(child: profilePic()),
            Row(
              children: [
                Expanded(
                    child: textField(
                        controller: txtFName,
                        prefixIcon: ImageAssets.personIcon,
                        labelText: "First Name")),
                const SizedBox(
                  width: 7,
                ),
                Expanded(
                    child: textFieldWithoutIcon(
                        controller: txtLName, labelText: "Last Name")),
              ],
            ),
            textField(
                controller: txtEmail,
                prefixIcon: ImageAssets.emailIcon,
                labelText: "Email"),
            textFieldForNum(
                controller: txtNum,
                labelText: "Phone Number",
                prefixIcon: ImageAssets.phoneIcon),
            textField(
                controller: txtPwd,
                prefixIcon: ImageAssets.passwordIcon,
                labelText: "Password"),
            textField(
                controller: txtCPwd,
                prefixIcon: ImageAssets.passwordIcon,
                labelText: "Confirm Password"),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                checkBoxFun(),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Text(
                      "I have read and agreed the terms and conditions.",
                      style: TextStyle(
                      fontSize: mediumFontSize,
                      color: AllColors.greyColor,
                      fontWeight: FontWeight.normal),)
                )
              ],
            ),
            SizedBox(
              height: 25,
            ),
            greenButton(txt: "REGISTER", function: () {})
                .paddingSymmetric(horizontal: 30),
            // const Expanded(
            //     flex: 2,
            //     child: SizedBox(
            //       height: 25,
            //     )),
          ],
        ).putPadding(0, 0, 25, 25),
      ),
    );
  }

  bool checkBoxValue = false;

  Widget checkBoxFun() {
    return Column(
      children: <Widget>[
        Checkbox(
            value: checkBoxValue,
            activeColor: Colors.green,
            onChanged: (newValue) {
              setState(() {
                checkBoxValue = newValue!;
              });
              const Text('Remember me');
            }),
      ],
    );
  }

  var file;

  pickImage() async {
    final ImagePicker _picker = ImagePicker();
    try {
      XFile? image = await _picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        setState(() {
          file = File(image.path);
        });
        // toast( image!.path.toString());
      }
    } catch (ex) {
      debugPrint(ex.toString());
    }
  }

  Widget textField({controller, labelText, errorText, prefixIcon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Image.asset(
          prefixIcon,
          color: Colors.black,
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
              labelStyle: TextStyle(
                  color: AllColors.greyColor, fontSize: mediumFontSize),
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

  String countryCode = "+39";

  Widget textFieldForNum({controller, labelText, errorText, prefixIcon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Image.asset(
              prefixIcon,
              scale: 8.5,
              color: AllColors.blackColor,
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
                TextField(
                  controller: controller,
                  cursorColor: AllColors.blackColor,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: labelText,
                    labelStyle: TextStyle(
                        color: AllColors.greyColor, fontSize: mediumFontSize),
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
                  bottom: BorderSide(color: AllColors.greyColor),
                )),
            child: Row(
              children: [
                Text(
                  countryCode!.dialCode.toString(),
                  style: TextStyle(
                      color: AllColors.greyColor, fontSize: mediumFontSize),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AllColors.greyColor,
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
        initialSelection: '+62',
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

  Widget profilePic() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: file != null
              ? CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            radius: 52,
            backgroundImage: FileImage(file),
          )
              : CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            radius: 52,
            child: Icon(
              Icons.camera_alt_outlined,
              color: Colors.grey.shade400,
              size: 42,
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 25,
          child: GestureDetector(
            onTap: () {
              pickImage();
            },
            child: CircleAvatar(
              backgroundColor: AllColors.greenColor,
              radius: 18,
              child: Image.asset(ImageAssets.editIcon,scale: 10,),
            ),
          ),
        )
      ],
    );
  }
}
