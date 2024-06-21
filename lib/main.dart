import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'providers/allProviders.dart';
import 'screens/splash/splash.dart';
import 'utils/messagingService.dart';

// late List<CameraDescription> cameras;
SharedPreferences? preferences;

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

MessagingService _msgService = MessagingService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51PDi6gSFgGEQSEVhKwOVEvy2IYigcgCU2F7f9G8VAyRUJcEthde6JVX3hacyJ41CSXMsplp2zOxh7BDIaTyV9Lug00IWWvH3g3';
//  Stripe.merchantIdentifier = 'any string works';
  await Stripe.instance.applySettings();
  preferences = await SharedPreferences.getInstance();
  // cameras = await availableCameras();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: FirebaseOptions(
      apiKey: "AIzaSyBRTwIl8TTMGrNEIf7c6J08OD3PORqHij4",
      appId: "1:138895599578:android:f844af77764a94763242e3",
      messagingSenderId: "138895599578",
      projectId: "sport-app-816cf",
    ),
  );
  await _msgService.init();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AllProviders().allProvider,
      child: MaterialApp(
        title: 'Touch Master',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
          ),
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.black,
              iconTheme: IconThemeData(color: Colors.white)),
          // scaffoldBackgroundColor: Colors.black,
          useMaterial3: true,
        ),

        home: SplashScreen(),
        // home: ExampleScreen(),
      ),
    );
  }
}
