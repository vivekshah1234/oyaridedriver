// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/image_assets.dart';
import 'package:oyaridedriver/controllers/notification_list_controller.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  double mediumFont = 15.0;
  double smallFont = 12.0;
  TextEditingController txtSearch = TextEditingController();
  final border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(
        color: Colors.transparent,
      ));
  NotificationListController notificationListController = Get.put(NotificationListController());

  @override
  void initState() {
    notificationListController.getNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget2("Notifications"),
      body: GetX<NotificationListController>(
          init: NotificationListController(),
          builder: (NotificationListController controller) {
            if (controller.isLoading.value) {
              return Center(child: greenLoadingWidget());
            }
            return Column(
              children: [
                // searchTextField(),
                SizedBox(
                  height: 15,
                ),
                Expanded(child: notificationList(controller))
              ],
            ).paddingSymmetric(horizontal: 25);
          }),
    );
  }

  Widget notificationList(NotificationListController controller) {
    return ListView.builder(
        itemCount: controller.notificationList.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Card(
            shadowColor: Colors.grey.withOpacity(1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              ImageAssets.dummyPersonIcon,
                              scale: 10,
                            )),

                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textWidget(
                                txt: controller.notificationList[index].notificationTitle,
                                fontSize: mediumFont,
                                color: AllColors.blackColor,
                                bold: FontWeight.w700,
                              ),
                              Text(
                                controller.notificationList[index].description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: smallFont,
                                  color: AllColors.blackColor,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      textWidget(
                        txt: controller.notificationList[index].createdAt.substring(0, 10),
                        fontSize: smallFont,
                        color: AllColors.greyColor,
                        bold: FontWeight.normal,
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget searchTextField() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      height: 45,
      child: TextField(
        controller: txtSearch,
        decoration: InputDecoration(
            hintText: "Search",
            filled: true,
            fillColor: Colors.white,
            focusedBorder: border,
            enabledBorder: border,
            border: border,
            hintStyle: TextStyle(fontSize: mediumFont, fontWeight: FontWeight.w600, color: AllColors.blackColor)),
      ),
    );
  }

  Widget textWidget({
    required String txt,
    required double fontSize,
    required Color color,
    required FontWeight bold,
  }) {
    return Text(
      txt,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: bold,
      ),
    );
  }
}
