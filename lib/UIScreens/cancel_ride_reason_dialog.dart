import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';

class CancelRide extends StatefulWidget {
  final GestureTapCallback cancelTap;
  CancelRide({required this.cancelTap});

  @override
  _CancelRideState createState() => _CancelRideState();
}
String cancelReason = 'I changed my mind.';

class _CancelRideState extends State<CancelRide> {
  final TextEditingController txtReason = TextEditingController();


  // List of items in our dropdown menu
  final  List<String> _items = [
    'I changed my mind.',
    'I am facing some vehicle issue.',
    'Journey is not in my route.',
    'Other',
  ];
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton(
          isExpanded: true,
          value: cancelReason,
          underline: Container(),
          icon: const Icon(Icons.keyboard_arrow_down),
          items: _items.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(
                items,
                style: TextStyle(fontWeight: FontWeight.w400, color: AllColors.blueColor, fontSize: 17),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              cancelReason = newValue!;
              if (cancelReason == "Other") {
                _isVisible = true;
              } else {
                _isVisible = false;
              }
            });
          },
        ),
        _isVisible
            ? Column(
                children: [
                  textField(
                    controller: txtReason,
                    errorText: "Please enter the reason for cancellation.",
                    labelText: "Enter cancellation reason",
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              )
            : Container(),
        AppButton(onPressed: () {
          if(cancelReason=="Other"){
            cancelReason=txtReason.text;
          }
          widget.cancelTap();
        }, text: "CANCEL RIDE", color: AllColors.blueColor)
      ],
    );
  }

  Widget textField({controller, labelText, errorText, prefixIcon}) {
    return TextFormField(
      controller: controller,
      cursorColor: AllColors.whiteColor,
      style: TextStyle(color: AllColors.blueColor),
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
        labelStyle: TextStyle(color: AllColors.blueColor, fontSize: 17),
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
    );
  }
}
