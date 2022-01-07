import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/image_assets.dart';
import 'package:oyaridedriver/UIScreens/add_new_vehicle_screen.dart';

import 'drawer_screen.dart';

class VehicleManagementScreen extends StatefulWidget {
  const VehicleManagementScreen({Key? key}) : super(key: key);

  @override
  _VehicleManagementScreenState createState() =>
      _VehicleManagementScreenState();
}

class _VehicleManagementScreenState extends State<VehicleManagementScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey ,
      appBar: appBarWidget("Vehicle Management",_scaffoldKey),

      drawer: DrawerScreen(),
      body: Container(
        color: Colors.grey.shade100,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              vehicleListView(),
              SizedBox(
                height: 20,
              ),
              addNewVehicle()
            ],
          ),
        ),
      ),
    );
  }

  Widget vehicleListView() {
    return ListView.builder(
        itemCount: 2,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: Colors.grey.shade300),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0,top: 17,bottom: 17,right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AllColors.greenColor,
                        radius: 23,
                        child: Icon(Icons.car_rental,color: AllColors.whiteColor,),
                      ),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                             "Verna",
                              style: TextStyle(
                              fontSize: 19,
                              color: AllColors.blackColor,
                              fontWeight: FontWeight.w600
                              )),
                          Text(
                               "GJ21 8787",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: AllColors.blackColor,
                                  fontWeight: FontWeight.w600
                              )),
                        ],
                      ),
                    ],
                  ),
                   GestureDetector(
                     onTap: (){
                       Get.to(()=> const AddNewVehicleScreen());
                     },
                     child: Text(
                        "EDIT",
                        style: TextStyle(
                            fontSize: 18,
                            color: AllColors.greenColor,
                            fontWeight: FontWeight.w600
                        )),
                   ),
                ],
              ),
            ),
          );
        });
  }

  Widget addNewVehicle() {
    return Container(
      padding: const EdgeInsets.only(left: 35, right: 35, bottom: 15),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Get.to(()=> const AddNewVehicleScreen());
        },
        style: buttonStyleGreen(),
        child: const Text(
          "ADD NEW VEHICLE",
          style: TextStyle(
              color: AllColors.whiteColor,
              fontSize: 17,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
