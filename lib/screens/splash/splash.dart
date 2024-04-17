import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchmaster/providers/authProvider.dart';

import '../../providers/profileProvider.dart';
import '../../utils/commonMethod.dart';
import '../../utils/constant.dart';
import '../authScreen/login.dart';
import '../home/dashboard.dart';
import '/app_image.dart';
import '/screens/onboard/onboard1.dart';
import '/utils/screen_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences? _pref;

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    _pref = await SharedPreferences.getInstance();
    _getProfile();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil()..init(context);
    return FlutterSplashScreen.fadeIn(
      onAnimationEnd: () {
        if (_pref!.getBool(isInitKey) ?? false) {
          if (_pref!.getBool(isUserLoginKey) ?? false) {
            navPushRemove(context: context, action: DashboardScreen());
          } else {
            navPushRemove(context: context, action: LoginScreen());
          }
        } else {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
            return FirstOnboard();
          }), (route) => false);
        }
      },
      animationDuration: Duration(seconds: 3),
      childWidget: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Image.asset(
              "assets/splashBg.png",
              fit: BoxFit.fill,
              width: double.infinity,
            ),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: AppImage("assets/splash.png"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getProfile() async {
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    Provider.of<AuthProvider>(context, listen: false).getToken();
    var data = {
      'user_id': _pref!.getString(userIdKey) ?? '',
    };
    pro.getProfile(context: context, data: data);
  }
}
