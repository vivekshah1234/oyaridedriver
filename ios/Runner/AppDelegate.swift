import UIKit
import Flutter
import GoogleMaps
import Firebase;

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyAd4_jmop3HuG6CS3cVfWZ7hvNMXYkhlSo")
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
     }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
