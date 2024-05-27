import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touchmaster/utils/customLoader.dart';

import '../screens/authScreen/login.dart';
import '../service/apiConstant.dart';
import '../service/apiService.dart';
import '../utils/color.dart';
import '../utils/commonMethod.dart';
import '/model/exerciseModel.dart';
import '/model/levelModel.dart';
import 'authProvider.dart';

class LevelProvider with ChangeNotifier {
  bool _isExercise = false;

  bool get isExercise => _isExercise;

  List<PopupMenuEntry<PopUpModel>> _listLevel = [];

  List<PopupMenuEntry<PopUpModel>> get listLevel => _listLevel;

  List<LevelModel> _levelList = [];

  List<LevelModel> get levelList => _levelList;

  List<ExerciseModel> _exerciseList = [];

  List<ExerciseModel> get exerciseList => _exerciseList;

  PopupMenuItem<PopUpModel> popupMenu(PopUpModel value) =>
      PopupMenuItem<PopUpModel>(
        value: value,
        child: Container(
          width: 200,
          child: Text(value.title),
        ),
      );

  void initFirstLevel() {
    if (_levelList.isNotEmpty && _levelList[0].lockstatus == 'locked') {
      _levelList[0].lockstatus = 'unlocked';
      notifyListeners();
    }
  }

  void initAllLevels() {
    for (int i = 1; i < _levelList.length; i++) {
      _levelList[i].lockstatus = 'locked';
    }
    notifyListeners();
  }

  Future<void> getLevels(
      {required BuildContext context, required Map data}) async {
    var url = Uri.parse(Apis.levels);
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);
    // log('Response--------->>>  ${response.body}');
    _listLevel.clear();
    _listLevel.add(popupMenu(PopUpModel(title: 'Overall', value: '0')));
    var result = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        var list = result['levels'] as List;
        _levelList = list.map((e) => LevelModel.fromJson(e)).toList();
        if (_levelList.isNotEmpty) {
          _levelList[0].lockstatus == 'unlocked';
        }
        for (int i = 0; i < _levelList.length; i++) {
          _listLevel.add(popupMenu(
              PopUpModel(title: _levelList[i].title, value: '${i + 1}')));
        }
        notifyListeners();
      } else if (result['code'] == 401) {
        Provider.of<AuthProvider>(context, listen: false).logout(context);
      } else if (result['code'] == 201) {
        Provider.of<AuthProvider>(context, listen: false).logout(context);
      } else {
        // customToast(context: context, msg: result['message'], type: 0);
        notifyListeners();
      }
    } else {
      // customToast(context: context, msg: result['message'], type: 0);
      notifyListeners();
    }
  }

  Future<void> getExercises(
      {required BuildContext context, required Map data}) async {
    var url = Uri.parse(Apis.exercises);
    _isExercise = false;
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);
    // log('Response--------->>>  ${response.body}');
    var result = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        var list = result['exercises'] as List;
        _exerciseList = list.map((e) => ExerciseModel.fromJson(e)).toList();
        _isExercise = true;
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

  Future<void> completeExercises(
      {required BuildContext context, required Map data}) async {
    var url = Uri.parse(Apis.completeExercise);

    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);
    // log('Response----CC----->>>  ${response.body}');
    var result = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        commonToast(msg: result['message'], color: green);
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

class PopUpModel {
  String title;
  String value;

  PopUpModel({required this.title, required this.value});
}
