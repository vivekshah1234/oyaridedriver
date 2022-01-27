import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/extension_widgets.dart';
import 'package:oyaridedriver/Models/vehicle_type_model.dart';
import 'package:oyaridedriver/controllers/add_vehicle_controller.dart';

class AddNewVehicleScreen extends StatefulWidget {
  final bool toEdit;
  final dynamic txtVehicleBrand;
  final dynamic txtVehicleModel;
  final dynamic txtVehicleYear;
  final dynamic txtCarNumber;
  final dynamic txtColor;
  final dynamic txtTaxiType;
  final dynamic vehicleId;

  AddNewVehicleScreen(
      {required this.toEdit,
      this.txtCarNumber,
      this.txtVehicleYear,
      this.txtVehicleModel,
      this.txtVehicleBrand,
      this.txtColor,
      this.txtTaxiType,
      this.vehicleId});

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
  final AddNewVehicleController addVehicleController =
      Get.put(AddNewVehicleController());
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.toEdit == true) {
      //  printInfo(info: "aaaa");
      txtVehicleBrand.text = widget.txtVehicleBrand;
      txtVehicleModel.text = widget.txtVehicleModel;
      txtVehicleYear.text = widget.txtVehicleYear;
      txtTaxiType.text = widget.txtTaxiType;
      txtCarNumber.text = widget.txtCarNumber;
      txtColor.text = widget.txtColor;
    }
    addVehicleController.getVehicleType();

    super.initState();
  }

  int selectedIndex = 1;

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
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Vehicle type",
                          style: TextStyle(
                              color: AllColors.greyColor, fontSize: 13),
                        ),
                        DropdownButton(
                          isExpanded: true,
                          underline: Divider(
                            color: Colors.grey.shade900,
                            height: 2,
                          ),
                          value: controller.selectedVehicleType.value,
                          style: const TextStyle(),
                          items: controller.vehicleTypes.map((value) {
                            return DropdownMenuItem(
                              value: value.name,
                              child: Text(
                                value.name,
                                style: const TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            printInfo(info: val.toString());
                            controller.selectedVehicleType.value =
                                val.toString();
                            VehicleTypes findId(String name) =>
                                controller.vehicleTypes
                                    .firstWhere((value) => value.name == name);
                            printInfo(
                                info: findId(val.toString()).id.toString());
                            selectedIndex = findId(val.toString()).id;
                            setState(() {});
                          },
                        ),
                        const SizedBox(
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
    if (formKey.currentState!.validate()) {
      if (widget.toEdit) {
        Map<String, String> _map = {
          "vehicle_color": txtColor.text.toString(),
          "vehicle_manufacturer": txtVehicleBrand.text.toString(),
          "vehicle_model": txtVehicleModel.text.toString(),
          "vehicle_year": txtVehicleYear.text.toString(),
          "licence_plate": txtCarNumber.text.toString(),
          "vehicle_type_id": selectedIndex.toString(),
          "vehicle_id": widget.vehicleId.toString()
        };
        addVehicleController.editVehicle(_map, context);
      } else {
        Map<String, String> _map = {
          "vehicle_color": txtColor.text.toString(),
          "vehicle_manufacturer": txtVehicleBrand.text.toString(),
          "vehicle_model": txtVehicleModel.text.toString(),
          "vehicle_year": txtVehicleYear.text.toString(),
          "licence_plate": txtCarNumber.text.toString(),
          "vehicle_type_id": selectedIndex.toString(),
        };
        addVehicleController.addNewVehicle(_map, context);
      }
    }
  }
}
