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

  const AddNewVehicleScreen(
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
  final TextEditingController _txtVehicleBrand = TextEditingController();
  final TextEditingController _txtVehicleModel = TextEditingController();
  final TextEditingController _txtVehicleYear = TextEditingController();
  final TextEditingController _txtCarNumber = TextEditingController();
  final TextEditingController _txtColor = TextEditingController();
  final TextEditingController _txtTaxiType = TextEditingController();
  final AddNewVehicleController _addVehicleController = Get.put(AddNewVehicleController());
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.toEdit == true) {
      //  printInfo(info: "aaaa");
      _txtVehicleBrand.text = widget.txtVehicleBrand;
      _txtVehicleModel.text = widget.txtVehicleModel;
      _txtVehicleYear.text = widget.txtVehicleYear;
      _txtTaxiType.text = widget.txtTaxiType;
      _txtCarNumber.text = widget.txtCarNumber;
      _txtColor.text = widget.txtColor;
    }
    _addVehicleController.getVehicleType();

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
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textFieldWithoutIcon(
                            controller: _txtVehicleBrand,
                            labelText: "Vehicle Brand",
                            errorText: "Please Enter Vehicle Brand."),
                        textFieldWithoutIcon(
                            controller: _txtVehicleModel, labelText: "Model", errorText: "Please Enter Car Model."),
                        textFieldWithoutIcon(
                            controller: _txtVehicleYear, labelText: "Year", errorText: "Please Enter Car year."),
                        textFieldWithoutIcon(
                            controller: _txtCarNumber, labelText: "Car Number", errorText: "Please Enter Car Number."),
                        textFieldWithoutIcon(
                            controller: _txtColor, labelText: "Colour", errorText: "Please Enter Car Colour."),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Vehicle type",
                          style: TextStyle(color: AllColors.greyColor, fontSize: 13),
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
                            controller.selectedVehicleType.value = val.toString();
                            VehicleTypes findId(String name) =>
                                controller.vehicleTypes.firstWhere((value) => value.name == name);
                            printInfo(info: findId(val.toString()).id.toString());
                            selectedIndex = findId(val.toString()).id;
                            setState(() {});
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        AppButton(text: "ADD", onPressed: addVehicle, color: AllColors.greenColor),
                      ],
                    ).putPadding(20, 20, 30, 30),
                  ),
                ),
                Visibility(visible: controller.isLoading.value, child: greenLoadingWidget())
              ],
            );
          }),
    );
  }

  addVehicle() {
    if (_formKey.currentState!.validate()) {
      if (widget.toEdit) {
        Map<String, String> _map = {
          "vehicle_color": _txtColor.text.toString(),
          "vehicle_manufacturer": _txtVehicleBrand.text.toString(),
          "vehicle_model": _txtVehicleModel.text.toString(),
          "vehicle_year": _txtVehicleYear.text.toString(),
          "licence_plate": _txtCarNumber.text.toString(),
          "vehicle_type_id": selectedIndex.toString(),
          "vehicle_id": widget.vehicleId.toString()
        };
        _addVehicleController.editVehicle(_map, context);
      } else {
        Map<String, String> _map = {
          "vehicle_color": _txtColor.text.toString(),
          "vehicle_manufacturer": _txtVehicleBrand.text.toString(),
          "vehicle_model": _txtVehicleModel.text.toString(),
          "vehicle_year": _txtVehicleYear.text.toString(),
          "licence_plate": _txtCarNumber.text.toString(),
          "vehicle_type_id": selectedIndex.toString(),
        };
        _addVehicleController.addNewVehicle(_map, context);
      }
    }
  }
}
