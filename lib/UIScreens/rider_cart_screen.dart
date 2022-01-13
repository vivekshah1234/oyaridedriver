import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/dynamic_extensions.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_methods.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/extension_widgets.dart';
import 'package:oyaridedriver/Common/image_assets.dart';
import 'package:oyaridedriver/UIScreens/rider_list_cart_screen.dart';
import 'package:sized_context/src/extensions.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:timelines/timelines.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class RiderCartScreen extends StatefulWidget {
  const RiderCartScreen({Key? key}) : super(key: key);

  @override
  _RiderCartScreenState createState() => _RiderCartScreenState();
}

class _RiderCartScreenState extends State<RiderCartScreen> {
  int status = -1;
  final List<SwipeItem> _swipeItems = [];
  late MatchEngine _matchEngine;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<Map<String, dynamic>> dataList = [
    {
      "name": "Ian Somerholder",
      "imgUrl": imgUrl,
      "charge": 50.0,
      "kiloMeter": 15.0,
      "sourcePoint": "Medical Education Center",
      "destinationPoint": "Barthimam College"
    },
    {
      "name": "Paul Welsey",
      "imgUrl": imgUrl,
      "charge": 50.0,
      "kiloMeter": 15.0,
      "sourcePoint": "Medical Education Center",
      "destinationPoint": "Barthimam College"
    },
    {
      "name": "Nina Doberev",
      "imgUrl": imgUrl,
      "charge": 50.0,
      "kiloMeter": 15.0,
      "sourcePoint": "Medical Education Center",
      "destinationPoint": "Barthimam College"
    },
    {
      "name": "Tony Somerholder",
      "imgUrl": imgUrl,
      "charge": 50.0,
      "kiloMeter": 15.0,
      "sourcePoint": "Medical Education Center",
      "destinationPoint": "Barthimam College"
    }
  ];

  @override
  void initState() {
    init();
    super.initState();
  }

