class YourTripHistoryListModel {
  YourTripHistoryListModel({
    required this.message,
    required this.status,
    required this.data,
  });
  late final String message;
  late final int status;
  late final List<TripHistoryModel> data;

  YourTripHistoryListModel.fromJson(Map<String, dynamic> json){
    message = json['message'];
    status = json['status'];
    data = List.from(json['data']).map((e)=>TripHistoryModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['status'] = status;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class TripHistoryModel {
  TripHistoryModel({
    required this.id,
    required this.userId,
    required this.driverId,
    required this.bookingId,
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
    required this.price,
    required this.paymentStatus,
    this.paymentMode,
    this.paymentTransId,
    required this.createdAt,
    required this.updatedAt,
    required this.userDetail,
    required this.vehDetail,
  });
  late final int id;
  late final int userId;
  late final int driverId;
  late final int bookingId;
  late final Null vehicleId;
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
  late final String? customerCancellation;
  late final Null driverCancellation;
  late final String price;
  late final String paymentStatus;
  late final String? paymentMode;
  late final String? paymentTransId;
  late final String createdAt;
  late final String updatedAt;
  late final UserDetail userDetail;
  late final VehDetail vehDetail;

  TripHistoryModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userId = json['user_id'];
    driverId = json['driver_id'];
    bookingId = json['booking_id'];
    vehicleId = null;
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
    paymentMode = null;
    paymentTransId = null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userDetail = UserDetail.fromJson(json['userDetail']);
    vehDetail = VehDetail.fromJson(json['vehDetail']);
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
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['userDetail'] = userDetail.toJson();
    _data['vehDetail'] = vehDetail.toJson();
    return _data;
  }
}

class UserDetail {
  UserDetail({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.city,
    required this.mobileNumber,
    required this.email,
    required this.profilePic,
    this.language,
    this.referralCode,
    required this.countryCode,
    this.licencePlate,
    this.licenceNumber,
    this.licencePhoto,
    this.isVerified,
    this.signUpStep,
    required this.isAvailable,
    this.verificationCode,
    required this.paymentType,
    this.licenceExpireDate,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String firstName;
  late final String lastName;
  late final Null city;
  late final String mobileNumber;
  late final String email;
  late final String profilePic;
  late final Null language;
  late final Null referralCode;
  late final String countryCode;
  late final Null licencePlate;
  late final Null licenceNumber;
  late final Null licencePhoto;
  late final Null isVerified;
  late final Null signUpStep;
  late final int isAvailable;
  late final Null verificationCode;
  late final int paymentType;
  late final Null licenceExpireDate;
  late final String createdAt;
  late final String updatedAt;

  UserDetail.fromJson(Map<String, dynamic> json){
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    city = null;
    mobileNumber = json['mobile_number'];
    email = json['email'];
    profilePic = json['profile_pic'];
    language = null;
    referralCode = null;
    countryCode = json['country_code'];
    licencePlate = null;
    licenceNumber = null;
    licencePhoto = null;
    isVerified = null;
    signUpStep = null;
    isAvailable = json['is_available'];
    verificationCode = null;
    paymentType = json['payment_type'];
    licenceExpireDate = null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['first_name'] = firstName;
    _data['last_name'] = lastName;
    _data['city'] = city;
    _data['mobile_number'] = mobileNumber;
    _data['email'] = email;
    _data['profile_pic'] = profilePic;
    _data['language'] = language;
    _data['referral_code'] = referralCode;
    _data['country_code'] = countryCode;
    _data['licence_plate'] = licencePlate;
    _data['licence_number'] = licenceNumber;
    _data['licence_photo'] = licencePhoto;
    _data['is_verified'] = isVerified;
    _data['sign_up_step'] = signUpStep;
    _data['is_available'] = isAvailable;
    _data['verification_code'] = verificationCode;
    _data['payment_type'] = paymentType;
    _data['licence_expire_date'] = licenceExpireDate;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}

class VehDetail {
  VehDetail({
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

  VehDetail.fromJson(Map<String, dynamic> json){
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