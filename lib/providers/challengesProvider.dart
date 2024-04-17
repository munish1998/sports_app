import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touchmaster/utils/commonMethod.dart';

import '../model/challengeModel.dart';
import '../service/apiConstant.dart';
import '../service/apiService.dart';
import '../utils/customLoader.dart';
import 'authProvider.dart';

class ChallengeProvider with ChangeNotifier {
  bool _isChallenged = false;

  bool get isChallenged => _isChallenged;

  String _msg = '';

  String get msg => _msg;

  List<ChallengeModel> _challengeList = [];

  List<ChallengeModel> get challengeList => _challengeList;

  Future<void> getChallenges(
      {required BuildContext context, required Map data}) async {
    var url = Uri.parse(Apis.getChallenges);
    // debugPrint('Data-==>  $url');
    // showLoaderDialog(context, 'Please wait...');
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);
    // log('list of challenges of users=======>>>>>>$response');
    // log('list of challenges=====>>>>>>>>>$data');
    // log('Response--------->>>  ${response.body}');
    var result = jsonDecode(response.body);
    // navPop(context: context);
    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        var list = result['notifications'] as List;
        _challengeList = list.map((e) => ChallengeModel.fromJson(e)).toList();
        notifyListeners();
      } else if (result['code'] == 401) {
        Provider.of<AuthProvider>(context, listen: false).logout(context);
      } else if (result['code'] == 201) {
        // Provider.of<AuthProvider>(context, listen: false).logout(context);
      } else {
        // customToast(context: context, msg: result['message'], type: 0);
        notifyListeners();
      }
    } else {
      // customToast(context: context, msg: result['message'], type: 0);

      notifyListeners();
    }
  }

  Future<void> challengeUser(
      {required BuildContext context, required Map data}) async {
    var url = Uri.parse(Apis.challengeUser);
    // debugPrint('Data-==>  $url');
    _isChallenged = false;
    _msg = '';
    notifyListeners();
    showLoaderDialog(context, 'Please wait...');
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);
    log('Response--------->>>  ${response.body}');
    var result = jsonDecode(response.body);
    navPop(context: context);
    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        // commonAlert(context, result['message']);
        _isChallenged = true;
        _msg = result['message'];
        notifyListeners();
      } else if (result['code'] == 401) {
        Provider.of<AuthProvider>(context, listen: false).logout(context);
      } else if (result['code'] == 201) {
        _isChallenged = true;
        _msg = result['message'];
        notifyListeners();
        // Provider.of<AuthProvider>(context, listen: false).logout(context);
      } else {
        _isChallenged = false;
        // customToast(context: context, msg: result['message'], type: 0);
        notifyListeners();
      }
    } else {
      _isChallenged = false;
      // customToast(context: context, msg: result['message'], type: 0);

      notifyListeners();
    }
  }

  // Future<void> updateChallengeStatus(
  //     {required BuildContext context, required Map data}) async {
  //   var url = Uri.parse(Apis.updateChallengeStatus);

  //   log('UpdateChallengeData---------------------->>>>  $data');
  //   // debugPrint('Data-==>  $url');
  //   // showLoaderDialog(context, 'Please wait...');
  //   final response = await ApiClient()
  //       .postDataByToken(context: context, url: url, body: data);
  //   log('Response--Video------->>>  ${response.body}');
  //   var result = jsonDecode(response.body);
  //   // navPop(context: context);
  //   if (response.statusCode == 200) {
  //     if (result['code'] == 200) {
  //       notifyListeners();
  //     } else if (result['code'] == 401) {
  //       Provider.of<AuthProvider>(context, listen: false).logout(context);
  //     } else if (result['code'] == 201) {
  //       // Provider.of<AuthProvider>(context, listen: false).logout(context);
  //     } else {
  //       // customToast(context: context, msg: result['message'], type: 0);
  //       notifyListeners();
  //     }
  //   } else {
  //     // customToast(context: context, msg: result['message'], type: 0);

  //     notifyListeners();
  //   }
  // }

  Future<void> updateChallengeStatus(
      {required BuildContext context,
      required Map<String, dynamic> data}) async {
    var url = Uri.parse(Apis.updateChallengeStatus);

    try {
      final response = await ApiClient()
          .postDataByToken(context: context, url: url, body: data);
      log('response of update challenge status is =====>>>>>>>>$response');
      log('Response--Video------->>>  ${response.body}');

      var result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (result['code'] == 200) {
          notifyListeners();
        } else if (result['code'] == 401) {
          Provider.of<AuthProvider>(context, listen: false).logout(context);
        } else if (result['code'] == 201) {
          // Handle specific status code if needed
        } else {
          // Handle other response codes if needed
          // customToast(context: context, msg: result['message'], type: 0);
          notifyListeners();
        }
      } else {
        // Handle other status codes if needed
        // customToast(context: context, msg: result['message'], type: 0);
        notifyListeners();
      }
    } catch (error) {
      log('Error updating challenge status: $error');
      // Handle network errors or other exceptions here
      throw error;
    }
  }

  String thumb =
      "https://www.webpristine.com/Touch-master/media/videos/thumbnail/143890017322012024130913.jpg";
  String video =
      "https://www.webpristine.com/Touch-master/media/videos/126345051722012024130913.mp4";
}
