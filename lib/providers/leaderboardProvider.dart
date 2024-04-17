import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:touchmaster/utils/customLoader.dart';

import '../model/leaderboardModel.dart';
import '../screens/authScreen/login.dart';
import '../service/apiConstant.dart';
import '../service/apiService.dart';
import '../utils/commonMethod.dart';

class LeaderboardProvider with ChangeNotifier {
  List<String> _country = [];

  List<String> get country => _country;
  List<String> _city = [];

  List<String> get city => _city;
  List<String> _area = [];

  List<String> get area => _area;

  List<LeaderboardModel> _leaderTop = [];

  List<LeaderboardModel> get leaderTop => _leaderTop;

  List<LeaderboardModel> _leaderboardList = [];

  List<LeaderboardModel> get leaderboardList => _leaderboardList;
  List<LeaderboardModel> _leaderWeekTop = [];

  List<LeaderboardModel> get leaderWeekTop => _leaderWeekTop;

  List<LeaderboardModel> _leaderboardWeekList = [];

  List<LeaderboardModel> get leaderboardWeekList => _leaderboardWeekList;
  List<LeaderboardModel> _leaderMonthTop = [];

  List<LeaderboardModel> get leaderMonthTop => _leaderMonthTop;

  List<LeaderboardModel> _leaderboardMonthList = [];

  List<LeaderboardModel> get leaderboardMonthList => _leaderboardMonthList;

  //https://mocki.io/v1/19f05f84-52af-4ded-a22e-7828ecfdeb20

  Future<void> getLeaderboard(
      {required BuildContext context,
      required Map data,
      required bool isHome}) async {
    var url = Uri.parse(Apis.getLeaderboard);
    // debugPrint('Data-==>  $url   $data');
    if (!isHome) {
      showLoaderDialog(context, 'Please wait...');
    }
    _leaderTop.clear();
    _leaderboardList.clear();
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);

    var result = jsonDecode(response.body);

    log('Leaderboard ----->>>  $result');
    if (!isHome) {
      navPop(context: context);
    }
    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        var list = result['leaderboard'] as List;
        _leaderTop = list.map((e) => LeaderboardModel.fromJson(e)).toList();
        log('LeaderTopResult--------------->>>   ${_leaderTop.length}');

        for (int i = 3; i < _leaderTop.length; i++) {
          _leaderboardList.add(_leaderTop[i]);
        }
        notifyListeners();
      } else if (result['code'] == 401) {
        navPushRemove(context: context, action: LoginScreen());
      } else {
        // customToast(context: context, msg: result['message'], type: 0);
        notifyListeners();
      }
    } else {
      // customToast(context: context, msg: result['message'], type: 0);
      notifyListeners();
    }
  }

  Future<void> getLeaderboardWeek(
      {required BuildContext context,
      required Map data,
      required bool isHome}) async {
    var url = Uri.parse(Apis.getLeaderboard);
    // debugPrint('Data-==>  $url   $data');
    if (!isHome) {
      showLoaderDialog(context, 'Please wait...');
    }
    _leaderWeekTop.clear();
    _leaderboardWeekList.clear();
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);

    var result = jsonDecode(response.body);

    log('Leaderboard ----->>>  $result');
    if (!isHome) {
      navPop(context: context);
    }
    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        var list = result['leaderboard'] as List;
        _leaderWeekTop = list.map((e) => LeaderboardModel.fromJson(e)).toList();
        log('LeaderTopResult--------------->>>   ${_leaderWeekTop.length}');

        for (int i = 3; i < _leaderWeekTop.length; i++) {
          _leaderboardWeekList.add(_leaderWeekTop[i]);
        }
        notifyListeners();
      } else if (result['code'] == 401) {
        navPushRemove(context: context, action: LoginScreen());
      } else {
        // customToast(context: context, msg: result['message'], type: 0);
        notifyListeners();
      }
    } else {
      // customToast(context: context, msg: result['message'], type: 0);
      notifyListeners();
    }
  }

  Future<void> getLeaderboardMonth(
      {required BuildContext context,
      required Map data,
      required bool isHome}) async {
    var url = Uri.parse(Apis.getLeaderboard);
    // debugPrint('Data-==>  $url   $data');
    if (!isHome) {
      showLoaderDialog(context, 'Please wait...');
    }
    _leaderMonthTop.clear();
    _leaderboardMonthList.clear();
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);

    var result = jsonDecode(response.body);

    log('Leaderboard ----->>>  $result');
    if (!isHome) {
      navPop(context: context);
    }
    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        var list = result['leaderboard'] as List;
        _leaderMonthTop =
            list.map((e) => LeaderboardModel.fromJson(e)).toList();
        log('LeaderTopResult--------------->>>   ${_leaderMonthTop.length}');

        for (int i = 3; i < _leaderMonthTop.length; i++) {
          _leaderboardMonthList.add(_leaderMonthTop[i]);
        }
        notifyListeners();
      } else if (result['code'] == 401) {
        navPushRemove(context: context, action: LoginScreen());
      } else {
        // customToast(context: context, msg: result['message'], type: 0);
        notifyListeners();
      }
    } else {
      // customToast(context: context, msg: result['message'], type: 0);
      notifyListeners();
    }
  }

  Future<void> getCountry(
      {required BuildContext context, required Map data}) async {
    var url = Uri.parse(Apis.getLocation);
    // debugPrint('Data-==>  $url   $data');
    _country.clear();
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);

    var result = jsonDecode(response.body);

    log('Leaderboard ----->>>  $result');

    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        var list = result['locations'] as List;

        for (var item in list) {
          _country.add(item);
        }

        notifyListeners();
      } else if (result['code'] == 401) {
        navPushRemove(context: context, action: LoginScreen());
      } else {
        // customToast(context: context, msg: result['message'], type: 0);
        notifyListeners();
      }
    } else {
      // customToast(context: context, msg: result['message'], type: 0);
      notifyListeners();
    }
  }

  Future<void> getCity(
      {required BuildContext context, required Map data}) async {
    var url = Uri.parse(Apis.getLocation);
    // debugPrint('Data-==>  $url   $data');
    _city.clear();
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);

    var result = jsonDecode(response.body);

    log('Leaderboard ----->>>  $result');

    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        var list = result['locations'] as List;

        for (var item in list) {
          _city.add(item);
        }

        notifyListeners();
      } else if (result['code'] == 401) {
        navPushRemove(context: context, action: LoginScreen());
      } else {
        // customToast(context: context, msg: result['message'], type: 0);
        notifyListeners();
      }
    } else {
      // customToast(context: context, msg: result['message'], type: 0);
      notifyListeners();
    }
  }

  Future<void> getArea(
      {required BuildContext context, required Map data}) async {
    var url = Uri.parse(Apis.getLocation);
    // debugPrint('Data-==>  $url   $data');
    _area.clear();
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);

    var result = jsonDecode(response.body);

    log('Leaderboard ----->>>  $result');

    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        var list = result['locations'] as List;

        for (var item in list) {
          _area.add(item);
        }

        notifyListeners();
      } else if (result['code'] == 401) {
        navPushRemove(context: context, action: LoginScreen());
      } else {
        // customToast(context: context, msg: result['message'], type: 0);
        notifyListeners();
      }
    } else {
      // customToast(context: context, msg: result['message'], type: 0);
      notifyListeners();
    }
  }
}
