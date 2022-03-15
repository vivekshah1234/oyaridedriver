import 'package:oyaridedriver/Models/sign_up_model.dart';

class EditProfileModel {
  EditProfileModel({
    required this.status,
    required this.data,
    required this.message,
  });
  late final int status;
  late final User data;
  late final String message;

  EditProfileModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    data = User.fromJson(json['data']);
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
// }
//
// class Data {
//   Data({
//     required this.id,
//     required this.firstName,
//     required this.lastName,
//     required this.city,
//     required this.mobileNumber,
//     required this.email,
//     required this.profilePic,
//     required this.language,
//     required this.referralCode,
//     required this.countryCode,
//     required this.licencePlate,
//     required this.licenceNumber,
//     required this.licencePhoto,
//     required this.isVerified,
//     this.signUpStep,
//     required this.isAvailable,
//     required this.verificationCode,
//     required this.paymentType,
//     required this.licenceExpireDate,
//     required this.isPaymentDue,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.unreadCount,
//   });
//   late final int id;
//   late final String firstName;
//   late final String lastName;
//   late final String city;
//   late final String mobileNumber;
//   late final String email;
//   late final String profilePic;
//   late final String language;
//   late final String referralCode;
//   late final String countryCode;
//   late final String licencePlate;
//   late final String licenceNumber;
//   late final String licencePhoto;
//   late final int isVerified;
//   late final Null signUpStep;
//   late final int isAvailable;
//   late final String verificationCode;
//   late final int paymentType;
//   late final String licenceExpireDate;
//   late final int isPaymentDue;
//   late final String createdAt;
//   late final String updatedAt;
//   late final int unreadCount;
//
//   Data.fromJson(Map<String, dynamic> json){
//     id = json['id'];
//     firstName = json['first_name'];
//     lastName = json['last_name'];
//     city = json['city'];
//     mobileNumber = json['mobile_number'];
//     email = json['email'];
//     profilePic = json['profile_pic'];
//     language = json['language'];
//     referralCode = json['referral_code'];
//     countryCode = json['country_code'];
//     licencePlate = json['licence_plate'];
//     licenceNumber = json['licence_number'];
//     licencePhoto = json['licence_photo'];
//     isVerified = json['is_verified'];
//     signUpStep = null;
//     isAvailable = json['is_available'];
//     verificationCode = json['verification_code'];
//     paymentType = json['payment_type'];
//     licenceExpireDate = json['licence_expire_date'];
//     isPaymentDue = json['is_payment_due'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     unreadCount = json['unreadCount'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['id'] = id;
//     _data['first_name'] = firstName;
//     _data['last_name'] = lastName;
//     _data['city'] = city;
//     _data['mobile_number'] = mobileNumber;
//     _data['email'] = email;
//     _data['profile_pic'] = profilePic;
//     _data['language'] = language;
//     _data['referral_code'] = referralCode;
//     _data['country_code'] = countryCode;
//     _data['licence_plate'] = licencePlate;
//     _data['licence_number'] = licenceNumber;
//     _data['licence_photo'] = licencePhoto;
//     _data['is_verified'] = isVerified;
//     _data['sign_up_step'] = signUpStep;
//     _data['is_available'] = isAvailable;
//     _data['verification_code'] = verificationCode;
//     _data['payment_type'] = paymentType;
//     _data['licence_expire_date'] = licenceExpireDate;
//     _data['is_payment_due'] = isPaymentDue;
//     _data['created_at'] = createdAt;
//     _data['updated_at'] = updatedAt;
//     _data['unreadCount'] = unreadCount;
//     return _data;
//   }
// }