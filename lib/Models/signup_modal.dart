class SignupModel {
  SignupModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final int status;
  late final String message;
  late final List<Data> data;

  SignupModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.driverId,
  });
  late final int driverId;

  Data.fromJson(Map<String, dynamic> json){
    driverId = json['driverId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['driverId'] = driverId;
    return _data;
  }
}