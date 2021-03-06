import 'dart:io';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/extension_widgets.dart';
import 'package:oyaridedriver/Common/image_assets.dart';
import 'package:oyaridedriver/controllers/edit_profile_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _txtFName = TextEditingController();
  final TextEditingController _txtLName = TextEditingController();
  final TextEditingController _txtEmail = TextEditingController();
  final TextEditingController _txtNum = TextEditingController();
  final double _mediumFontSize = 15.0;
  String countryCode = "+39";

  EditProfileController editProfileController = Get.put(EditProfileController());

  @override
  void initState() {
    _txtFName.text = AppConstants.fullName.split(" ")[0];
    _txtLName.text = AppConstants.fullName.split(" ")[1];
    _txtEmail.text = AppConstants.email;
    countryCode = AppConstants.countryCode;
    _txtNum.text = AppConstants.mobileNo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget2("Edit Profile"),
      body: GetX<EditProfileController>(
          init: EditProfileController(),
          builder: (controller) {
            return Stack(
              alignment: Alignment.center,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(child: profilePic()),
                      Row(
                        children: [
                          Expanded(
                              child: textField(
                                  controller: _txtFName, prefixIcon: ImageAssets.personIcon, labelText: "First Name")),
                          const SizedBox(
                            width: 7,
                          ),
                          Expanded(child: textFieldWithoutIcon(controller: _txtLName, labelText: "Last Name")),
                        ],
                      ),
                      textField(controller: _txtEmail, prefixIcon: ImageAssets.emailIcon, labelText: "Email"),
                      textFieldForNum(
                          controller: _txtNum, labelText: "Phone Number", prefixIcon: ImageAssets.phoneIcon),
                      const SizedBox(
                        height: 25,
                      ),
                      AppButton(text: "UPDATE", onPressed: updateProfile, color: AllColors.greenColor)
                          .paddingSymmetric(horizontal: 30),
                    ],
                  ).putPadding(0, 0, 25, 25),
                ),
                Visibility(visible: controller.isLoading.value, child: greenLoadingWidget())
              ],
            );
          }),
    );
  }

  updateProfile() {
    Map<String, String> map = {
      "id": AppConstants.userID,
      "country_code": countryCode.toString(),
      "mobile_number": _txtNum.text.toString(),
      "first_name": _txtFName.text.toString(),
      "last_name": _txtLName.text.toString(),
      "email": _txtEmail.text.toString(),
    };
    if (file == null) {
      editProfileController.updateProfile(map, context);
    } else {
      editProfileController.updateProfileWithImage(map: map, profilePic: file, context: context);
    }
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
              labelStyle: TextStyle(color: AllColors.greyColor, fontSize: _mediumFontSize),
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
                    labelStyle: TextStyle(color: AllColors.greyColor, fontSize: _mediumFontSize),
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
                  style: TextStyle(color: AllColors.greyColor, fontSize: _mediumFontSize),
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
                  backgroundImage: NetworkImage(AppConstants.profilePic),
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
              child: Image.asset(
                ImageAssets.editIcon,
                scale: 10,
              ),
            ),
          ),
        )
      ],
    );
  }
}
