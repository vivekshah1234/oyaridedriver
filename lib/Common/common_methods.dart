
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:oyaridedriver/Common/extension_widgets.dart';

import 'all_colors.dart';
import 'common_widgets.dart';
import 'image_assets.dart';


double childAspectRationFun(double height,context) {
  print("Screen height===" + height.toString());
  double height2=0.0;
  if (height <= 650) {
    height2= MediaQuery.of(context).size.height*0.50;
  }else if(height > 650 && height <=700){
    height2= MediaQuery.of(context).size.height*0.45;
  }
  else if(height > 650 && height <=700){
    height2= MediaQuery.of(context).size.height*0.38;
  }else
    {
    height2= MediaQuery.of(context).size.height*0.35;
  }
  return height2;
}


bool isValidEmail(String email) {
  const _emailRegExpString = r'[a-zA-Z0-9\+\.\_\%\-\+]{1,256}\@[a-zA-Z0-9]'
      r'[a-zA-Z0-9\-]{0,64}(\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,25})+';
  return RegExp(_emailRegExpString, caseSensitive: false).hasMatch(email);
}

bool isValidPassword(String value) {
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}

Future<Uint8List> getMarker2(context) async {
  ByteData byteData = await DefaultAssetBundle.of(context)
      .load(ImageAssets.driverCarIcon);
  return byteData.buffer.asUint8List();
}

Future<Uint8List?> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))?.buffer.asUint8List();
}


handleError(value, context) {
  showAnimatedDialog(
    context: context,barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      return textWidget(
          txt: value, fontSize: 14, color: AllColors.blueColor, bold: true, italic: false)
          .alertCard(context);
    },
    animationType: DialogTransitionType.slideFromBottomFade,
    curve: Curves.fastOutSlowIn,
    duration:  const Duration(milliseconds: 500),
  );
}