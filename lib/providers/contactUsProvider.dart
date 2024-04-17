import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service/apiConstant.dart';
import '../service/apiService.dart';
import '../utils/color.dart';
import '../utils/commonMethod.dart';
import '../utils/customLoader.dart';
import 'authProvider.dart';

class ContactUsProvider with ChangeNotifier {
  bool _isDone = false;

  bool get isDone => _isDone;

  List<QueryModel> _queries = [];

  List<QueryModel> get queries => _queries;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController queryController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  clean() async {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    messageController.clear();
    notifyListeners();
  }

  Future<void> submitContact(
      {required BuildContext context, required Map data}) async {
    var url = Uri.parse(Apis.contactUs);
    _isDone = false;
    // debugPrint('Data-==>  $url');
    showLoaderDialog(context, 'Please wait...');
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);
    // log('Response--------->>>  ${response.body}');
    var result = jsonDecode(response.body);
    navPop(context: context);
    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        // _profileModel = ProfileModel.fromJson(result['user']);
        messageController.clear();
        _isDone = true;
        clean();
        notifyListeners();
        // commonToast(msg: result['message'], color: green);

        // customToast(context: context, msg: result['message'], type: 1);
      } else if (result['code'] == 401) {
        Provider.of<AuthProvider>(context, listen: false).logout(context);
      } else {
        commonToast(msg: result['message'], color: red);
        // customToast(context: context, msg: result['message'], type: 0);
        _isDone = false;
        notifyListeners();
      }
    } else {
      commonToast(msg: result['message'], color: red);

      // customToast(context: context, msg: result['message'], type: 0);
      _isDone = false;
      notifyListeners();
    }
  }

  Future<void> getQueries(
      {required BuildContext context, required Map data}) async {
    var url = Uri.parse(Apis.getQueries);

    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);
    // log('Response--------->>>  ${response.body}');
    var result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        var list = result['levels'] as List;
        _queries = list.map((e) => QueryModel.fromJson(e)).toList();

        notifyListeners();
      } else if (result['code'] == 401) {
        Provider.of<AuthProvider>(context, listen: false).logout(context);
      } else {
        commonToast(msg: result['message'], color: red);
        notifyListeners();
      }
    } else {
      commonToast(msg: result['message'], color: red);
      notifyListeners();
    }
  }
}

class QueryModel {
  String title;

  QueryModel({required this.title});

  factory QueryModel.fromJson(Map<String, dynamic> json) =>
      QueryModel(title: json['title']);
}
