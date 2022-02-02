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
    GMSServices.provideAPIKey("AIzaSyBQHOw2QG98dqVirCXbHr8gLcaD3W5JIYo")
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
     }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
