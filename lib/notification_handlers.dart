import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'UIScreens/ChatUI/chat_screen.dart';
import 'UIScreens/mapScreens/map_screen.dart';
import 'main.dart';
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // print('Handling a background message111111 ${message.notification != null}');
  //
  // if (message.notification != null) {
  //   //  print(message.data.hashCode);
  //   flutterLocalNotificationsPlugin.show(
  //       message.data.hashCode,
  //       message.notification?.title,
  //       message.notification?.body,
  //       NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           message.data['title'].toString(),
  //           message.data['body'].toString(),
  //         ),
  //         iOS: IOSNotificationDetails(subtitle: message.data['title'].toString(), )
  //       )
  //
  //   );
  // }
}

Future onSelectNotification(RemoteMessage payload) async {
  if (payload.data != null) {
    var id = payload.data["id"];
    var notificationType = payload.data["notificationType"];

    if (id != null) {
      Get.to(() => ChatPage(peerId: payload.data["id"]));
    } else if (notificationType != null) {
      notificationCounterValueNotifier.value++;
      notificationCounterValueNotifier.notifyListeners();
      var userId = payload.data["userId"];
      navigateToScreen(notificationType, userId);
    }
  }
}

navigateToScreen(String screen, id) {
  print("switch:::::::::" + id.toString());
  switch (screen) {
    case "1":
      Get.to(() => MapHomeScreen(
        isFromNotification: true,
        userId: id,
      ));
      break;
  }
}

Future<void> showNotification(
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
  var iOSPlatformChannelSpecifics = const IOSNotificationDetails(presentSound: true);
  var platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    notificationId,
    notificationTitle,
    notificationContent,
    platformChannelSpecifics,
    payload: payload,
  );
}

void onDidReceiveLocalNotification(int? id, String? title, String? body, String? payload) async {
  // display a dialog with the notification details, tap ok to go to another page
  showNotification(
      1234, title.toString(), body.toString(), "GET PAYLOAD FROM message userECT");

}