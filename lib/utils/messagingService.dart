import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String? _token;

  String? get token => _token;

  Future init() async {
    final settings = await _requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await _getToken();
      _registerForegroundMessageHandler();
    }
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Initialize native Ios Notifications
    // final DarwinInitializationSettings initializationSettingsIOS =
    //     DarwinInitializationSettings();

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future _getToken() async {
    _token = await _firebaseMessaging.getToken();

    log("FCM: $_token");

    _firebaseMessaging.onTokenRefresh.listen((token) {
      _token = token;
    });
  }

  Future<String?> getToken() async {
    _token = await _firebaseMessaging.getToken();

    log("FCM: $_token");

    _firebaseMessaging.onTokenRefresh.listen((token) {
      _token = token;
    });
    return _token;
  }

  Future<NotificationSettings> _requestPermission() async {
    return await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        announcement: false);
  }

  void _registerForegroundMessageHandler() {
    FirebaseMessaging.onMessage.listen((remoteMessage) async {
      log(" --- foreground message received ---");
      log('${remoteMessage.data['title']}');
      // log('${remoteMessage.notification!.body}');
      await showTextNotification('${remoteMessage.data['title']}',
          '${remoteMessage.data['body']}', '#0909');
    });
  }

  Future<void> showTextNotification(
    String title,
    String body,
    String orderID,
  ) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      playSound: true,
      importance: Importance.max,
      priority: Priority.max,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: orderID);
  }
}

@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  FirebaseMessaging.instance.getInitialMessage();
  log('A bg message just showed up :  ${message.messageId}');
  await MessagingService().showTextNotification(
      '${message.data['title']}', '${message.data['body']}', '#0909');
}
/*class Apis {
  static const String serverKey =
      'AAAAFeNRrAk:APA91bHnlGTUl1XhO39klGD2a73K0xBEqGW1YsHgnYonfE0lQbcY3pXQcQ9GE2dJ2Os-1kbBiBCULYmBNNUYgEeDu_rDltuiS-cgK8AVoqNsBVKQDDgrBS6WLZ4Dx1Ooop7MYEgPw8-e';
  static const String fcmUrl = 'https://fcm.googleapis.com/fcm/send';
}

AAAAIFbSp9o:APA91bEtGKiPZ9Ztk24INMzrHeEP7_mgpJ8x8cKAskjUKgnmgl30No8Vf2flE-Pg5cZ1ZhnjHGXa4cFxR2puG72iwn0KPVLlrwfv8nqDEqjzFqXcr468SP098XdzhY4EEQ4X8ar3MDaJ

////////138895599578

Content-Type:application/json
Authorization:key=AIzaSyZ-1u...0GBYzPu7Udno5aA




  Future<void> notifyUser({required BuildContext context}) async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = await FirebaseMessaging.instance.getToken();
    var url = Uri.parse(Apis.fcmUrl);
    debugPrint('Data-==>  $url');
    var body = {
      "data": {
        "title": nameController.text,
        "body":
            "Thank you for register with\n ${regEmailController.text} and ${regMobController.text} "
      },
      "to": token
    };
    log('body dat---->>  $body');
    final response =
        await ApiService().postData(context: context, url: url, body: body);
    var result = jsonDecode(response.body);
  }
*/
