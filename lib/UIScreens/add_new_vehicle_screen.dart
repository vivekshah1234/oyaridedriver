import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/extension_widgets.dart';
// ignore_for_file: prefer_const_constructors


class AddNewVehicleScreen extends StatefulWidget {
  const AddNewVehicleScreen({Key? key}) : super(key: key);

  @override
  _AddNewVehicleScreenState createState() => _AddNewVehicleScreenState();
}

class _AddNewVehicleScreenState extends State<AddNewVehicleScreen> {


  TextEditingController txtVehicleBrand=TextEditingController();
  TextEditingController txtCarNumber=TextEditingController();
  TextEditingController txtColor=TextEditingController();
  TextEditingController txtTaxiType=TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey ,
      appBar: appBarWidget2("Add New Vehicle"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textFieldWithoutIcon(
                controller: txtVehicleBrand,
                labelText: "Vehicle Brand",
                errorText: "Please Enter Vehicle Brand."),
            SizedBox(height: 20,),
          textWidget(txt: "Model", fontSize: 13, color: AllColors.greyColor, bold: false, italic: false),
          modelDropDown(),
            textWidget(txt: "Year", fontSize: 13, color: AllColors.greyColor, bold: false, italic: false),

            yearDropDown(),
            textFieldWithoutIcon(controller: txtCarNumber,labelText: "Car Number",errorText: "Please Enter Car Number."),
            textFieldWithoutIcon(controller: txtColor,labelText: "Colour",errorText: "Please Enter Car Colour."),
            textFieldWithoutIcon(controller: txtTaxiType,labelText: "Taxi Type",errorText: "Please Enter Taxi Type."),
            SizedBox(height: 20,),
            greenButton(txt: "ADD",function: (){
              //Get.to(()=> const LicenceDetailScreen());
            }),
          ],).putPadding(20, 20, 30, 30),
      ),
    );
  }

 String valueOfDD="Amaze";
  Widget modelDropDown(){
    return DropdownButton<String>(
      isExpanded: true,
      underline: Divider(color: Colors.grey.shade900,height: 2,) ,
      value:valueOfDD ,
      style: TextStyle(),
      items: <String>['Amaze', 'Audi', 'Ferrari', 'Hundai'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,

          child: Text(value,style: TextStyle(color: Colors.black),),
        );
      }).toList(),
      onChanged: (val) {
        valueOfDD=val!;
        setState(() {

        });
      },
    );
  }
  String valueOfDDForYear="1996";
  Widget yearDropDown(){
    return DropdownButton<String>(
      isExpanded: true,
      underline: Divider(color: Colors.grey.shade900,height: 2,) ,
      value:valueOfDDForYear ,
      style: TextStyle(),
      items: <String>['1996', '2002', '2005', '2008'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,

          child: Text(value,style: TextStyle(color: Colors.black),),
        );
      }).toList(),
      onChanged: (val) {
        valueOfDDForYear=val!;
        setState(() {

        });
      },
    );
  }
}
