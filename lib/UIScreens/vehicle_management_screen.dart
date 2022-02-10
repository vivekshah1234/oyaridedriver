import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Models/vehicle_list_model.dart';
import 'package:oyaridedriver/UIScreens/add_new_vehicle_screen.dart';
import 'package:oyaridedriver/controllers/vehicle_controller.dart';

import 'drawer_screen.dart';

class VehicleManagementScreen extends StatefulWidget {
  const VehicleManagementScreen({Key? key}) : super(key: key);

  @override
  _VehicleManagementScreenState createState() => _VehicleManagementScreenState();
}

class _VehicleManagementScreenState extends State<VehicleManagementScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final VehicleController _vehicleController = Get.put(VehicleController());

  @override
  void initState() {
    _vehicleController.getVehicles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarWidget("Vehicle Management", _scaffoldKey),
      drawer: const DrawerScreen(),
      body: Container(
        color: Colors.grey.shade100,
        height: double.infinity,
        child: GetX<VehicleController>(
            init: VehicleController(),
            builder: (controller) {
              if (controller.isLoading.value) {
                return Center(child: greenLoadingWidget());
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    vehicleListView(),
                    const SizedBox(
                      height: 20,
                    ),
                    AppButton(
                            onPressed: () async {
                              await Get.to(() => AddNewVehicleScreen(
                                    toEdit: false,
                                  ));
                              _vehicleController.getVehicles();
                            },
                            text: "ADD NEW VEHICLE",
                            color: AllColors.greenColor)
                        .paddingSymmetric(horizontal: 35)
                  ],
                ),
              );
            }),
      ),
    );
  }

  Widget vehicleListView() {
    return ListView.builder(
        itemCount: _vehicleController.vehicleList.length,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          VehicleList vehicle = _vehicleController.vehicleList[index];

          return GestureDetector(
            onTap: () async {
              await Get.to(() => AddNewVehicleScreen(
                    toEdit: true,
                    txtCarNumber: vehicle.licencePlate.toString(),
                    txtColor: vehicle.vehicleColor.toString(),
                    txtTaxiType: vehicle.vehicleTypeId.toString(),
                    txtVehicleBrand: vehicle.vehicleManufacturer.toString(),
                    txtVehicleModel: vehicle.vehicleModel.toString(),
                    txtVehicleYear: vehicle.vehicleYear.toString(),
                    vehicleId: vehicle.id.toString(),
                  ));
              _vehicleController.getVehicles();
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey.shade300),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0, top: 17, bottom: 17, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AllColors.greenColor,
                          radius: 23,
                          child: const Icon(
                            Icons.car_rental,
                            color: AllColors.whiteColor,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(vehicle.vehicleModel,
                                style: const TextStyle(
                                    fontSize: 19, color: AllColors.blackColor, fontWeight: FontWeight.w600)),
                            Text(vehicle.licencePlate,
                                style: const TextStyle(
                                    fontSize: 15, color: AllColors.blackColor, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 30,
                      child: RadioListTile(
                        groupValue: vehicle.isActiveVehicle,
                        value: index,
                        tileColor: Colors.white,
                        selectedTileColor: Colors.white,
                        activeColor: AllColors.greenColor,
                        onChanged: (val) {
                          setState(() {
                            // radioItemHolder = nList[i].number;

                            Map<String, String> map = {"vehicle_id": vehicle.id.toString()};
                            setState(() {});
                            _vehicleController.changeActiveVehicle(map, context);
                            // vehicleController.getVehicles();
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
