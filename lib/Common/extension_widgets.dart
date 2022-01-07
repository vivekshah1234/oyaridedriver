import 'package:flutter/material.dart';


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
