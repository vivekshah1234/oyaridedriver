import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import 'all_colors.dart';

extension TextModifier on Widget {
  Widget centerTheText() {
    return Center(
      child: this,
    );
  }

  Widget text(String txt, double size) {
    return Text(
      txt,
      style: TextStyle(
        color: Colors.white,
        fontSize: size,
      ),
    );
  }
}

extension PaddingOnWidget on Widget {
  Widget putPaddingOnAll(double size) {
    return Padding(
      padding: EdgeInsets.all(size),
      child: this,
    );
  }

  Widget putPadding(double top, double bottom, double right, double left) {
    return Padding(
      padding:
          EdgeInsets.only(top: top, bottom: bottom, left: left, right: right),
      child: this,
    );
  }
}

extension AlertDialogCard on Widget {
  Widget alertCard(context) => AlertDialog(
        backgroundColor: Colors.transparent,
        //elevation: 0,
        actions: [
          Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 20,
                  ),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AllColors.whiteColor,
                        borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.only(right: 10),
                    child: Column(
                      children: [

                        const SizedBox(
                          height: 15,
                        ),
                        this,
                        const SizedBox(
                          height: 15,
                        ),
                        // redButtonWidget("Verify", function: verifyFun)
                        //     .putPaddingOnAll(10),
                        // SizedBox(
                        //   height: 30,
                        // ),
                      ],
                    ).putPadding(10, 10, 25, 25),
                  ),
                ],
              ),
              Positioned(
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child:   Icon(
                      Icons.highlight_remove_sharp,
                      color: AllColors.blueColor,
                      size: 40,
                    ),
                  ))
            ],
          )
        ],
      );
}
