class RequestModel {
  RequestModel({
    required this.id,
    required this.userId,
    this.driverId,
    this.vehicleId,
    required this.vehicleType,
    required this.sourceAddress,
    required this.sourceCity,
    required this.sourceState,
    required this.sourceCountry,
    required this.sourceZipcode,
    required this.sourceLatitude,
    required this.sourceLongitude,
    required this.destinationCity,
    required this.destinationState,
    required this.destinationCountry,
    required this.destinationZipcode,
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.destinationAddress,
    required this.kilometer,
    required this.polygone,
    required this.status,
    this.customerCancellation,
    this.driverCancellation,
    required this.createdAt,
    required this.updatedAt,
    required this.userName,
    required this.profilePic,
  });
  late final int id;
  late final int userId;
  late final dynamic driverId;
  late final dynamic vehicleId;
  late final int vehicleType;
  late final String sourceAddress;
  late final String sourceCity;
  late final String sourceState;
  late final String sourceCountry;
  late final int sourceZipcode;
  late final String sourceLatitude;
  late final String sourceLongitude;
  late final String destinationCity;
  late final String destinationState;
  late final String destinationCountry;
  late final int destinationZipcode;
  late final String destinationLatitude;
  late final String destinationLongitude;
  late final String destinationAddress;
  late final int kilometer;
  late final String polygone;
  late final int status;
  late final dynamic customerCancellation;
  late final dynamic driverCancellation;
  late final String createdAt;
  late final String updatedAt;
  late final String userName;
  late final String profilePic;

  RequestModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userId = json['user_id'];
    driverId = json['driver_id'];
    vehicleId = json['vehicle_id'];
    vehicleType = json['vehicle_type'];
    sourceAddress = json['source_address'];
    sourceCity = json['source_city'];
    sourceState = json['source_state'];
    sourceCountry = json['source_country'];
    sourceZipcode = json['source_zipcode'];
    sourceLatitude = json['source_latitude'];
    sourceLongitude = json['source_longitude'];
    destinationCity = json['destination_city'];
    destinationState = json['destination_state'];
    destinationCountry = json['destination_country'];
    destinationZipcode = json['destination_zipcode'];
    destinationLatitude = json['destination_latitude'];
    destinationLongitude = json['destination_longitude'];
    destinationAddress = json['destination_address'];
    kilometer = json['kilometer'];
    polygone = json['polygone'];
    status = json['status'];
    customerCancellation = json['customer_cancellation'];
    driverCancellation = json['driver_cancellation'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userName = json['user_name'];
    profilePic = json['profile_pic'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['user_id'] = userId;
    _data['driver_id'] = driverId;
    _data['vehicle_id'] = vehicleId;
    _data['vehicle_type'] = vehicleType;
    _data['source_address'] = sourceAddress;
    _data['source_city'] = sourceCity;
    _data['source_state'] = sourceState;
    _data['source_country'] = sourceCountry;
    _data['source_zipcode'] = sourceZipcode;
    _data['source_latitude'] = sourceLatitude;
    _data['source_longitude'] = sourceLongitude;
    _data['destination_city'] = destinationCity;
    _data['destination_state'] = destinationState;
    _data['destination_country'] = destinationCountry;
    _data['destination_zipcode'] = destinationZipcode;
    _data['destination_latitude'] = destinationLatitude;
    _data['destination_longitude'] = destinationLongitude;
    _data['destination_address'] = destinationAddress;
    _data['kilometer'] = kilometer;
    _data['polygone'] = polygone;
    _data['status'] = status;
    _data['customer_cancellation'] = customerCancellation;
    _data['driver_cancellation'] = driverCancellation;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['user_name'] = userName;
    _data['profile_pic'] = profilePic;
    return _data;
  }
}