import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/extension_widgets.dart';
import 'package:oyaridedriver/Models/vehicle_type_model.dart';
import 'package:oyaridedriver/UIScreens/rider_cart_screen.dart';
import 'package:oyaridedriver/controllers/add_vehicle_controller.dart';
import 'package:oyaridedriver/controllers/vehicle_controller.dart';
// ignore_for_file: prefer_const_constructors

class AddNewVehicleScreen extends StatefulWidget {
  const AddNewVehicleScreen({Key? key}) : super(key: key);

  @override
  _AddNewVehicleScreenState createState() => _AddNewVehicleScreenState();
}

class _AddNewVehicleScreenState extends State<AddNewVehicleScreen> {
  TextEditingController txtVehicleBrand = TextEditingController();
  TextEditingController txtVehicleModel = TextEditingController();
  TextEditingController txtVehicleYear = TextEditingController();
  TextEditingController txtCarNumber = TextEditingController();
  TextEditingController txtColor = TextEditingController();
  TextEditingController txtTaxiType = TextEditingController();
final AddNewVehicleController addVehicleController = Get.put(AddNewVehicleController());
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    addVehicleController.getVehicleType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: appBarWidget2("Add New Vehicle"),
      body: GetX<AddNewVehicleController>(
          init: AddNewVehicleController(),
          builder: (controller) {
            return Stack(
              alignment: Alignment.center,
              children: [
                SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textFieldWithoutIcon(
                            controller: txtVehicleBrand,
                            labelText: "Vehicle Brand",
                            errorText: "Please Enter Vehicle Brand."),

                        textFieldWithoutIcon(
                            controller: txtVehicleModel,
                            labelText: "Model",
                            errorText: "Please Enter Car Model."),
                        textFieldWithoutIcon(
                            controller: txtVehicleYear,
                            labelText: "Year",
                            errorText: "Please Enter Car year."),
                        textFieldWithoutIcon(
                            controller: txtCarNumber,
                            labelText: "Car Number",
                            errorText: "Please Enter Car Number."),
                        textFieldWithoutIcon(
                            controller: txtColor,
                            labelText: "Colour",
                            errorText: "Please Enter Car Colour."),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Vehicle type",
                          style:
                              TextStyle(color: AllColors.greyColor, fontSize: 13),
                        ),

                        DropdownButton(
                          isExpanded: true,
                          underline: Divider(
                            color: Colors.grey.shade900,
                            height: 2,
                          ),
                          value: controller.selectedVehicleType.value,
                          style: TextStyle(),
                          items: controller.vehicleTypes.map((value) {
                            return DropdownMenuItem(
                              value: value.name,
                              child: Text(
                                value.name,
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            controller.selectedVehicleType.value = val.toString();
                            setState(() {});
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        AppButton(
                            text: "ADD",
                            onPressed: addVehicle,
                            color: AllColors.greenColor),
                      ],
                    ).putPadding(20, 20, 30, 30),
                  ),
                ),
                Visibility(
                    visible: controller.isLoading.value,
                    child: greenLoadingWidget())
              ],
            );
          }),
    );
  }

  addVehicle() {
    if(formKey.currentState!.validate()){
    Map<String, String> _map = {
      "vehicle_color": txtColor.text.toString(),
      "vehicle_manufacturer": txtVehicleBrand.text.toString(),
      "vehicle_model": txtVehicleModel.text.toString(),
      "vehicle_year": txtVehicleYear.text.toString(),
      "vehicle_type_id": "1",
    };
    addVehicleController.addNewVehicle(_map, context);
    }
  }


}
