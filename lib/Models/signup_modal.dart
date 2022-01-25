class SignUpModel {
  SignUpModel({
    required this.status,
    required this.data,
  });
  late final int status;
  late final Data data;

  SignUpModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.token,
    required this.user,
  });
  late final String token;
  late final User user;

  Data.fromJson(Map<String, dynamic> json){
    token = json['token'];
    user = User.fromJson(json['user']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['token'] = token;
    _data['user'] = user.toJson();
    return _data;
  }
}

class User {
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.city,
    required this.mobileNumber,
    required this.email,
    this.profilePic,
    required this.language,
    required this.referralCode,
    required this.countryCode,
    required  this.licencePlate,
    required  this.licenceNumber,
    required this.licencePhoto,
    required this.isVerified,
    required this.signUpStep,
    required this.isAvailable,
    required  this.verificationCode,
    required this.createdAt,
    required this.updatedAt,
    required this.unreadCount,
  });
  late final int id;
  late final String firstName;
  late final String lastName;
  late final String city;
  late final String mobileNumber;
  late final String email;
  late final dynamic profilePic;
  late final String language;
  late final String referralCode;
  late final String countryCode;
  late final String licencePlate;
  late final String licenceNumber;
  late final String licencePhoto;
  late final dynamic isVerified;
  late final dynamic signUpStep;
  late final int isAvailable;
  late final dynamic verificationCode;
  late final String createdAt;
  late final String updatedAt;
  late final int unreadCount;

  User.fromJson(Map<String, dynamic> json){
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    city = json['city'];
    mobileNumber = json['mobile_number'];
    email = json['email'];
    profilePic = json['profile_pic'];
    language = json['language'];
    referralCode = json['referral_code'];
    countryCode = json['country_code'];
    licencePlate = json['licence_plate'];
    licenceNumber = json['licence_number'];
    licencePhoto = json['licence_photo'];
    isVerified = json['is_verified'];
    signUpStep = json['sign_up_step'];
    isAvailable = json['is_available'];
    verificationCode = json['verification_code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    unreadCount = json['unreadCount'];
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
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['unreadCount'] = unreadCount;
    return _data;
  }
}