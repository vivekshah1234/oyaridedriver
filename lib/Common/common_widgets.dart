import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:oyaridedriver/Common/extension_widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'all_colors.dart';
// ignore_for_file: prefer_const_constructors

toast(String txt) {
  return Fluttertoast.showToast(
      msg: txt,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);
}

Widget circularIndicator() {
  return const CircularProgressIndicator(
    backgroundColor: Colors.white,
    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
  ).centerTheText();
}

Widget textWidget(
    {required String txt,
    required double fontSize,
    required Color color,
    required bool bold,
    required bool italic}) {
  return Text(
    txt,
    style: TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
      fontStyle: italic ? FontStyle.italic : FontStyle.normal,
    ),
  );
}

Widget shimmer(width, height) {
  return Opacity(
    opacity: 0.8,
    child: Shimmer.fromColors(
      baseColor: AllColors.greyColor,
      highlightColor: Colors.grey[50]!,
      child: Container(
        width: height,
        height: width,
        decoration: BoxDecoration(
            color: Colors.grey[400], borderRadius: BorderRadius.circular(2)),

        // child: Text("shimmer1"),
      ),
    ),
  );
}

Widget loadingWidget() {
  return Container(
    child: Center(child: SpinKitFoldingCube(color: AllColors.redColor)),
    height: 70,
    width: 70,
  );
}

Widget greenButton({required String txt, function}) {
  return Container(
    width: double.infinity,
  //  margin: const EdgeInsets.only(left: 45, right: 45),
    child: ElevatedButton(
      onPressed: function,
      style: buttonStyleGreen(),
      child: Text(
        txt,
        style: const TextStyle(
            color: AllColors.whiteColor,
            fontSize: 19,
            fontWeight: FontWeight.w500),
      ),
    ),
  );
}

AppBar appBarWidget(txt,GlobalKey<ScaffoldState> scaffoldKey) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: Padding(
      padding: const EdgeInsets.only(left: 18.0),
      child: FloatingActionButton(
        onPressed: () {
          scaffoldKey.currentState!.openDrawer();
        },
        backgroundColor: AllColors.whiteColor,
        child: const Icon(
          Icons.sort,
          color: AllColors.blackColor,
        ),
      ),
    ),
    title: textWidget(txt: txt, fontSize: 25, color: AllColors.blackColor, bold: true, italic: false),
    centerTitle: true,
  );
}
AppBar appBarWidget2(txt) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading:  Padding(
      padding: const EdgeInsets.only(left: 18.0),
      child: GestureDetector(
          onTap: (){
            Get.back();
          },

          child: Icon(Icons.arrow_back_ios,color: AllColors.blackColor,size: 35,)),
    ),
    title: textWidget(txt: txt, fontSize: 25, color: AllColors.blackColor, bold: true, italic: false),
    centerTitle: true,
  );
}

Widget blueButton({required String text, function}) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(left: 45, right: 45),
    child: ElevatedButton(
      onPressed: () {
        function();
      },
      style: buttonStyleBLue(),
      child: Text(
        text,
        style: const TextStyle(
            color: AllColors.whiteColor,
            fontSize: 17,
            fontWeight: FontWeight.w500),
      ),
    ),
  );
}

ButtonStyle buttonStyleBLue() => ButtonStyle(
      backgroundColor: MaterialStateProperty.all(AllColors.blueColor),
      shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
        return RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));
      }),
    );

ButtonStyle buttonStyleGreen() => ButtonStyle(
  backgroundColor: MaterialStateProperty.all(AllColors.greenColor),
  shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));
  }),
);
Widget textFieldWithoutIcon({controller, labelText, errorText}) {
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