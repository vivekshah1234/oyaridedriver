class ApiConstant {
  static String baseUrl = "http://3.13.6.132:3900/api";
  static String signUp = "/auth/register";
  static String login = "/auth/login";
  static String resetPassword = "auth/reset-password";
  static String refreshToken = "auth/refresh-token";
  static String addDeviceInfo = "/user/device";
  static String userStatus="/user/online-status";
  static String updateLocation="/user/update-location";
  static String getVehicle="/user/vehicle";
  static String addVehicle="/user/vehicle";
  static String vehicleTypes="/user/vehicle-type";
  static String forgetPassword="/auth/forgot-password";
  static String changeActiveVehicle="/user/change-active-vehicle";
  static String editVehicle="/user/edit-vehicle";
  static String getTripDetails="/user/getLastTripDetailDriver";
  static String geTripHistory="/user/getTripListDriver";
  static String getNotificationList="/user/getNotificationList";
}

abstract class AppConstants {
  static const String appName = 'ShipX';
  static const String noInternet = "Internet is not connected.";
  static String userToken = "userToken";
  static String profilePic = "profilePic";
  static String noDataFound = "No data found";
  static String userData = "user_data";
  static String userID = "user_id";
  static String email = "email_id";
  static String fullName = "full name";
  static String countryCode = "Country Code";
  static String mobileNo = "mobile";
  static String address = "address";
  static String deviceID = "deviceID";
  static bool isVerified = false;
  static int registerFormNo = 0;
  static bool userOnline=true;
}

class ApiKeys {
  static String mapApiKey = "AIzaSyBQlfH7orUgEyQ9yNcg74TaVvz_rzu2PZU";
}

abstract class SocketEvents{
  static String socketUrl="http://3.13.6.132:3900";
  static String updateDriverLocation="updateDriverLocation";
  static String getRequest="getRequest";
  static String sendRequest="sendRequest";
  static String acceptRequest="acceptRequest";
  static String sendAcceptReqResponse="sendAcceptReqResponse";
  static String reachedAtLocation="reachedAtLocation";
  static String sendReachedAtLocationResponse="sendReachedAtLocationResponse";
  static String pickUpTheRider="pickUpTheRider";
  static String startRide="startRide";
  static String completeRide="completeRide";
  static String sendCompleteRideResponse="sendCompleteRideResponse";
  static String startRideDetails="startRideDetails";
  static String paymentVerifyDriver="paymentVerifyDriver";
  static String cancelRideByBoth="cancelRideByBoth";
}