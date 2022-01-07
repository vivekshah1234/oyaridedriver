import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/image_assets.dart';
import 'package:oyaridedriver/Common/extension_widgets.dart';
import 'package:sized_context/src/extensions.dart';

import 'document_sent_screen.dart';
import 'map_screen.dart';

class LicenceDetailScreen extends StatefulWidget {
  const LicenceDetailScreen({Key? key}) : super(key: key);

  @override
  _LicenceDetailScreenState createState() => _LicenceDetailScreenState();
}

class _LicenceDetailScreenState extends State<LicenceDetailScreen> {
  TextEditingController txtLicenceNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget2(""),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: textWidget(
                  txt: "Legal details",
                  fontSize: 26,
                  color: AllColors.blackColor,
                  bold: true,
                  italic: false),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: textWidget(
                  txt: "Only your first name and Vehicle details",
                  fontSize: 16,
                  color: Colors.black54,
                  bold: false,
                  italic: false),
            ),
            Center(
              child: textWidget(
                  txt: "are visible to clients during booking.",
                  fontSize: 16,
                  color: Colors.black54,
                  bold: false,
                  italic: false),
            ),
            textField(
                controller: txtLicenceNumber,
                labelText: "Driver License Number",
                prefixIcon: ImageAssets.licenceIcon),
            Align(
                alignment: Alignment.topLeft,
                child: textWidget(
                        txt: "Licence details are kept private",
                        fontSize: 13,
                        bold: false,
                        italic: true,
                        color: AllColors.greyColor)
                    .putPadding(5, 0, 0, 35)),
            const SizedBox(
              height: 20,
            ),
            greenButton(txt: "NEXT",function: () {
              Get.to(() => const LicenceDocumentScreen());
            }).paddingOnly(left: context.widthPct(.15),right: context.widthPct(.15))
              ],
        ).putPadding(0, 0, 15, 15),
      ),
    );
  }

  Widget textField({controller, labelText, errorText, prefixIcon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Image.asset(
          prefixIcon,
          scale: 10,
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: TextField(
            controller: controller,
            cursorColor: AllColors.blackColor,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle:
                  const TextStyle(color: AllColors.greyColor, fontSize: 13),
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: AllColors.greyColor),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AllColors.greyColor),
              ),
              disabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AllColors.greyColor),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AllColors.greyColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LicenceDocumentScreen extends StatefulWidget {
  const LicenceDocumentScreen({Key? key}) : super(key: key);

  @override
  _LicenceDocumentScreenState createState() => _LicenceDocumentScreenState();
}

class _LicenceDocumentScreenState extends State<LicenceDocumentScreen> {

