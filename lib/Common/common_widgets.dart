import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:oyaridedriver/Common/extension_widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sized_context/src/extensions.dart';
import 'package:timelines/timelines.dart';
import 'all_colors.dart';
import 'image_assets.dart';
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
    required FontWeight bold,
    required bool italic}) {
  return Text(
    txt,
    style: TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: bold,
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

Widget whiteLoadingWidget() {
  return SizedBox(
    child: Center(child: SpinKitFadingCircle(color: AllColors.whiteColor)),
    height: 70,
    width: 70,
  );
}

Widget greenLoadingWidget() {
  return SizedBox(
    child: Center(child: SpinKitFadingCircle(color: AllColors.greenColor)),
    height: 70,
    width: 70,
  );
}
//
// Widget greenButton({required String txt, function}) {
//   return SizedBox(
//     width: double.infinity,
//   //  margin: const EdgeInsets.only(left: 45, right: 45),
//     child: ElevatedButton(
//       onPressed: function,
//       style: buttonStyleGreen(),
//       child: Text(
//         txt,
//         style: const TextStyle(
//             color: AllColors.whiteColor,
//             fontSize: 19,
//             fontWeight: FontWeight.w500),
//       ),
//     ),
//   );
// }

AppBar appBarWidget(txt, GlobalKey<ScaffoldState> scaffoldKey) {
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
    title: textWidget(
        txt: txt,
        fontSize: 25,
        color: AllColors.blackColor,
        bold: FontWeight.w600,
        italic: false),
    centerTitle: true,
  );
}

AppBar appBarWidget2(txt) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: Padding(
      padding: const EdgeInsets.only(left: 18.0),
      child: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: AllColors.blackColor,
            size: 35,
          )),
    ),
    title: textWidget(
        txt: txt,
        fontSize: 25,
        color: AllColors.blackColor,
        bold: FontWeight.w600,
        italic: false),
    centerTitle: true,
  );
}

