import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:oyaridedriver/UIScreens/document_sent_screen.dart';
import 'package:oyaridedriver/UIScreens/licence_details_screens.dart';
import 'package:oyaridedriver/UIScreens/mapScreens/map_screen.dart';
import 'package:oyaridedriver/UIScreens/permission_screen.dart';
import 'package:oyaridedriver/UIScreens/personal_info_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ApiServices/api_constant.dart';
import 'Common/common_methods.dart';
import 'Models/sign_up_model.dart';
import 'UIScreens/home_screen.dart';
import 'notification_handlers.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

ValueNotifier<int> notificationCounterValueNotifier = ValueNotifier(0);
final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (Platform.isIOS) iOSPermission();

  var initializationSettingsAndroid = const AndroidInitializationSettings('app_icon');
  const IOSInitializationSettings initializationSettingsIOS =
  IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  var initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((message) {
    print('A new onMessage event was published!');
    RemoteNotification? notification = message.notification;
    showNotification(
        1234, notification!.title.toString(), notification.body.toString(), "GET PAYLOAD FROM message userECT");
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
    // notify listeners here so ValueListenableBuilder will build the widget.
    onSelectNotification(message);
  });
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark
      // transparent status bar
      ));

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title// description
    importance: Importance.high,

    enableLights: true,
    ledColor: Colors.red,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  Widget firstScreen = MyApp();
  SharedPreferences sp = await SharedPreferences.getInstance();
  bool? allPermissionAllowed = sp.getBool("allPermission");
  if (allPermissionAllowed == null) {
    allPermissionAllowed = false;
    firstScreen = MyApp();
  } else if (allPermissionAllowed = true) {
    firstScreen = const HomeScreen();
  }

  AppConstants.userOnline = sp.getBool("userOnline") ?? true;
  AppConstants.userID = sp.getString("user_id") ?? "user_id";
  AppConstants.registerFormNo = sp.getInt("registerFormNo") ?? 0;
  if (AppConstants.registerFormNo != 0) {
    switch (AppConstants.registerFormNo) {
      case 1:
        firstScreen = const PersonalInfoScreen();
        break;
      case 2:
        firstScreen = const LicenceDetailScreen();
        break;
      case 3:
        firstScreen = const LicenceDocumentScreen();
        break;
      case 4:
        firstScreen = const DocumentSentScreen();
        break;
      default:
        firstScreen = MyApp();
        break;
    }
  }
  var token = sp.getString("token");

  if (token != null) {
    AppConstants.userToken = token;
    var userData = sp.getString("userData");
    if (userData != null) {
      Map<String, dynamic> data = json.decode(userData);
      User user = User.fromJson(data);
      setUserData(user);
      firstScreen = const MapHomeScreen(
        isFromNotification: false,
      );
    }
  }
  runApp(ScreenUtilInit(builder: () => GetMaterialApp(debugShowCheckedModeBanner: false, home: firstScreen)));
}

class MyApp extends StatefulWidget with ChangeNotifier {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  void initState() {
   // firebaseCloudMessagingListeners();
    super.initState();
  }
  //
  // firebaseCloudMessagingListeners() {
  //   if (Platform.isIOS) iOSPermission();
  //
  //   var initializationSettingsAndroid = const AndroidInitializationSettings('app_icon');
  //   final IOSInitializationSettings initializationSettingsIOS =
  //       IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  //   var initializationSettings =
  //       InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  //
  //   flutterLocalNotificationsPlugin.initialize(initializationSettings);
  //
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     RemoteNotification? notification = message.notification;
  //     print('A new onMessage event was published!');
  //     showNotification(
  //         1234, notification!.title.toString(), notification.body.toString(), "GET PAYLOAD FROM message userECT");
  //   });
  //   // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     print("3");
  //     print('A new onMessageOpenedApp event was published!');
  //     // notify listeners here so ValueListenableBuilder will build the widget.
  //     onSelectNotification(message);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return const AllPermissionPage();
  }


}

void iOSPermission() {
  firebaseMessaging.setAutoInitEnabled(true);
  firebaseMessaging.getNotificationSettings();
  firebaseMessaging.requestPermission(alert: true, badge: true, sound: true);
}
