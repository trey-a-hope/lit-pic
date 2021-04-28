import 'dart:async';
import 'dart:convert' show Encoding, json;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

abstract class IFCMService {
  Future<void> sendNotificationToUser(
      {@required String fcmToken,
      @required String title,
      @required String body});
  Future<void> sendNotificationToGroup(
      {@required String group, @required String title, @required String body});
  Future<void> unsubscribeFromTopic({@required String topic});
  Future<void> subscribeToTopic({@required String topic});
}

class FCMService extends IFCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final String _endpoint = 'https://fcm.googleapis.com/fcm/send';
  final String _contentType = 'application/json';
  final String _authorization =
      'key=AAAAfwIwcFs:APA91bGpR2eNlUi7d6RUnCr3FmdkDrmRg6pqlyHDAgxQq3VWc9Z_YwswWsQB2EFgP5ktZ9QpgyYTc8VaC1yP_fdbUtLrSgv7TGFrOG3HPIuZDt4kDA2ti8fe4np4aHrjdsfescGGGEPa';

  Future<http.Response> _sendNotification(
      String to, String title, String body) async {
    final dynamic data = json.encode(
      {
        'to': to,
        'priority': 'high',
        'notification': {'title': title, 'body': body},
        'content_available': true
      },
    );
    return http.post(
      _endpoint,
      body: data,
      headers: {'Content-Type': _contentType, 'Authorization': _authorization},
    );
  }

  @override
  Future<void> unsubscribeFromTopic({@required String topic}) {
    return _firebaseMessaging.subscribeToTopic(topic);
  }

  @override
  Future<void> subscribeToTopic({@required String topic}) {
    return _firebaseMessaging.subscribeToTopic(topic);
  }

  @override
  Future<void> sendNotificationToUser(
      {@required String fcmToken,
      @required String title,
      @required String body}) {
    return _sendNotification(fcmToken, title, body);
  }

  @override
  Future<void> sendNotificationToGroup(
      {@required String group, @required String title, @required String body}) {
    return _sendNotification('/topics/' + group, title, body);
  }
}
