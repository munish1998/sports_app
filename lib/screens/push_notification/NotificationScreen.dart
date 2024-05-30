import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:touchmaster/screens/push_notification/notificationServices.dart';
import 'package:touchmaster/utils/push_notification.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationpermission();
    notificationServices.refreshToken();
    notificationServices.getdevicetoken();
    notificationServices.firebaseInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
