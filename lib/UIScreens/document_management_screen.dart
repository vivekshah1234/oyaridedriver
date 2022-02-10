import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/extension_widgets.dart';

import 'drawer_screen.dart';

class DocumentManagementScreen extends StatefulWidget {
  final bool isFromRegistration;

  const DocumentManagementScreen(this.isFromRegistration, {Key? key}) : super(key: key);

  @override
  _DocumentManagementScreenState createState() => _DocumentManagementScreenState();
}

class _DocumentManagementScreenState extends State<DocumentManagementScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _txtLine1 = TextEditingController();
  final TextEditingController _txtLine2 = TextEditingController();
  final TextEditingController _txtLine3 = TextEditingController();
  final FontWeight _bold1 = FontWeight.w400;
  var file;
  var file2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarWidget("", _scaffoldKey),
      drawer: const DrawerScreen(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: textWidget(
                  txt: "Documents", fontSize: 26, color: AllColors.blackColor, bold: FontWeight.w600, italic: false),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                  "We're legally required to ask for some documents to sign you up as a driver. Documents scans and quality photos are accepted.",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: _bold1)),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Driver's License",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 22, color: AllColors.blackColor, fontWeight: FontWeight.w500)),
            const SizedBox(
              height: 7,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textWidget(
                    txt: "expires", fontSize: 13, color: AllColors.greyColor, bold: FontWeight.normal, italic: true),
                textWidget(
                    txt: "Required*", fontSize: 12, color: AllColors.redColor, bold: FontWeight.normal, italic: false),
              ],
            ),
            textField(_txtLine1),
            textField(_txtLine2),
            textField(_txtLine3),
            const SizedBox(
              height: 15,
            ),
            Align(alignment: Alignment.centerRight, child: file != null ? fileWidget() : uploadFile()),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text("Driver's License",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 22, color: AllColors.blackColor, fontWeight: FontWeight.w500)),
                textWidget(
                    txt: "Required*", fontSize: 12, color: AllColors.redColor, bold: FontWeight.normal, italic: false),
              ],
            ),
            const SizedBox(
              height: 7,
            ),
            Center(
              child: Text(
                  "Please provide a clear portrait picture(not a full body picture) of yourself. It should show your full face, front view, with eyes open.",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: _bold1)),
            ),
            const SizedBox(
              height: 15,
            ),
            Align(alignment: Alignment.centerRight, child: file2 != null ? fileWidget2() : uploadFile2()),
            const SizedBox(
              height: 15,
            ),
            AppButton(onPressed: () {}, text: "UPDATE", color: AllColors.blueColor).putPadding(0, 0, 45, 45)
          ],
        ).putPadding(0, 0, 25, 25),
      ),
    );
  }

  Widget textField(
    controller,
  ) {
    return TextField(
      controller: controller,
      cursorColor: AllColors.blackColor,
      textInputAction: controller == _txtLine3 ? TextInputAction.done : TextInputAction.next,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: AllColors.greyColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AllColors.greyColor),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AllColors.greyColor),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AllColors.greyColor),
        ),
      ),
    );
  }

  Widget fileWidget() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.40,
      decoration: BoxDecoration(color: AllColors.greenColor, borderRadius: BorderRadius.circular(15)),
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              file.name.toString().substring(0, 20),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AllColors.whiteColor, fontSize: 14),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
              onTap: () {
                file = null;
                setState(() {});
              },
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ))
        ],
      ),
    );
  }

  Widget fileWidget2() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.40,
      decoration: BoxDecoration(color: AllColors.greenColor, borderRadius: BorderRadius.circular(15)),
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              file2.name.toString().substring(0, 20),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AllColors.whiteColor, fontSize: 14),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
              onTap: () {
                file2 = null;
                setState(() {});
              },
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ))
        ],
      ),
    );
  }

  pickImage() async {
    final ImagePicker _picker = ImagePicker();
    try {
      XFile? image = await _picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        setState(() {
          file = XFile(image.path);
        });
        // toast( image!.path.toString());
      }
    } catch (ex) {
      debugPrint(ex.toString());
    }
  }

  pickImage2() async {
    final ImagePicker _picker2 = ImagePicker();
    try {
      XFile? image2 = await _picker2.pickImage(source: ImageSource.camera);

      if (image2 != null) {
        setState(() {
          file2 = XFile(image2.path);
        });
        // toast( image!.path.toString());
      }
    } catch (ex) {
      debugPrint(ex.toString());
    }
  }

  Widget uploadFile() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.40,
      child: ElevatedButton(
        onPressed: () {
          pickImage();
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(AllColors.greenColor),
            shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
              return RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));
            }),
            padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.only(top: 5, bottom: 5))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Icon(
              Icons.add,
              color: AllColors.whiteColor,
            ),
            Text(
              "UPLOAD FILE",
              style: TextStyle(
                color: AllColors.whiteColor,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget uploadFile2() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.40,
      child: ElevatedButton(
        onPressed: () {
          pickImage2();
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(AllColors.greenColor),
            shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
              return RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));
            }),
            padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.only(top: 5, bottom: 5))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Icon(
              Icons.add,
              color: AllColors.whiteColor,
            ),
            Text(
              "UPLOAD FILE",
              style: TextStyle(
                color: AllColors.whiteColor,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
