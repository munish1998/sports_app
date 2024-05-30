// import 'dart:async';
// import 'dart:developer';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class MessagingService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   String? _token;

//   String? get token => _token;

//   Future<void> init() async {
//     await Firebase.initializeApp();

//     final settings = await _requestPermission();
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       await _getToken();
//       _registerForegroundMessageHandler();
//     }

//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     final DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//       onDidReceiveLocalNotification:
//           (int id, String? title, String? body, String? payload) async {},
//     );

//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   Future<void> _getToken() async {
//     _token = await _firebaseMessaging.getToken();
//     log("FCM Token: $_token");

//     _firebaseMessaging.onTokenRefresh.listen((token) {
//       _token = token;
//     });
//   }

//   Future<String?> getToken() async {
//     _token = await _firebaseMessaging.getToken();
//     log("FCM Token: $_token");

//     _firebaseMessaging.onTokenRefresh.listen((token) {
//       _token = token;
//     });

//     return _token;
//   }

//   Future<NotificationSettings> _requestPermission() async {
//     return await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       announcement: false,
//     );
//   }

//   void _registerForegroundMessageHandler() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) async {
//       log("Foreground message received: ${remoteMessage.messageId}");

//       String? title =
//           remoteMessage.notification?.title ?? remoteMessage.data['title'];
//       String? body =
//           remoteMessage.notification?.body ?? remoteMessage.data['body'];

//       log('Notification title: $title');
//       log('Notification body: $body');

//       if (title != null && body != null) {
//         await showTextNotification(title, body, '#0909');
//       } else {
//         log('title and body is null');
//       }
//     });
//   }

//   Future<void> showTextNotification(
//       String title, String body, String orderID) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'your_channel_id',
//       'your_channel_name',
//       playSound: true,
//       importance: Importance.max,
//       priority: Priority.max,
//     );

//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     await flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       platformChannelSpecifics,
//       payload: orderID,
//     );
//   }
// }

// @pragma('vm:entry-point')
// Future<void> backgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   log('Background message received: ${message.messageId}');

//   String? title = message.notification?.title ?? message.data['title'];
//   String? body = message.notification?.body ?? message.data['body'];

//   log('Notification title: $title');
//   log('Notification body: $body');

//   if (title != null && body != null) {
//     await MessagingService().showTextNotification(title, body, '#0909');
//   }
// }
