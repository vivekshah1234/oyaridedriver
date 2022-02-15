import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/Common/extension_widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sized_context/src/extensions.dart';
import 'package:timelines/timelines.dart';
import 'all_colors.dart';
import 'image_assets.dart';

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
        decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(2)),

        // child: Text("shimmer1"),
      ),
    ),
  );
}

Widget whiteLoadingWidget() {
  return const SizedBox(
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
    title: textWidget(txt: txt, fontSize: 25, color: AllColors.blackColor, bold: FontWeight.w600, italic: false),
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
          child: const Icon(
            Icons.arrow_back_ios,
            color: AllColors.blackColor,
            size: 35,
          )),
    ),
    title: textWidget(txt: txt, fontSize: 25, color: AllColors.blackColor, bold: FontWeight.w600, italic: false),
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
        style: const TextStyle(color: AllColors.blackColor, fontWeight: FontWeight.bold),
      ),
      backgroundColor: AllColors.whiteColor,
    );

SnackBar greenSnackBar(
  String txt,
) =>
    SnackBar(
      content: Text(
        txt,
        style: const TextStyle(color: AllColors.blackColor, fontWeight: FontWeight.bold),
      ),
      backgroundColor: AllColors.greenColor,
    );

BoxShadow boxShadow() => BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 5,
      blurRadius: 7,
      offset: const Offset(0, 3), // changes position of shadow
    );

class RiderRequest extends StatelessWidget {
  final String name;
  final String imgUrl;
  final String price;
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
                        style: const TextStyle(
                          fontSize: 12,
                          color: AllColors.greyColor,
                        ),
                      )
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
                        style: const TextStyle(
                          fontSize: 12,
                          color: AllColors.greyColor,
                        ),
                      )
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
                SmallButton(text: "ACCEPT", color: AllColors.greenColor, onPressed: acceptOnTap),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget userDetails({required String txt, required String imgUrl, required String charge, required double kiloMeter}) {
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
                          fontWeight: FontWeight.w800, fontSize: ScreenUtil().setSp(17), color: AllColors.blackColor)),
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
  final String name;
  final String profilePic;
  final GestureTapCallback callButton;
  final GestureTapCallback cancelTap;
  final GestureTapCallback arrivedTap;
  final GestureTapCallback chatTap;

  const RiderDetails(
      {Key? key,
      required this.name,
      required this.callButton,
      required this.profilePic,
      required this.cancelTap,
      required this.arrivedTap,
      required this.chatTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: AllColors.blackColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40),
              topLeft: Radius.circular(40),
            ),
          ),
          padding: const EdgeInsets.only(top: 15, bottom: 10, left: 20, right: 20),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: AllColors.whiteColor,
                child: Icon(
                  Icons.location_on,
                  color: AllColors.blackColor,
                ),
              ),
              Expanded(child: dottedLine()),
              const CircleAvatar(
                backgroundColor: AllColors.whiteColor,
                child: Icon(
                  Icons.directions_car,
                  color: AllColors.blackColor,
                ),
              ),
              Expanded(child: dottedLine()),
              const CircleAvatar(
                backgroundColor: AllColors.whiteColor,
                child: Icon(
                  Icons.flag_sharp,
                  color: AllColors.blackColor,
                ),
              )
            ],
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          shadowColor: Colors.grey.shade900,
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(profilePic),
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
                    initialRating: 0.0,
                    onRatingUpdate: (val) {
                      printInfo(info: val.toString());
                    },
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: callButton,
                        child: Container(
                          decoration:
                              BoxDecoration(color: AllColors.greenColor, borderRadius: BorderRadius.circular(7)),
                          width: context.widthPct(0.2),
                          height: 30,
                          child: Image.asset(
                            ImageAssets.callIcon,
                            scale: 6,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: chatTap,
                        child: Container(
                            decoration:
                                BoxDecoration(color: AllColors.greenColor, borderRadius: BorderRadius.circular(7)),
                            width: context.widthPct(0.2),
                            height: 30,
                            child: Image.asset(
                              ImageAssets.chatIcon,
                              scale: 7,
                            )),
                      ),
                    ],
                  )
                ],
              )
            ],
          ).putPadding(10, 10, 10, 10),
        ).putPadding(10, 10, 25, 25),
        Row(
          children: [
            SmallButton(
              text: "CANCEL",
              color: AllColors.blueColor,
              onPressed: () {
                cancelTap();
              },
            ),
            const SizedBox(
              width: 10,
            ),
            SmallButton(
              text: "ARRIVED",
              color: AllColors.greenColor,
              onPressed: () {
                arrivedTap();
              },
            )
          ],
        ).putPadding(
          0,
          20,
          context.widthPct(0.08),
          context.widthPct(0.08),
        )
      ],
    );
  }

  Widget dottedLine() {
    return const DottedLine(
      direction: Axis.horizontal,
      lineLength: double.infinity,
      lineThickness: 2.0,
      dashLength: 4.0,
      dashColor: AllColors.whiteColor,
      // dashGradient: const [Colors.red, Colors.blue],
      dashRadius: 0.0,
      dashGapLength: 4.0,
      dashGapColor: Colors.transparent,
      //  dashGapGradient: const [Colors.red, Colors.blue],
      dashGapRadius: 0.0,
    );
  }
}

