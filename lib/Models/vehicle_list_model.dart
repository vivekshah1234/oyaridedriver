class VehicleListModel {
  VehicleListModel({
    required this.status,
    required this.data,
    required this.message,
  });
  late final int status;
  late final List<VehicleList> data;
  late final String message;

  VehicleListModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    data = List.from(json['data']).map((e)=>VehicleList.fromJson(e)).toList();
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    _data['message'] = message;
    return _data;
  }
}

class VehicleList {
  VehicleList({
    required this.id,
    required this.userId,
    required this.vehicleManufacturer,
    required this.vehicleModel,
    required this.vehicleYear,
    required this.vehicleColor,
    this.vehicleTypeId,
    required this.isActiveVehicle,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final int userId;
  late final String vehicleManufacturer;
  late final String vehicleModel;
  late final String vehicleYear;
  late final String vehicleColor;
  late final dynamic vehicleTypeId;
  late final int isActiveVehicle;
  late final String createdAt;
  late final String updatedAt;

  VehicleList.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userId = json['user_id'];
    vehicleManufacturer = json['vehicle_manufacturer'];
    vehicleModel = json['vehicle_model'];
    vehicleYear = json['vehicle_year'];
    vehicleColor = json['vehicle_color'];
    vehicleTypeId = null;
    isActiveVehicle = json['is_active_vehicle'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['user_id'] = userId;
    _data['vehicle_manufacturer'] = vehicleManufacturer;
    _data['vehicle_model'] = vehicleModel;
    _data['vehicle_year'] = vehicleYear;
    _data['vehicle_color'] = vehicleColor;
    _data['vehicle_type_id'] = vehicleTypeId;
    _data['is_active_vehicle'] = isActiveVehicle;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}