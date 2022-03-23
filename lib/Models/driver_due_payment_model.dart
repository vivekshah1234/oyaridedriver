class DriverDuePaymentModel {
  DriverDuePaymentModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final int status;
  late final String message;
  late final PaymentPendingModel data;

  DriverDuePaymentModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    data = PaymentPendingModel.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.toJson();
    return _data;
  }
}

class PaymentPendingModel {
  PaymentPendingModel({
    required this.tripList,
    required this.finalAmount,
  });
  late final List<TripList> tripList;
  late final dynamic finalAmount;

  PaymentPendingModel.fromJson(Map<String, dynamic> json){
    tripList = List.from(json['trip_list']).map((e)=>TripList.fromJson(e)).toList();
    finalAmount = json['finalAmount'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['trip_list'] = tripList.map((e)=>e.toJson()).toList();
    _data['finalAmount'] = finalAmount;
    return _data;
  }
}

class TripList {
  TripList({
    required this.id,
    required this.userId,
    required this.driverId,
    required this.bookingId,
    required this.vehicleId,
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
    required this.price,
    required this.paymentStatus,
    required this.paymentMode,
    required this.paymentTransId,
    this.reason,
    required this.paidToAdmin,
    required this.createdAt,
    required this.updatedAt,
    required this.adminCommision,
  });
  late final int id;
  late final int userId;
  late final int driverId;
  late final String bookingId;
  late final int vehicleId;
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
  late final String kilometer;
  late final String polygone;
  late final int status;
  late final Null customerCancellation;
  late final Null driverCancellation;
  late final String price;
  late final String paymentStatus;
  late final String paymentMode;
  late final String paymentTransId;
  late final Null reason;
  late final int paidToAdmin;
  late final String createdAt;
  late final String updatedAt;
  late final dynamic adminCommision;

  TripList.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userId = json['user_id'];
    driverId = json['driver_id'];
    bookingId = json['booking_id'];
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
    customerCancellation = null;
    driverCancellation = null;
    price = json['price'];
    paymentStatus = json['payment_status'];
    paymentMode = json['payment_mode'];
    paymentTransId = json['payment_trans_id'];
    reason = null;
    paidToAdmin = json['paid_to_admin'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    adminCommision = json['admin_commision'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['user_id'] = userId;
    _data['driver_id'] = driverId;
    _data['booking_id'] = bookingId;
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
    _data['price'] = price;
    _data['payment_status'] = paymentStatus;
    _data['payment_mode'] = paymentMode;
    _data['payment_trans_id'] = paymentTransId;
    _data['reason'] = reason;
    _data['paid_to_admin'] = paidToAdmin;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['admin_commision'] = adminCommision;
    return _data;
  }
}