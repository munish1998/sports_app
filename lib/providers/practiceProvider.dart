import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/practiceModel.dart';
import '../service/apiConstant.dart';
import '../service/apiService.dart';
import 'authProvider.dart';

class PracticeProvider with ChangeNotifier {
  int _cateIndex = 0;

  int get ceteIndex => _cateIndex;
  List<PracticeCateModel> _practiceCate = [];

  List<PracticeCateModel> get practiceCate => _practiceCate;

  List<PracticeModel> _practiceList = [];
  PracticeModel? _practiceModel;
  PracticeModel? get practiceModel => _practiceModel;

  List<PracticeModel> get practiceList => _practiceList;

  // List<String> practice = ['Endurance', 'Speed & Agility', 'Technical'];

  reset() async {
    _cateIndex = 0;
  }

  setIndex(int index) async {
    _cateIndex = index;
    notifyListeners();
  }

  Map<int, List<PracticeModel>> _categoryPracticeMap = {};

  // Method to set practice lists for each category
  void setCategoryPracticeMap(
      Map<int, List<PracticeModel>> categoryPracticeMap) {
    _categoryPracticeMap = categoryPracticeMap;
    notifyListeners();
  }

  // Method to get practice list for the selected category index
  List<PracticeModel> getPracticeListForCategory(int categoryIndex) {
    // Return the practice list for the selected category index
    return _categoryPracticeMap[categoryIndex] ?? [];
  }

  Future<void> getPracticeCategory(
      {required BuildContext context, required Map data}) async {
    var url = Uri.parse(Apis.practiceCategory);
    debugPrint('Data-==>  $url');
    // showLoaderDialog(context, 'Please wait...');
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);
    // log('Response--------->>>  ${response.body}');
    var result = jsonDecode(response.body);
    // navPop(context: context);
    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        var list = result['categories'] as List;
        _practiceCate = list.map((e) => PracticeCateModel.fromJson(e)).toList();
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

  Future<void> getPractices(
      {required BuildContext context, required Map data}) async {
    var url = Uri.parse(Apis.practices);
    debugPrint(
        'data respose=============================>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$url');
    // showLoaderDialog(context, 'Please wait...');
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);
    // log('Response of get practice--------->>>  ${response.body}');
    var result = jsonDecode(response.body);
    // navPop(context: context);
    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        var list = result['practices'] as List;
        _practiceList = list.map((e) => PracticeModel.fromJson(e)).toList();
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
}