  init() {
    for (int i = 0; i < dataList.length; i++) {
      _swipeItems.add(SwipeItem(
          content: Content(
              name: dataList[i]["name"],
              imgurl: dataList[i]["imgUrl"],
              charge: dataList[i]["charge"],
              kiloMeter: dataList[i]["kiloMeter"],
              pickUpPoint: dataList[i]["sourcePoint"],
              destinationPoint: dataList[i]["destinationPoint"]),
          likeAction: () {
            printInfo(info: "like");
            status = 0;
            setState(() {});
          },
          nopeAction: () {
            printInfo(info: "nope");
          },
          superlikeAction: () {
            printInfo(info: "super Like");
          }));
    }

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  @override
  Widget build(BuildContext context) {
    return status == -1
        ? SizedBox(
            height: childAspectRationFun(
                MediaQuery.of(context).size.height, context),
            child: SwipeCards(
              matchEngine: _matchEngine,
              itemBuilder: (BuildContext context, int index) {
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
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      userDetails(
                          txt: dataList[index]["name"],
                          imgUrl: dataList[index]["imgUrl"],
                          kiloMeter: dataList[index]["kiloMeter"],
                          charge: dataList[index]["charge"]),
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
                                  textWidget(
                                      txt: dataList[index]["sourcePoint"],
                                      fontSize: 12,
                                      color: AllColors.greyColor,
                                      bold: FontWeight.normal,
                                      italic: false),
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
                                  textWidget(
                                      txt: dataList[index]["destinationPoint"],
                                      fontSize: 12,
                                      color: AllColors.greyColor,
                                      bold: FontWeight.normal,
                                      italic: false),
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
                      ).putPadding(0, 15, context.widthPct(0.15),
                          context.widthPct(0.15)),
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
                              onPressed: () {
                                _matchEngine.currentItem?.nope();
                                setState(() {});
                              },
                            ),
                            // blueButton(
                            //     txt: "IGNORE",
                            //     function: () {
                            //
                            //     }),
                            const SizedBox(
                              width: 10,
                            ),
                            SmallButton(
                              text: "ACCEPT",
                              color: AllColors.greenColor,
                              onPressed: () {
                                _matchEngine.currentItem?.like();
                                status = 0;
                                setState(() {});
                              },
                            ),

                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
              onStackFinished: () {
                printInfo(info: "aaaaa");
                _scaffoldKey.currentState?.showSnackBar(const SnackBar(
                  content: Text("Stack Finished"),
                  duration: Duration(milliseconds: 500),
                ));
              },
            ),
          )
        : Container(
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

            //  padding: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                locationDetails(),
                status < 2
                    ? userCart()
                    : status == 2
                        ? whileTravelingCart()
                        : userCart3(),
                status < 2
                    ? Row(
                        children: [
                          SmallButton(
                            text: "CANCEL",
                            color: AllColors.blueColor,
                            onPressed: () {},
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          if (status < 1)
                            SmallButton(
                              text: "ARRIVED",
                              color: AllColors.greenColor,
                              onPressed: () {
                                status = 1;
                                print("tap");
                                setState(() {});
                              },
                            )
                          else if (status == 1)
                            SmallButton(
                              text: "PICKED UP",
                              color: AllColors.greenColor,
                              onPressed: () {
                                status = 2;
                                print("tap");
                                setState(() {});
                              },
                            )
                          else if (status == 2)
                            Container()
                          // Expanded(child: greenButton(txt: "ACCEPT",function: (){})),
                        ],
                      ).putPadding(
                        0,
                        20,
                        context.widthPct(0.08),
                        context.widthPct(0.08),
                      )
                    : status == 2
                        ? ConfirmButton(
                            txt: "TAP WHEN DROP",
                            onPressed: () {
                              status = 3;
                              print("tap");
                              setState(() {});
                            },
                          )
                        : ConfirmButton(
                            txt: "CONFIRM PAYMENT",
                            onPressed: () {
                              status = 4;
                              print("tap");
                              setState(() {});
                            },
                          ),
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
                const CircleAvatar(
                  backgroundColor: AllColors.greyColor,
                  backgroundImage: NetworkImage(
                      "https://image.shutterstock.com/image-photo/ian-somerhalder-lost-live-final-600w-102016990.jpg"),
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

  Widget userCart() {
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
                child: Text("Stella Josh",
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
              RatingBar.builder(
                initialRating: 3,
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
                  print(rating);
                },
              ),
              GestureDetector(
                onTap: () {
                  UrlLauncher.launch("tel://21213123123");
                },
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

  Widget locationDetails() {
    return Container(
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
            backgroundColor:
                status == 0 ? AllColors.whiteColor : AllColors.greenColor,
            child: const Icon(
              Icons.location_on,
              color: AllColors.blackColor,
            ),
          ),
          Expanded(child: dottedLine()),
          CircleAvatar(
            backgroundColor:
                status <= 1 ? AllColors.whiteColor : AllColors.greenColor,
            child: const Icon(
              Icons.directions_car,
              color: AllColors.blackColor,
            ),
          ),
          Expanded(child: dottedLine2()),
          CircleAvatar(
            backgroundColor:
                status <= 2 ? AllColors.whiteColor : AllColors.greenColor,
            child: const Icon(
              Icons.flag_sharp,
              color: AllColors.blackColor,
            ),
          )
        ],
      ),
    );
  }

  Widget dottedLine() {
    return DottedLine(
      direction: Axis.horizontal,
      lineLength: double.infinity,
      lineThickness: 2.0,
      dashLength: 4.0,
      dashColor: status <= 1 ? AllColors.whiteColor : AllColors.greenColor,
      // dashGradient: const [Colors.red, Colors.blue],
      dashRadius: 0.0,
      dashGapLength: 4.0,
      dashGapColor: Colors.transparent,
      //  dashGapGradient: const [Colors.red, Colors.blue],
      dashGapRadius: 0.0,
    );
  }

  Widget dottedLine2() {
    return DottedLine(
      direction: Axis.horizontal,
      lineLength: double.infinity,
      lineThickness: 2.0,
      dashLength: 4.0,
      dashColor: status <= 2 ? AllColors.whiteColor : AllColors.greenColor,
      // dashGradient: const [Colors.red, Colors.blue],
      dashRadius: 0.0,
      dashGapLength: 4.0,
      dashGapColor: Colors.transparent,
      //  dashGapGradient: const [Colors.red, Colors.blue],
      dashGapRadius: 0.0,
    );
  }

  Widget whileTravelingCart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //  crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 2,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            shadowColor: Colors.grey.shade900,
            child: Column(
              children: [
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://i.pinimg.com/564x/04/e1/78/04e1784fc85d72ccec586ca224ce361a.jpg"),
                  radius: 35,
                ).putPadding(10, 10, 25, 25),
                // SizedBox(height: 10,),
                textWidget(
                    txt: "Stella Josan",
                    bold: FontWeight.w600,
                    fontSize: 18,
                    italic: false,
                    color: AllColors.blackColor),
                const SizedBox(
                  height: 10,
                ),
                RatingBar.builder(
                  initialRating: 3,
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
                    print(rating);
                  },
                )
              ],
            ).putPadding(20, 20, 20, 20),
          ),
        ),
        Expanded(
          flex: 2,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.30,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
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
    );
  }

  Widget userCart3() {
    return Column(
      children: [
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
                      txt: "Stella Josan",
                      bold: FontWeight.w800,
                      fontSize: 18,
                      italic: false,
                      color: AllColors.blackColor),
                ],
              ),
              Column(
                children: [
                  textWidget(
                      txt: "\$50",
                      fontSize: 17,
                      color: AllColors.blackColor,
                      bold: FontWeight.w800,
                      italic: false),
                  textWidget(
                      txt: "15 km",
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
                    txt: "Booking ID",
                    fontSize: 18,
                    color: AllColors.blackColor,
                    bold: FontWeight.w300,
                    italic: false),
                textWidget(
                    txt: "#TXN67876",
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textWidget(
                    txt: "Total",
                    fontSize: 18,
                    color: AllColors.blackColor,
                    bold: FontWeight.w300,
                    italic: false),
                textWidget(
                    txt: "\$50",
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textWidget(
                    txt: "Payment",
                    fontSize: 18,
                    color: AllColors.blackColor,
                    bold: FontWeight.w300,
                    italic: false),
                textWidget(
                    txt: "Cash",
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
      ],
    );
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
}

class ConfirmButton extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String txt;

  const ConfirmButton({
    required this.onPressed,
    required this.txt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: buttonStyleGreen(),
        child: Text(
          txt,
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
