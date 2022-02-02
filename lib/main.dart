import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:oyaridedriver/Models/signup_modal.dart';
import 'package:oyaridedriver/UIScreens/licence_details_screens.dart';
import 'package:oyaridedriver/UIScreens/authScreens/login_screen.dart';
import 'package:oyaridedriver/UIScreens/mapScreens/map_screen.dart';
import 'package:oyaridedriver/UIScreens/personal_info_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ApiServices/api_constant.dart';
import 'UIScreens/ChatUI/firebase_chat.dart';
import 'UIScreens/home_screen.dart';
// ignore_for_file: prefer_const_constructors

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  if (message != null) {
    print(message.data);
    flutterLocalNotificationsPlugin.show(
        message.data.hashCode,
        message.data['title'],
        message.data['body'],
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
          ),
        ));
  }
}

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark
      // transparent status bar
      ));
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title// description
    importance: Importance.high,

    enableLights: true,
    ledColor: Colors.red,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  Widget firstScreen = MyApp();
  SharedPreferences sp = await SharedPreferences.getInstance();
  AppConstants.userOnline=sp.getBool("userOnline")??true;
  AppConstants.userID = sp.getString("user_id") ?? "user_id";

  AppConstants.registerFormNo = sp.getInt("registerFormNo") ?? 0;

  if (AppConstants.registerFormNo != 0) {
    switch (AppConstants.registerFormNo) {
      case 1:
        firstScreen = PersonalInfoScreen();
        break;
      case 2:
        firstScreen = LicenceDetailScreen();
        break;
      case 3:
        firstScreen = LicenceDocumentScreen();
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
      firstScreen=MapHomeScreen();
    }
  }
  runApp(ScreenUtilInit(
      builder: () => GetMaterialApp(
          debugShowCheckedModeBanner: false, home: firstScreen)));
}

ValueNotifier<int> notificationCounterValueNotifier = ValueNotifier(0);

class MyApp extends StatefulWidget with ChangeNotifier {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    firebaseCloudMessagingListeners();
    dummyFirebaseToken();
    super.initState();
  }

  dummyFirebaseToken() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? firebaseToken = await firebaseMessaging.getToken();
    printInfo(info: "Token==" + firebaseToken.toString());
  }

  firebaseCloudMessagingListeners() {

    if (Platform.isIOS) iOSPermission();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
     RemoteNotification? notification = message.notification;
      printInfo(info: 'A new onMessage event was published!');
      _showNotification(1234, notification!.title.toString(),
          notification.body.toString(), "GET PAYLOAD FROM message userECT");
      //    MyCustomNotification(notificationCounterValueNotifier.value);
      notificationCounterValueNotifier.value++;
      notificationCounterValueNotifier.notifyListeners();
      printInfo(info: notificationCounterValueNotifier.value.toString());
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      printInfo(info: "3");
      printInfo(info: 'A new onMessageOpenedApp event was published!');
      // notify listeners here so ValueListenableBuilder will build the widget.

      onSelectNotification(message);
    });
  }

  void onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title!),
        content: Text(body!),
      ),
    );
  }

  void iOSPermission() {
    _firebaseMessaging.setAutoInitEnabled(true);
    _firebaseMessaging.getNotificationSettings();
    _firebaseMessaging.requestPermission(alert: true, badge: true, sound: true);
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }

  Future onSelectNotification(RemoteMessage payload) async {
    if (payload.data != null) {
      var id = payload.data["id"];
      var notificationType = payload.data["notificationType"];

      if (id != null) {
        //Get.to(() => ChatPage(peerId: payload.data["id"]));
      } else if (notificationType != null) {
        navigateToScreen(notificationType);
      }
    }
  }

  navigateToScreen(String screen) {
    // print("switch:::::::::");
  }
}

Future<void> setUserData(User user) async {
  //
  print("aaa=======");
  AppConstants.fullName = user.firstName+" "+user.lastName;
  AppConstants.mobileNo = user.mobileNumber;
  AppConstants.email = user.email;
  AppConstants.countryCode = user.countryCode;
  AppConstants.userID = user.id.toString();

  if (user.profilePic != null) {

    AppConstants.profilePic = user.profilePic;
  }

  DatabaseMethods databaseMethods = DatabaseMethods();
  try {
    final QuerySnapshot result =
        await databaseMethods.getUserInfo(id: int.parse(AppConstants.userID));

    final List<DocumentSnapshot> documents = result.docs;

    if (documents.isEmpty) {
      FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      String? firebaseToken = await firebaseMessaging.getToken();

      Map<String, dynamic> userData = {
        'nickname': AppConstants.fullName,
        'photoUrl': AppConstants.profilePic,
        'id': AppConstants.userID,
        "firebaseToken": firebaseToken,
        'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        'chattingWith': null,
        'userStatus': 0,
        'unReadMessages': 0
      };
      bool isUserExist =
          await databaseMethods.checkUserExist(AppConstants.userID);
      print("aaa2======="+isUserExist.toString());
      if (!isUserExist) {
        databaseMethods.addUserInfo(
            docId: AppConstants.userID, userData: userData);
      } else {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(AppConstants.userID)
            .update({
          'nickname': AppConstants.fullName,
          'photoUrl': AppConstants.profilePic,
          "firebaseToken": firebaseToken,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString()
        });
      }
    }
  } catch (Exception) {
    print("Error on firebase=====" + Exception.toString());
  }
}

Future<void> _showNotification(
  int notificationId,
  String notificationTitle,
  String notificationContent,
  String payload, {
  String channelId = '1234',
  String channelTitle = 'Android Channel',
}) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    channelId,
    channelTitle,
    playSound: false,
    importance: Importance.high,
    priority: Priority.high,
  );
  var iOSPlatformChannelSpecifics = IOSNotificationDetails(presentSound: true);
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    notificationId,
    notificationTitle,
    notificationContent,
    platformChannelSpecifics,
    payload: payload,
  );
}