Widget textFieldWithoutIcon({controller, labelText, errorText}) {
  return TextField(
    controller: controller,
    cursorColor: AllColors.blackColor,
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

SnackBar whiteSnackBar(
  String txt,
) =>
    SnackBar(
      content: Text(
        txt,
        style:
            TextStyle(color: AllColors.blackColor, fontWeight: FontWeight.bold),
      ),
      backgroundColor: AllColors.whiteColor,
    );

SnackBar greenSnackBar(
  String txt,
) =>
    SnackBar(
      content: Text(
        txt,
        style:
            TextStyle(color: AllColors.blackColor, fontWeight: FontWeight.bold),
      ),
      backgroundColor: AllColors.greenColor,
    );

class RiderRequest extends StatelessWidget {
  final String name;
  final String imgUrl;
  final double price;
  final double km;
  final String pickUpPoint;
  final String dropOffPoint;
  final GestureTapCallback acceptOnTap;
  final GestureTapCallback ignoreOnTap;

  const RiderRequest(
      {required this.name,
      required this.imgUrl,
      required this.price,
      required this.km,
      required this.pickUpPoint,
      required this.dropOffPoint,
      required this.acceptOnTap,
      required this.ignoreOnTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AllColors.whiteColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          userDetails(txt: name, imgUrl: imgUrl, kiloMeter: km, charge: price),
          Column(
            children: [
              TimelineTile(
                nodeAlign: TimelineNodeAlign.start,
                contents: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textWidget(
                          txt: "Pick Up",
                          fontSize: 12,
                          color: AllColors.greyColor,
                          bold: FontWeight.normal,
                          italic: false),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        pickUpPoint,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 12,
                          color: AllColors.greyColor,

                        ),)
                    ],
                  ),
                ),
                node: TimelineNode(
                    indicator: ContainerIndicator(
                        child: CircleAvatar(
                      backgroundColor: AllColors.greenColor,
                      radius: 4,
                    )),
                    endConnector: const DashedLineConnector(
                      color: AllColors.greyColor,
                    )),
              ),
              TimelineTile(
                nodeAlign: TimelineNodeAlign.start,
                contents: Container(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textWidget(
                          txt: "Drop off",
                          fontSize: 12,
                          color: AllColors.greyColor,
                          bold: FontWeight.normal,
                          italic: false),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                       dropOffPoint,
                          maxLines: 1,
                          style: TextStyle(
                          fontSize: 12,
                          color: AllColors.greyColor,

                        ),)
                    ],
                  ),
                ),
                node: TimelineNode(
                  startConnector: const DashedLineConnector(
                    color: AllColors.greyColor,
                  ),
                  indicator: ContainerIndicator(
                      child: CircleAvatar(
                    backgroundColor: AllColors.blueColor,
                    radius: 4,
                  )),
                ),
              ),
              // const SizedBox(height: 20,),
            ],
          ).putPadding(0, 15, context.widthPct(0.15), context.widthPct(0.15)),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmallButton(
                  text: "IGNORE",
                  color: AllColors.blueColor,
                  onPressed: ignoreOnTap,
                ),
                const SizedBox(
                  width: 10,
                ),
                SmallButton(
                    text: "ACCEPT",
                    color: AllColors.greenColor,
                    onPressed: acceptOnTap),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget userDetails(
      {required String txt,
      required String imgUrl,
      required double charge,
      required double kiloMeter}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.only(top: 15, bottom: 10, left: 20, right: 20),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AllColors.greyColor,
                  backgroundImage: NetworkImage(imgUrl),
                  radius: 32,
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Text(txt,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: ScreenUtil().setSp(17),
                          color: AllColors.blackColor)),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                textWidget(
                    txt: "\$${charge.toString()}",
                    fontSize: ScreenUtil().setSp(17),
                    color: AllColors.blackColor,
                    bold: FontWeight.w800,
                    italic: false),
                textWidget(
                    txt: "${kiloMeter.toString()} km",
                    fontSize: ScreenUtil().setSp(15),
                    color: AllColors.greyColor,
                    bold: FontWeight.w600,
                    italic: false),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class RiderDetails extends StatelessWidget {
  String name;
  final GestureTapCallback callButton;

  RiderDetails({required this.name, required this.callButton});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      shadowColor: Colors.grey.shade900,
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(imgUrl),
                radius: 35,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: ScreenUtil().setSp(18),
                        color: AllColors.blackColor)),
              )
            ],
          ).putPadding(10, 10, 25, 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GiveRatingWidget(
                initialRating: 3,
                onRatingUpdate: (val) {
                  printInfo(info: val.toString());
                },
              ),
              GestureDetector(
                onTap: callButton,
                child: Container(
                  decoration: BoxDecoration(
                    color: AllColors.greenColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.only(top: 2, bottom: 2),
                  width: 100,
                  child: const Icon(
                    Icons.phone,
                    color: AllColors.whiteColor,
                  ),
                ),
              )
            ],
          )
        ],
      ).putPadding(10, 10, 10, 10),
    ).putPadding(10, 10, 25, 25);
  }
}

class GiveRatingWidget extends StatefulWidget {
  final double initialRating;
  final onRatingUpdate;

  GiveRatingWidget({required this.initialRating, required this.onRatingUpdate});

  @override
  State<GiveRatingWidget> createState() => _GiveRatingWidgetState();
}

class _GiveRatingWidgetState extends State<GiveRatingWidget> {
  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: widget.initialRating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 15,
      itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: AllColors.greenColor,
      ),
      onRatingUpdate: (rating) {
        widget.onRatingUpdate(rating);
      },
    );
  }
}

class AppButton extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String text;
  final Color color;

  const AppButton(
      {required this.onPressed, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //padding: const EdgeInsets.only(left: 15, right: 15,),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
          shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
            return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25));
          }),
        ),
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
}

class SmallButton extends StatelessWidget {
  final String text;
  final GestureTapCallback onPressed;
  final Color color;

  const SmallButton(
      {required this.text, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // padding: const EdgeInsets.only(left: 45, right: 45),
      width: context.widthPct(0.40),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
          shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
            return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25));
          }),
        ),
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
}
