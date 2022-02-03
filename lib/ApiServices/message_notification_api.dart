import 'dart:convert';

import 'package:http/http.dart';

class Messaging {
  static final Client client = Client();

  // from 'https://console.firebase.google.com'
  // --> project settings --> cloud messaging --> "Server key"
  static const String serverKey = 'AAAAOUtYrwo:APA91bGKeHxmeuERL70kOM8mgXP6i5aG1jbqpGnNjx0jw5pIUKPFtTtOv2X2v9kmPUbo21oOp6MM-sY02Q6G2Hsoxci5HwROEb-dgynJQdg7jSpgfgGgvpheo4WkCBzMvv7_EbGsMO0V';

  static Future<Response> sendToAll({
    required String title,
    required String body,
  }) =>
      sendToTopic(title: title, body: body, topic: 'all');

  static Future<Response> sendToTopic(
          {required String title,
          required String body,
          required String topic}) =>
      sendTo(title: title, body: body, fcmToken: '/topics/$topic');

  static Future<Response> sendTo(
          {required String title,
          required String body,
          required String fcmToken,
          dynamic id //it should be int
          }) =>
      client.post(
        // Uri.parse('https://api.rnfirebase.io/messaging/send')
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: json.encode({
          'notification': {'body': body, 'title': title},
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': id,
            'status': 'done',
          },
          'to': fcmToken,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
      );
}
