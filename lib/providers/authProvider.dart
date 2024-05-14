import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchmaster/screens/onboard/onboard1.dart';

import '../service/apiConstant.dart';
import '../service/apiService.dart';
import '../utils/constant.dart';
import '../utils/customLoader.dart';
import '/utils/commonMethod.dart';

class AuthProvider with ChangeNotifier {
  loc.Location location = loc.Location();
  loc.LocationData? _locationData;
  String _address = '';

  String get address => _address;
  bool _isAgree = false;

  bool get isAgree => _isAgree;

  bool _isOTP = false;

  bool get isOTP => _isOTP;

  bool _isVerify = false;

  bool get isVerify => _isVerify;
  bool _isForgot = false;

  bool get isForgot => _isForgot;

  bool _isChange = false;

  bool get isChange => _isChange;

  bool _isLogin = false;

  bool get isLogin => _isLogin;

  String _uId = '';

  String get uId => _uId;
  String _token = '';

  String get token => _token;
  bool isRemember = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController cPassController = TextEditingController();

  TextEditingController otpController = TextEditingController();

  TextEditingController fEmailController = TextEditingController();

  TextEditingController lEmailController = TextEditingController();
  TextEditingController lPassController = TextEditingController();

  TextEditingController nPassController = TextEditingController();
  TextEditingController nCPassController = TextEditingController();

  void checkAgree(bool value) async {
    _isAgree = !value;
    log('----------->>>   $value   $_isAgree');
    notifyListeners();
  }

  void checkOTP() async {
    _isOTP = false;
  }

  void getToken() async {
    _token = (await FirebaseMessaging.instance.getToken())!;
  }

  void clear() async {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passController.clear();
    cPassController.clear();
    lEmailController.clear();
    lPassController.clear();
    fEmailController.clear();
    nPassController.clear();
    nCPassController.clear();
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    navPushRemove(context: context, action: FirstOnboard());
    notifyListeners();
  }

