class ApiConstant {
  static String baseUrl = "http://18.219.37.34:3900/api/";

  static String register = "auth/register";

  static String login = "auth/login";
  static String changePassword = "user/change-password";
  static String refreshToken = "auth/refresh-token";
  static String updateProfile = "user/update-profile";
  static String verifyFBToken = "auth/verify-fb-token";
  static String fbLogin = "auth/fb-login";
  static String forgotPassword = "auth/forgot-password";
  static String resetPassword = "auth/reset-password";
  static String addCourierRequest = "shipping/request-courier";
  static String addReceiverRequest = "shipping/travling-details";
  static String allRequest = "shipping/my-orders";
  static String findMyMatch="shipping/find-my-match";
  static String sendRequest="shipping/send-request";

  static String myRequest="shipping/my-request";
  static String addDeviceInfo="user/device";

  static String cancelRequest="shipping/cancel-request";

  static String acceptRequest="shipping/accept-request";
  static String uploadDoc="user/upload-document";
  static String notification="shipping/notification-list";

  static String updateItemStatus="shipping/update-item-status";

  static String updateTravelStatus="shipping/update-traveling-status";

  static String latestActiveOrder="shipping/latest-active-order";
}

abstract class AppConstants {
  static const String appName = 'ShipX';
  static const String noInternet = "Internet is not connected.";
  static String userToken = "userToken";
  static String profilePic = "imageUrl";
  static String noDataFound = "No data found";
  static String userData = "user_data";
  static String userID = "user_id";
  static String email = "email_id";
  static String fullName = "full name";
  static String countryCode = "Country Code";
  static String mobileNo = "mobile";
  static String address = "address";
  static String deviceID = "deviceID";
  static bool isVerified=false;

}

class ApiKeys {
   static String mapApiKey = "AIzaSyAd4_jmop3HuG6CS3cVfWZ7hvNMXYkhlSo";

}
