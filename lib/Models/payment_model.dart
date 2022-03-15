class PaymentModel {
  PaymentModel({
    required this.status,
    required this.paymentData,
    required this.message,
  });
  late final int status;
  late final PaymentData paymentData;
  late final String message;

  PaymentModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    paymentData = PaymentData.fromJson(json['paymentData']);
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['paymentData'] = paymentData.toJson();
    _data['message'] = message;
    return _data;
  }
}

class PaymentData {
  PaymentData({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final Data data;

  PaymentData.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.authorizationUrl,
    required this.accessCode,
    required this.reference,
  });
  late final String authorizationUrl;
  late final String accessCode;
  late final String reference;

  Data.fromJson(Map<String, dynamic> json){
    authorizationUrl = json['authorization_url'];
    accessCode = json['access_code'];
    reference = json['reference'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['authorization_url'] = authorizationUrl;
    _data['access_code'] = accessCode;
    _data['reference'] = reference;
    return _data;
  }
}