class ReachedAtLoc extends StatelessWidget {
  final String name;
  final String profilePic;
  final GestureTapCallback callButton;
  final GestureTapCallback cancelTap;
  final GestureTapCallback pickedTap;
  final GestureTapCallback chatTap;

  const ReachedAtLoc(
      {Key? key,
      required this.name,
      required this.callButton,
      required this.profilePic,
      required this.cancelTap,
      required this.pickedTap,
      required this.chatTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: AllColors.blackColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40),
              topLeft: Radius.circular(40),
            ),
          ),
          padding: const EdgeInsets.only(top: 15, bottom: 10, left: 20, right: 20),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AllColors.greenColor,
                child: const Icon(
                  Icons.location_on,
                  color: AllColors.blackColor,
                ),
              ),
              Expanded(child: dottedLine()),
              const CircleAvatar(
                backgroundColor: AllColors.whiteColor,
                child: Icon(
                  Icons.directions_car,
                  color: AllColors.blackColor,
                ),
              ),
              Expanded(child: dottedLine()),
              const CircleAvatar(
                backgroundColor: AllColors.whiteColor,
                child: Icon(
                  Icons.flag_sharp,
                  color: AllColors.blackColor,
                ),
              )
            ],
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          shadowColor: Colors.grey.shade900,
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(profilePic),
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
                  Row(
                    children: [
                      GestureDetector(
                        onTap: callButton,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AllColors.greenColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.only(top: 2, bottom: 2),
                          width: 70,
                          child: const Icon(
                            Icons.phone,
                            color: AllColors.whiteColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: chatTap,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AllColors.greenColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.only(top: 2, bottom: 2),
                          width: 70,
                          child: const Icon(
                            Icons.chat_bubble,
                            color: AllColors.whiteColor,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ).putPadding(10, 10, 10, 10),
        ).putPadding(10, 10, 25, 25),
        Row(
          children: [
            SmallButton(
              text: "CANCEL",
              color: AllColors.blueColor,
              onPressed: () {
                cancelTap();
              },
            ),
            const SizedBox(
              width: 10,
            ),
            SmallButton(
              text: "PICKED UP",
              color: AllColors.greenColor,
              onPressed: () {
                pickedTap();
              },
            )
          ],
        ).putPadding(
          0,
          20,
          context.widthPct(0.08),
          context.widthPct(0.08),
        )
      ],
    );
  }

  Widget dottedLine() {
    return const DottedLine(
      direction: Axis.horizontal,
      lineLength: double.infinity,
      lineThickness: 2.0,
      dashLength: 4.0,
      dashColor: AllColors.whiteColor,
      // dashGradient: const [Colors.red, Colors.blue],
      dashRadius: 0.0,
      dashGapLength: 4.0,
      dashGapColor: Colors.transparent,
      //  dashGapGradient: const [Colors.red, Colors.blue],
      dashGapRadius: 0.0,
    );
  }
}

class GiveRatingWidget extends StatefulWidget {
  final double initialRating;
  final onRatingUpdate;

  const GiveRatingWidget({required this.initialRating, required this.onRatingUpdate});

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