  TextEditingController txtLine1=TextEditingController();
  TextEditingController txtLine2=TextEditingController();
  TextEditingController txtLine3=TextEditingController();
  FontWeight bold1=FontWeight.w400;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget2(""),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: textWidget(
                  txt: "Documents",
                  fontSize: 26,
                  color: AllColors.blackColor,
                  bold: true,
                  italic: false),
            ),
            const SizedBox(
              height: 10,
            ),
             Center(
              child: Text(
                  "We're legally required to ask for some documents to sign you up as a driver. Documents scans and quality photos are accepted.",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16,
                    color:  Colors.black54,
                    fontWeight: bold1
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Driver's License",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 22,
                    color: AllColors.blackColor,
                    fontWeight: FontWeight.w500)),
           const SizedBox(height: 7,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

              textWidget(txt: "expires", fontSize: 13, color: AllColors.greyColor, bold: false, italic: true),
              textWidget(txt: "Required*", fontSize: 12, color: AllColors.redColor, bold: false, italic: false),

            ],),
            textField(txtLine1),
            textField(txtLine2),
            textField(txtLine3),
            const SizedBox(height: 15,),
            Align(
                alignment: Alignment.centerRight,
                child: file!=null?fileWidget():uploadFile()),
            const SizedBox(height: 15,),
            Row(   mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children:  <Widget>[
                 const Text("Driver's License",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 22,
                        color: AllColors.blackColor,
                        fontWeight: FontWeight.w500)),
                textWidget(txt: "Required*", fontSize: 12, color: AllColors.redColor, bold: false, italic: false),

              ],
            ),
            const SizedBox(height: 7,),

             Center(
              child: Text(
                  "Please provide a clear portrait picture(not a full body picture) of yourself. It should show your full face, front view, with eyes open.",textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: bold1
                  )),
            ),   const SizedBox(height: 15,),
            Align(
                alignment: Alignment.centerRight,
                child:file2!=null?fileWidget2() :uploadFile2()),
            const SizedBox(height: 15,),
            nextButton()
          ],
        ).putPadding(0, 0, 25, 25),
      ),
    );
  }

  Widget textField(controller,){
    return TextField(
      controller: controller,
      cursorColor: AllColors.blackColor,
      textInputAction:controller==txtLine3?TextInputAction.done: TextInputAction.next,
      decoration:const InputDecoration(

        border:  UnderlineInputBorder(
          borderSide: BorderSide(color: AllColors.greyColor),
        ),
        focusedBorder:  UnderlineInputBorder(
          borderSide: BorderSide(color: AllColors.greyColor),
        ),
        disabledBorder:  UnderlineInputBorder(
          borderSide: BorderSide(color: AllColors.greyColor),
        ),
        enabledBorder:  UnderlineInputBorder(
          borderSide: BorderSide(color: AllColors.greyColor),
        ),
      ),
    );
  }

  Widget fileWidget(){
    return Container(
      width: MediaQuery.of(context).size.width*0.40,
      decoration: BoxDecoration( color: AllColors.greenColor, borderRadius: BorderRadius.circular(15)),
    padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 10),
    child: Row(
      children: [
        Expanded(
          child: Text(file.name.toString().substring(0,20),
            overflow: TextOverflow.ellipsis,
            style:const TextStyle( color: AllColors.whiteColor,fontSize: 14),),
        ),
        const SizedBox(width: 5,),
        GestureDetector(
            onTap: (){
              file=null;
              setState(() {

              });
            },
            child: const Icon(Icons.close,color: Colors.white,))
      ],
    ),

    );
  }
  Widget fileWidget2(){
    return Container(
      width: MediaQuery.of(context).size.width*0.40,
      decoration: BoxDecoration( color: AllColors.greenColor, borderRadius: BorderRadius.circular(15)),
      padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(file2.name.toString().substring(0,20),
              overflow: TextOverflow.ellipsis,
              style:const TextStyle( color: AllColors.whiteColor,fontSize: 14),),
          ),
          const SizedBox(width: 5,),
          GestureDetector(
              onTap: (){
                file2=null;
                setState(() {

                });
              },
              child: const Icon(Icons.close,color: Colors.white,))
        ],
      ),

    );
  }
  Widget nextButton(){
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 45, right: 45),
      child: ElevatedButton(
        onPressed: (){
          Get.to(()=> const MapHomeScreen());
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(AllColors.blueColor),
            shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
              return RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25));
            }),
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.only(top: 10, bottom: 10))),
        child:const Text(
          "NEXT",
          style:  TextStyle(
              color: AllColors.whiteColor,
              fontSize: 17,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget uploadFile(){
    return  SizedBox(
      width: MediaQuery.of(context).size.width*0.40,
      child: ElevatedButton(
          onPressed: (){
            pickImage();
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(AllColors.greenColor),
              shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
                return RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25));
              }),
              padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.only(top: 5, bottom: 5))),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Icon(Icons.add,color: AllColors.whiteColor,),
               Text(
                "UPLOAD FILE",
                style:  TextStyle(
                    color: AllColors.whiteColor,
                    fontSize: 13,
                   ),
              ),
            ],
          ),

      ),
    );
  }
  var file;

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

    }catch(ex){
      debugPrint(ex.toString());
    }
  }

  var file2;

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

    }catch(ex){
      debugPrint(ex.toString());
    }
  }
  Widget uploadFile2(){
    return  SizedBox(
      width: MediaQuery.of(context).size.width*0.40,
      child: ElevatedButton(
        onPressed: (){
          pickImage2();
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(AllColors.greenColor),
            shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
              return RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25));
            }),
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.only(top: 5, bottom: 5))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Icon(Icons.add,color: AllColors.whiteColor,),
            Text(
              "UPLOAD FILE",
              style:  TextStyle(
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
