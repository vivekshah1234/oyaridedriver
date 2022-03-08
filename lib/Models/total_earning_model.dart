class TotalEarningModel {
  TotalEarningModel({
    required this.status,
    required this.data,
    required this.message,
  });
  late final int status;
  late final Data data;
  late final String message;

  TotalEarningModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    data = Data.fromJson(json['data']);
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data.toJson();
    _data['message'] = message;
    return _data;
  }
}

class Data {
  Data({
    required this.jobs,
    required this.earning,
  });
  late final int jobs;
  late final String earning;

  Data.fromJson(Map<String, dynamic> json){
    jobs = json['jobs'];
    earning = json['earning'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['jobs'] = jobs;
    _data['earning'] = earning;
    return _data;
  }
}