
class VehicleTypeModel {
  VehicleTypeModel({
    required this.status,
    required this.data,
    required this.message,
  });
  late final int status;
  late final List<VehicleTypes> data;
  late final String message;

  VehicleTypeModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    data = List.from(json['data']).map((e)=>VehicleTypes.fromJson(e)).toList();
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

class VehicleTypes {
  VehicleTypes({
    required this.id,
    required this.name,
    required this.price,
    this.image,
    required this.seat,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String name;
  late final String price;
  late final Null image;
  late final int seat;
  late final String createdAt;
  late final String updatedAt;

  VehicleTypes.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    price = json['price'];
    image = null;
    seat = json['seat'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['price'] = price;
    _data['image'] = image;
    _data['seat'] = seat;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}