  Future<void> signUp(
      {required BuildContext context, required Map data}) async {
    var url = Uri.parse(Apis.register);
    // debugPrint('Data-==>  $url');
    showLoaderDialog(context, 'Please wait...');
    final response =
        await ApiClient().postData(context: context, url: url, body: data);
    var result = jsonDecode(response.body);
    log('SignUP --------->>>   $result');
    navPop(context: context);
    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        _uId = result['user_id'];
        _isOTP = true;

        notifyListeners();
      } else {
        customToast(context: context, msg: result['message'], type: 0);
        _isOTP = false;
        notifyListeners();
      }
    } else {
      customToast(context: context, msg: result['message'], type: 0);
      _isOTP = false;
      notifyListeners();
    }
  }

  Future<void> login({required BuildContext context, required Map data}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var url = Uri.parse(Apis.login);
    _isLogin = false;
    // debugPrint('Data-==>  $url');
    showLoaderDialog(context, 'Please wait...');
    final response =
        await ApiClient().postData(context: context, url: url, body: data);
    navPop(context: context);
    print('');
    log('message=======>>>>>   ${response.body}');
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      if (result['code'] == 200) {
        pref.setBool(isUserLoginKey, true);
        pref.setString(accessTokenKey, result['access_token']);
        pref.setString(userIdKey, result['user_id']);
        _isLogin = true;
        notifyListeners();
      } else {
        customToast(context: context, msg: result['message'], type: 0);
        _isLogin = false;
        notifyListeners();
      }
    } else {
      _isLogin = false;
      notifyListeners();
    }
  }

  Future<void> verifyOTP(
      {required BuildContext context, required Map data}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _isVerify = false;
    var url = Uri.parse(Apis.verifyOtp);
    // debugPrint('Data-==>  $url');
    showLoaderDialog(context, 'Please wait...');
    final response =
        await ApiClient().postData(context: context, url: url, body: data);
    var result = jsonDecode(response.body);
    log('OTP Result---------->>>>   $result');
    navPop(context: context);
    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        pref.setBool(isUserLoginKey, true);
        pref.setString(accessTokenKey, result['access_token']);
        pref.setString(userIdKey, result['user_id']);
        _isVerify = true;

        notifyListeners();
      } else {
        customToast(context: context, msg: result['message'], type: 0);
        _isVerify = false;
        notifyListeners();
      }
    } else {
      customToast(context: context, msg: result['message'], type: 0);
      _isVerify = false;
      notifyListeners();
    }
  }

  Future<void> forgotPass(
      {required BuildContext context, required Map data}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var url = Uri.parse(Apis.forgotPass);
    // debugPrint('Data-==>  $url');
    showLoaderDialog(context, 'Please wait...');
    final response =
        await ApiClient().postData(context: context, url: url, body: data);
    var result = jsonDecode(response.body);
    navPop(context: context);
    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        // log('message=======>>>>>   $result');
        _uId = result['user_id'];
        _isForgot = true;
        notifyListeners();
      } else {
        customToast(context: context, msg: result['message'], type: 0);
        _isForgot = false;
        notifyListeners();
      }
    } else {
      customToast(context: context, msg: result['message'], type: 0);
      _isForgot = false;
      notifyListeners();
    }
  }

  Future<void> verifyForgotOTP(
      {required BuildContext context, required Map data}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _isVerify = false;
    var url = Uri.parse(Apis.verifyForgotOtp);
    // debugPrint('Data-==>  $url');
    showLoaderDialog(context, 'Please wait...');
    final response =
        await ApiClient().postData(context: context, url: url, body: data);
    var result = jsonDecode(response.body);
    log('OTP Result---------->>>>   $result');
    navPop(context: context);
    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        pref.setBool(isUserLoginKey, true);
        pref.setString(accessTokenKey, result['access_token']);
        pref.setString(userIdKey, result['user_id']);
        _isVerify = true;

        notifyListeners();
      } else {
        customToast(context: context, msg: result['message'], type: 0);
        _isVerify = false;
        notifyListeners();
      }
    } else {
      customToast(context: context, msg: result['message'], type: 0);
      _isVerify = false;
      notifyListeners();
    }
  }

  Future<void> changePass(
      {required BuildContext context, required Map data}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var url = Uri.parse(Apis.changePassword);
    _isChange = false;
    // debugPrint('Data-==>  $url');
    showLoaderDialog(context, 'Please wait...');
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);
    var result = jsonDecode(response.body);
    navPop(context: context);
    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        // log('message=======>>>>>   $result');
        // pref.setBool(isUserLoginKey, true);
        // pref.setString(accessTokenKey, result['access_token']);
        // pref.setString(userIdKey, result['user_id']);
        _isChange = true;
        notifyListeners();
      } else {
        customToast(context: context, msg: result['message'], type: 0);
        _isChange = false;
        notifyListeners();
      }
    } else {
      customToast(context: context, msg: result['message'], type: 0);
      _isChange = false;
      notifyListeners();
    }
  }

  Future<void> askLocationPermissions() async {
    log('ask permission');
    var status = await Permission.location.status;

    if (status == PermissionStatus.granted) {
      // _isLocEnable = true;
      notifyListeners();
    } else if (status == PermissionStatus.denied) {
      Permission.location.request();
    } else if (status == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    } else if (status == PermissionStatus.limited) {
      Permission.location.request();
    } else if (status == PermissionStatus.restricted) {
      Permission.location.request();
      log('location permission restricted');
    }
  }

  Future<void> getAddress() async {
    _locationData = await location.getLocation();

    List<Placemark> placeMark = await placemarkFromCoordinates(
        _locationData!.latitude!, _locationData!.longitude!);
    if (placeMark != null && placeMark.length > 0) {
      Placemark place = placeMark[0];
      _address =
          '${place.subLocality} ${place.locality}, ${place.isoCountryCode}';
      countryController.text = '${place.country}';
      cityController.text = '${place.locality}';
      areaController.text = place.subLocality ?? '';
    }
    log('Location------->>>>  $_address');
    notifyListeners();
  }
}
/*import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_fire/screens/homeScreen.dart';
import 'package:task_fire/utils/constant.dart';
import '../models/userModel.dart';
import '../utils/colors.dart';
import '/utils/commonWidgets.dart';
import '/utils/messaging_service.dart';

import '../utils/apiService.dart';
import '../utils/apis.dart';
import '../utils/customLoader.dart';

class AuthProvider with ChangeNotifier {
  TextEditingController logEmailController = TextEditingController();
  TextEditingController logPassController = TextEditingController();
  TextEditingController regEmailController = TextEditingController();
  TextEditingController regMobController = TextEditingController();
  TextEditingController regPassController = TextEditingController();
  TextEditingController regCPassController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool _pass = true;
  bool _cPass = true;
  bool _lPass = true;

  bool get pass => _pass;

  bool get cPass => _cPass;

  bool get lPass => _lPass;

  void visible({required bool hide}) {
    _pass = !hide;
    log('message    $_pass');
    notifyListeners();
  }

  void visibleC({required bool hide}) {
    _cPass = !hide;
    log('message    $_cPass');
    notifyListeners();
  }

  void visibleL({required bool hide}) {
    _lPass = !hide;
    log('message    $_lPass');
    notifyListeners();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _userModel;

  UserModel? get userModel => _userModel;

  Future<void> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    _userModel = UserModel.fromJson(snap);
    log('Data--->>   ${_userModel!.email}');
    notifyListeners();
  }

  Future<void> signup({required BuildContext context}) async {
    showLoaderDialog(context, 'Registering....');
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential user = await auth.createUserWithEmailAndPassword(
          email: regEmailController.text, password: regPassController.text);
      log('-----------------${user.user!.uid}');

      UserModel userModel = UserModel(
        email: regEmailController.text,
        name: nameController.text,
        uid: user.user!.uid,
        mobile: regMobController.text,
      );

      await _firestore.collection('users').doc(user.user!.uid).set(
            userModel.toJson(),
          );
      notifyUser(context: context);
      context.pop();
      pref.setBool(isUserLoginKey, true);
      pref.setString(userIdKey, user.user!.uid);
      getUserDetails();
      context.go(home);
    } on FirebaseAuthException catch (e) {
      context.pop();
      log('-----------------${e.code == 'email-already-in-use'}');
      switch (e.code) {
        case 'email-already-in-use':
          commonAlert(context, '${e.message}');
      }
    }

    notifyListeners();
  }

  Future<void> loggedIn({required BuildContext context}) async {
    showLoaderDialog(context, 'Please wait...');
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: logEmailController.text, password: logPassController.text);

      pref.setBool(isUserLoginKey, true);
      pref.setString(userIdKey, user.user!.uid);

      context.pop();
      getUserDetails();
      context.go(home);
      // navPushRemove(context: context,action: HomeScreen());
    } on FirebaseAuthException catch (e) {
      context.pop();
      log('message---------------->>>>>>> ${e.code}');
      switch (e.code) {
        case 'user-not-found':
          commonAlert(context, '${e.message}');
          break;
        case 'invalid-email':
          commonAlert(context, '${e.message}');
          break;
        case 'wrong-password':
          commonAlert(context, '${e.message}');
          break;
        case 'INVALID_LOGIN_CREDENTIALS':
          commonAlert(context, '${e.message}');
          break;
      }
    }
    // User user = FirebaseAuth.instance.currentUser!;
    // log('userData------------->>     ${user.displayName}');

    notifyListeners();
  }

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

  Future<void> logOut({required BuildContext context}) async {
    showLoaderDialog(context, 'Please wait...');
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      _auth.signOut();
      pref.clear();
      context.pop();
      context.pushReplacement(login);
      customToast(msg: 'Logged out', color: red);
    } on Exception catch (e) {
      // TODO
      context.pop();
    }
  }
}*/
