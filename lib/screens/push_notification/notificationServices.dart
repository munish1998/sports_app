import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  void requestNotificationpermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true, badge: true, provisional: true, sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('user granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('provisional agranted');
    } else {
      openAppSettings();
      log('user access');
    }
  }

  void init() async {
    var androidInitializationsettings = AndroidInitializationSettings('');
    var iosInitializationsettings = DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: androidInitializationsettings, iOS: iosInitializationsettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<String> getdevicetoken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void refreshToken() {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      log('refresh token');
    });
  }

  firebaseInit() {
    FirebaseMessaging.onMessage.listen((onmessage) {
      log(onmessage.notification!.title.toString());
      log(onmessage.notification!.body.toString());
    });
  }
}
