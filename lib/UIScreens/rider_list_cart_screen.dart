import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/dynamic_extensions.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/extension_widgets.dart';
import 'package:oyaridedriver/Common/image_assets.dart';
import 'package:sized_context/src/extensions.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:timelines/timelines.dart';

import 'map_screen.dart';

class RiderListCartScreen extends StatefulWidget {
  const RiderListCartScreen({Key? key}) : super(key: key);

  @override
  _RiderListCartScreenState createState() => _RiderListCartScreenState();
}

class _RiderListCartScreenState extends State<RiderListCartScreen> {
  final List<SwipeItem> _swipeItems = [];
  late MatchEngine _matchEngine;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final List<String> _names = [
    "Ian Somerholder",
    "Paul Wesley",
    "Damon Salvtore",
    "Stefan",
    "Nina dobrev"
  ];
  final List<String> imgUrlList = [imgUrl, imgUrl, imgUrl, imgUrl, imgUrl];
  final List<double> charge = [50.0, 40.0, 40.0, 50.0, 10.0];
  final List<double> kiloMeter = [15.0, 23.0, 22.0, 25.0, 45.0];
  final List<String> sourcePoint = [
    "Medical Education Center",
    "Medical Education Center",
    "Medical Education Center",
    "Medical Education Center",
    "Medical Education Center"
  ];
  final List<String> destinationPoint = [
    "Barthimam College",
    "Barthimam College",
    "Barthimam College",
    "Barthimam College",
    "Barthimam College"
  ];

  @override
  void initState() {
    init();
    super.initState();
  }

  init() {
    for (int i = 0; i < _names.length; i++) {
      _swipeItems.add(SwipeItem(
          content: Content(
              name: _names[i],
              imgurl: imgUrlList[i],
              charge: charge[i],
              kiloMeter: kiloMeter[i],
              pickUpPoint: sourcePoint[i],
              destinationPoint: destinationPoint[i]),
          likeAction: () {
            printInfo(info: "like");
            isAccepted=true;
            setState(() {

            });
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
    return Container(
      height: MediaQuery.of(context).size.height*0.38,
      child: SwipeCards(
        matchEngine: _matchEngine,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: MediaQuery.of(context).size.width,
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
                userDetails(
                    txt: _names[index],
                    imgUrl: imgUrlList[index],
                    kiloMeter: kiloMeter[index].toString(),
                    charge: charge[index].toString()),
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
                                txt: sourcePoint[index],
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
                                txt: destinationPoint[index],
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
                  ],
                ).putPadding(
                    0, 20, context.widthPct(0.15), context.widthPct(0.15)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    blueButton(
                        txt: "IGNORE",
                        function: () {
                          _matchEngine.currentItem?.nope();
                        }),
                    const SizedBox(
                      width: 10,
                    ),
                    greenButton(
                        txt: "ACCEPT",
                        function: () {
                          _matchEngine.currentItem?.like();
                        })
                  ],
                ).putPadding(0, 0, 10, 10)
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
    );


  }

  Widget userDetails(
      {required String txt,
      required String imgUrl,
      required String charge,
      required String kiloMeter}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(40),
          topLeft: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.only(top: 15, bottom: 10, left: 20, right: 20),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AllColors.greyColor,
            backgroundImage: NetworkImage(
                "https://image.shutterstock.com/image-photo/ian-somerhalder-lost-live-final-600w-102016990.jpg"),
            radius: 35,
          ),
          const SizedBox(
            width: 20,
          ),
          textWidget(
              txt: txt,
              bold: FontWeight.w800,
              fontSize: 18,
              italic: false,
              color: AllColors.blackColor),
          Expanded(
            child: Container(),
          ),
          Column(
            children: [
              textWidget(
                  txt: "\$$charge",
                  fontSize: 17,
                  color: AllColors.blackColor,
                  bold: FontWeight.w800,
                  italic: false),
              textWidget(
                  txt: "$kiloMeter km",
                  fontSize: 15,
                  color: AllColors.greyColor,
                  bold: FontWeight.w600,
                  italic: false),
            ],
          )
        ],
      ),
    );
  }

  Widget blueButton({required String txt, function}) {
    return SizedBox(
      // padding: const EdgeInsets.only(left: 45, right: 45),
      width: context.widthPct(0.40),
      child: ElevatedButton(
        onPressed: () {
          function();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AllColors.blueColor),
          shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
            return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25));
          }),

          //
        ),
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

  Widget greenButton({required String txt, function}) {
    return Container(
      width: context.widthPct(0.40),
      child: ElevatedButton(
        onPressed: () {
          function();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AllColors.greenColor),
          shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
            return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25));
          }),
        ),
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

class Content {
  final String name;
  final String imgurl;
  final double charge;
  final double kiloMeter;
  final String pickUpPoint;
  final String destinationPoint;

  Content(
      {required this.name,
      required this.imgurl,
      required this.charge,
      required this.kiloMeter,
      required this.pickUpPoint,
      required this.destinationPoint});
}
