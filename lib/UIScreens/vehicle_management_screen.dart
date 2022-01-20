import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/UIScreens/add_new_vehicle_screen.dart';

import 'drawer_screen.dart';

class VehicleManagementScreen extends StatefulWidget {
  const VehicleManagementScreen({Key? key}) : super(key: key);

  @override
  _VehicleManagementScreenState createState() =>
      _VehicleManagementScreenState();
}

class _VehicleManagementScreenState extends State<VehicleManagementScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey =  GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey ,
      appBar: appBarWidget("Vehicle Management",_scaffoldKey),

      drawer: const DrawerScreen(),
      body: Container(
        color: Colors.grey.shade100,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              vehicleListView(),
              const SizedBox(
                height: 20,
              ),
              AppButton(onPressed: (){
                Get.to(()=> const AddNewVehicleScreen());
              }, text: "ADD NEW VEHICLE", color: AllColors.greenColor)
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
                        child: const Icon(Icons.car_rental,color: AllColors.whiteColor,),
                      ),
                      const SizedBox(width: 10,),
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

}
