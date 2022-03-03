import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/extension_widgets.dart';

import 'drawer_screen.dart';

class DriverPaymentListScreen extends StatefulWidget {
  const DriverPaymentListScreen({Key? key}) : super(key: key);

  @override
  _DriverPaymentListScreenState createState() => _DriverPaymentListScreenState();
}

class _DriverPaymentListScreenState extends State<DriverPaymentListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String cardNumber = '3535 2626 7272 7274';
  String expiryDate = "05/31";
  String cardHolderName = "Vivek Shah";
  String cvvCode = "123";
  bool showBackView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarWidget("Payment", _scaffoldKey),
      drawer: DrawerScreen(),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            const Text(
              "\$455.65",
              style: TextStyle(color: AllColors.blackColor, fontSize: 45),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.18, right: MediaQuery.of(context).size.width * 0.18),
                child: AppButton(onPressed: () {}, text: "Pay", color: AllColors.greenColor)),
            const SizedBox(
              height: 20,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Payment History",
                  style: TextStyle(color: AllColors.blueColor, fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: 10,
                  shrinkWrap: false,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "Ahemdabad to nadiad #64737",
                                style: TextStyle(color: AllColors.blackColor, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "\$70",
                                style: TextStyle(color: AllColors.blackColor, fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            "12 May 2020 || 7:15 AM",
                            style: TextStyle(color: AllColors.greyColor, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class AddCard extends StatefulWidget {
  const AddCard({Key? key}) : super(key: key);

  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  TextEditingController cardNumber = TextEditingController();
  TextEditingController expiryDate = TextEditingController();
  TextEditingController cardHolderName = TextEditingController();
  TextEditingController cvvCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Add Card",
          style: TextStyle(color: AllColors.blueColor, fontSize: 18, fontWeight: FontWeight.w800),
        ),
        textField(controller: cardNumber, labelText: "Card Number", errorText: "Please enter card Number"),
        Row(
          children: [
            Expanded(
                flex: 4,
                child: textField(
                    controller: expiryDate, labelText: "Expiry date", errorText: "Please enter expiry date.")),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                flex: 2,
                child: textField(controller: cvvCode, labelText: "Cvv number", errorText: "Please enter cvv number")),
          ],
        ),
        textField(
            controller: cardHolderName, labelText: "Card holder name", errorText: "Please enter card holder name"),
        const SizedBox(
          height: 15,
        ),
        AppButton(onPressed: () {}, text: "Save card", color: AllColors.blueColor)
        // CreditCardWidget(
        //   isHolderNameVisible: true,
        //   //isChipVisible: true,
        //
        //   cardNumber: cardNumber,
        //   expiryDate: expiryDate,
        //   cardHolderName: cardHolderName,
        //   cvvCode: cvvCode,
        //   cardBgColor: AllColors.greenColor,
        //   showBackView: false,
        //   height: 180,
        //   animationDuration: const Duration(milliseconds: 1200),
        //   onCreditCardWidgetChange: (creditCardBrand) {}, //true when you want to show cvv(back) view
        // ),
      ],
    );
  }

  Widget textField({controller, labelText, errorText, prefixIcon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: controller == cardHolderName ? TextInputType.text : TextInputType.number,
          cursorColor: AllColors.blueColor,
          style: TextStyle(color: AllColors.blueColor),
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(color: AllColors.blueColor, fontSize: 14),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: AllColors.blueColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AllColors.blueColor),
            ),
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AllColors.blueColor),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AllColors.blueColor),
            ),
          ),
        ),
      ],
    );
  }
}
