import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/controllers/driver_payment_controller.dart';

import 'drawer_screen.dart';

class DriverPaymentListScreen extends StatefulWidget {
  const DriverPaymentListScreen({Key? key}) : super(key: key);

  @override
  _DriverPaymentListScreenState createState() => _DriverPaymentListScreenState();
}

class _DriverPaymentListScreenState extends State<DriverPaymentListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DriverPaymentController driverPaymentController = Get.put(DriverPaymentController());

  @override
  void initState() {
    driverPaymentController.getPendingPayment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarWidget("Payment", _scaffoldKey),
      drawer: const DrawerScreen(),
      body: GetX<DriverPaymentController>(
          init: DriverPaymentController(),
          builder: (controller) {
            if (controller.isLoading.value) {
              return Center(child: greenLoadingWidget());
            }
            return Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "₦" + controller.payment.value,
                    style: const TextStyle(color: AllColors.blackColor, fontSize: 45),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  controller.tripList.isEmpty
                      ? Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.18,
                              right: MediaQuery.of(context).size.width * 0.18),
                          child: AppButton(onPressed: () {}, text: "Pay", color: Colors.grey))
                      : Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.18,
                              right: MediaQuery.of(context).size.width * 0.18),
                          child: AppButton(
                              onPressed: () {
                                Map<String, String> map = {
                                  "email": AppConstants.email,
                                  "amount": controller.payment.value
                                };
                                driverPaymentController.makePayment(
                                  map: map,
                                  context: context,
                                );
                              },
                              text: "Pay",
                              color: AllColors.greenColor)),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Payment History : ",
                        style: TextStyle(color: AllColors.blueColor, fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  controller.tripList.isEmpty
                      ? Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.20,
                            ),
                            Text("No pending payments.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(20),
                                  color: AllColors.blueColor,
                                  fontWeight: FontWeight.normal,
                                )),
                          ],
                        )
                      : Expanded(
                          child: ListView.builder(
                              itemCount: controller.tripList.length,
                              shrinkWrap: false,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Container(
                                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller.tripList[index].bookingId,
                                          style: TextStyle(color: AllColors.greenColor, fontWeight: FontWeight.w800),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 8,
                                              child: Text(
                                                "${controller.tripList[index].sourceCity} to ${controller.tripList[index].destinationCity} ",
                                                textAlign: TextAlign.start,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: AllColors.blackColor, fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                "₦${controller.tripList[index].price}",
                                                textAlign: TextAlign.end,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: AllColors.blackColor, fontWeight: FontWeight.w600),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          controller.tripList[index].createdAt.substring(0, 10),
                                          style: const TextStyle(color: AllColors.greyColor, fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                ],
              ),
            );
          }),
    );
  }
}