  const AppButton({required this.onPressed, required this.text, required this.color});

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
            return RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));
          }),
        ),
        child: Text(
          text,
          style: const TextStyle(color: AllColors.whiteColor, fontSize: 17, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class SmallButton extends StatelessWidget {
  final String text;
  final GestureTapCallback onPressed;
  final Color color;

  const SmallButton({required this.text, required this.color, required this.onPressed});

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
            return RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));
          }),
        ),
        child: Text(
          text,
          style: const TextStyle(color: AllColors.whiteColor, fontSize: 17, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class FetchingTheRequests extends StatelessWidget {
  final double bigFont = 23.0;
  final double smallFont = 14.0;
  final double mediumFont = 16.0;

  final FontWeight largeFontWeight = FontWeight.w900;
  final FontWeight mediumFontWeight = FontWeight.w600;
  final FontWeight normalFontWeight = FontWeight.normal;
  final String text;

  const FetchingTheRequests(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: AllColors.whiteColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(40),
          topLeft: Radius.circular(40),
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
          Container(
            width: 100,
            margin: const EdgeInsets.only(top: 10, bottom: 25),
            height: 5,
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, bottom: 15),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          dividerWidget(),
          LinearProgressIndicator(
            backgroundColor: AllColors.blueColor,
            valueColor: AlwaysStoppedAnimation(AllColors.greenColor),
            minHeight: 5,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

Widget dividerWidget() {
  return Divider(
    color: Colors.grey.shade300,
    height: 2,
    thickness: 1.5,
  );
}

class NoRequestCart extends StatelessWidget {
  final bool userOnline;

  NoRequestCart({required this.userOnline});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        userOnline
            ? Container()
            : SizedBox(
                //width: 300,
                height: 30,
                child: Marquee(
                  text: 'To receiver requests, you need to go online.',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  scrollAxis: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  blankSpace: 20.0,
                  velocity: 100.0,

                  //pauseAfterRound: const Duration(seconds: 1),
                  startPadding: 10.0,
                  accelerationDuration: const Duration(seconds: 1),
                  accelerationCurve: Curves.linear,
                  // decelerationDuration: const Duration(milliseconds: 500),
                  // decelerationCurve: Curves.easeOut,
                ),
              ),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: AllColors.whiteColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(40),
              topLeft: Radius.circular(40),
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
          padding: const EdgeInsets.only(top: 7, bottom: 20),
          child: Column(
            children: [
              Container(
                height: 4,
                width: MediaQuery.of(context).size.width * 0.35,
                margin: const EdgeInsets.only(top: 5, bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              Text(
                "Welcome, ${AppConstants.fullName}",
                style: TextStyle(fontSize: 20, color: AllColors.blueColor, fontWeight: FontWeight.bold),
              ).paddingOnly(top: 0, bottom: 15),
              Container(
                height: 1.5,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey.shade300,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Currently,You don't have any request.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: AllColors.blueColor, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WhileTravelingCart extends StatelessWidget {
  final String name;
  final String profilePic;
  final GestureTapCallback dropTap;

  WhileTravelingCart({required this.name, required this.profilePic, required this.dropTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: AllColors.blackColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40),
              topLeft: Radius.circular(40),
            ),
          ),
          padding: const EdgeInsets.only(top: 15, bottom: 10, left: 20, right: 20),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AllColors.greenColor,
                child: const Icon(
                  Icons.location_on,
                  color: AllColors.blackColor,
                ),
              ),
              Expanded(child: dottedLine()),
              CircleAvatar(
                backgroundColor: AllColors.greenColor,
                child: const Icon(
                  Icons.directions_car,
                  color: AllColors.blackColor,
                ),
              ),
              Expanded(child: dottedLine2()),
              const CircleAvatar(
                backgroundColor: AllColors.whiteColor,
                child: Icon(
                  Icons.flag_sharp,
                  color: AllColors.blackColor,
                ),
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //  crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.30,
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  shadowColor: Colors.grey.shade900,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(profilePic),
                        radius: 35,
                      ).putPadding(10, 10, 25, 25),
                      // SizedBox(height: 10,),
                      textWidget(
                          txt: name, bold: FontWeight.w600, fontSize: 18, italic: false, color: AllColors.blackColor),
                      const SizedBox(
                        height: 10,
                      ),
                      GiveRatingWidget(initialRating: 3, onRatingUpdate: (val) {})
                    ],
                  ).putPadding(20, 20, 20, 20),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.30,
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  shadowColor: Colors.grey.shade900,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textWidget(
                          txt: "Waiting",
                          bold: FontWeight.w500,
                          fontSize: 18,
                          italic: false,
                          color: AllColors.blackColor),
                      const SizedBox(
                        height: 10,
                      ),
                      textWidget(
                          txt: "00:00:00",
                          bold: FontWeight.w500,
                          fontSize: 18,
                          italic: false,
                          color: AllColors.blackColor),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        AppButton(
                onPressed: () {
                  dropTap();
                },
                text: "TAP WHEN DROP",
                color: AllColors.greenColor)
            .paddingSymmetric(horizontal: 25),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget dottedLine() {
    return DottedLine(
      direction: Axis.horizontal,
      lineLength: double.infinity,
      lineThickness: 2.0,
      dashLength: 4.0,
      dashColor: AllColors.greenColor,
      // dashGradient: const [Colors.red, Colors.blue],
      dashRadius: 0.0,
      dashGapLength: 4.0,
      dashGapColor: Colors.transparent,
      //  dashGapGradient: const [Colors.red, Colors.blue],
      dashGapRadius: 0.0,
    );
  }

  Widget dottedLine2() {
    return const DottedLine(
      direction: Axis.horizontal,
      lineLength: double.infinity,
      lineThickness: 2.0,
      dashLength: 4.0,
      dashColor: AllColors.whiteColor,
      // dashGradient: const [Colors.red, Colors.blue],
      dashRadius: 0.0,
      dashGapLength: 4.0,
      dashGapColor: Colors.transparent,
      //  dashGapGradient: const [Colors.red, Colors.blue],
      dashGapRadius: 0.0,
    );
  }
}

class CompleteRide extends StatelessWidget {
  String name, kilometer, price, bookingId;
  int paymentType;
  final GestureTapCallback confirmPayment;

  CompleteRide(
      {required this.name,
      required this.price,
      required this.kilometer,
      required this.confirmPayment,
      required this.paymentType,
      required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: AllColors.blackColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40),
              topLeft: Radius.circular(40),
            ),
          ),
          padding: const EdgeInsets.only(top: 15, bottom: 10, left: 20, right: 20),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AllColors.greenColor,
                child: const Icon(
                  Icons.location_on,
                  color: AllColors.blackColor,
                ),
              ),
              Expanded(child: dottedLine2()),
              CircleAvatar(
                backgroundColor: AllColors.greenColor,
                child: const Icon(
                  Icons.directions_car,
                  color: AllColors.blackColor,
                ),
              ),
              Expanded(child: dottedLine2()),
              CircleAvatar(
                backgroundColor: AllColors.greenColor,
                child: const Icon(
                  Icons.flag_sharp,
                  color: AllColors.blackColor,
                ),
              )
            ],
          ),
        ),
        Container(
          color: Colors.grey.shade50,
          padding: const EdgeInsets.only(left: 7, right: 7, top: 7, bottom: 7),
          margin: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  textWidget(
                      txt: name, bold: FontWeight.w800, fontSize: 18, italic: false, color: AllColors.blackColor),
                ],
              ),
              Column(
                children: [
                  textWidget(
                      txt: "\$$price", fontSize: 17, color: AllColors.blackColor, bold: FontWeight.w800, italic: false),
                  textWidget(
                      txt: "$kilometer km",
                      fontSize: 15,
                      color: AllColors.greyColor,
                      bold: FontWeight.normal,
                      italic: false),
                ],
              )
            ],
          ),
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textWidget(
                    txt: "Booking ID", fontSize: 18, color: AllColors.blackColor, bold: FontWeight.w300, italic: false),
                textWidget(
                    txt: bookingId, fontSize: 18, color: AllColors.blackColor, bold: FontWeight.w300, italic: false)
              ],
            ).putPadding(0, 0, 10, 10),
            const SizedBox(
              height: 12,
            ),
            const Divider(
              height: 2,
              color: AllColors.greyColor,
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textWidget(
                    txt: "Total", fontSize: 18, color: AllColors.blackColor, bold: FontWeight.w300, italic: false),
                textWidget(
                    txt: "\$$price", fontSize: 18, color: AllColors.blackColor, bold: FontWeight.w300, italic: false)
              ],
            ).putPadding(0, 0, 10, 10),
            const SizedBox(
              height: 12,
            ),
            const Divider(
              height: 2,
              color: AllColors.greyColor,
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textWidget(
                    txt: "Payment", fontSize: 18, color: AllColors.blackColor, bold: FontWeight.w300, italic: false),
                textWidget(
                    txt: paymentType == 0 ? "Cash" : "with PayStack",
                    fontSize: 18,
                    color: AllColors.blackColor,
                    bold: FontWeight.w300,
                    italic: false)
              ],
            ).putPadding(0, 0, 10, 10),
            const SizedBox(
              height: 12,
            ),
            const Divider(
              height: 2,
              color: AllColors.greyColor,
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ).putPadding(10, 10, 10, 10),
        AppButton(
                onPressed: () {
                  confirmPayment();
                },
                text: "CONFIRM PAYMENT",
                color: AllColors.greenColor)
            .paddingSymmetric(horizontal: 25),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget dottedLine2() {
    return DottedLine(
      direction: Axis.horizontal,
      lineLength: double.infinity,
      lineThickness: 2.0,
      dashLength: 4.0,
      dashColor: AllColors.greenColor,
      // dashGradient: const [Colors.red, Colors.blue],
      dashRadius: 0.0,
      dashGapLength: 4.0,
      dashGapColor: Colors.transparent,
      //  dashGapGradient: const [Colors.red, Colors.blue],
      dashGapRadius: 0.0,
    );
  }
}
