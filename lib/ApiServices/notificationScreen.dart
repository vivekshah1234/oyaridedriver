import 'package:flutter/material.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/extension_widgets.dart';
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget2("Notifications"),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: 5,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                        color: AllColors.greenColor,
                        borderRadius: BorderRadius.circular(15)),
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textWidget(
                            txt: "You rider is waiting for you.",
                            fontSize: 13,
                            color: AllColors.whiteColor,
                            bold: FontWeight.w600,
                            italic: false),
                        const SizedBox(
                          height: 5,
                        ),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: textWidget(
                                txt: "22/12/2021",
                                fontSize: 11,
                                color: AllColors.blackColor,
                                bold: FontWeight.normal,
                                italic: false))
                      ],
                    ).putPadding(10, 10, 12, 12),
                  );
                }),
          )
        ],
      ).putPadding(10, 10, 20, 20),
    );
  }
}
