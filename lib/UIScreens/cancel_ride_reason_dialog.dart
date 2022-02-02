import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';

class CancelRide extends StatefulWidget {
  const CancelRide({Key? key}) : super(key: key);

  @override
  _CancelRideState createState() => _CancelRideState();
}

class _CancelRideState extends State<CancelRide> {
  TextEditingController txtReason = TextEditingController();

  String dropdownvalue = 'I changed my mind.';

  // List of items in our dropdown menu
  var items = [
    'I changed my mind.',
    'I am facing some vehicle issue.',
    'Journey is not in my route.',
    'Other',
  ];
  bool isVisible=false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton(
          isExpanded: true,
          // Initial Value
          value: dropdownvalue,
          underline: Container(),
          // Down Arrow Icon
          icon: const Icon(Icons.keyboard_arrow_down),

          // Array list of items
          items: items.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(
                items,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AllColors.blueColor,
                    fontSize: 17),
              ),
            );
          }).toList(),
          // After selecting the desired option,it will
          // change button value to selected value
          onChanged: (String? newValue) {
            setState(() {

              dropdownvalue = newValue!;
              if(dropdownvalue=="Other"){
                isVisible=true;
              }else{
                isVisible=false;
              }
            });
          },
        ),
        isVisible? Column(
          children: [
            textField(
              controller: txtReason,
              errorText: "Please enter the reason for cancellation.",
              labelText: "Enter cancellation reason",
            ),
            SizedBox(height: 15,),
          ],
        ):Container(),
        AppButton(onPressed: () {}, text: "CANCEL RIDE", color: AllColors.blueColor)
      ],
    );
  }

  Widget textField({controller, labelText, errorText, prefixIcon}) {
    return TextFormField(
      controller: controller,
      cursorColor: AllColors.whiteColor,
      style:  TextStyle(color: AllColors.blueColor),
      validator: (value) {
        if (value!.isEmpty) {
          return errorText;
        }
        return null;
      },
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.deny(RegExp(" ")),
      ],
      decoration: InputDecoration(
        hintText: labelText,
        labelStyle:  TextStyle(color: AllColors.blueColor, fontSize: 17),
        border:  UnderlineInputBorder(
          borderSide: BorderSide(color: AllColors.blueColor),
        ),
        focusedBorder:  UnderlineInputBorder(
          borderSide: BorderSide(color: AllColors.blueColor),
        ),
        disabledBorder:  UnderlineInputBorder(
          borderSide: BorderSide(color: AllColors.blueColor),
        ),
        enabledBorder:  UnderlineInputBorder(
          borderSide: BorderSide(color: AllColors.blueColor),
        ),
      ),
    );
  }
}
