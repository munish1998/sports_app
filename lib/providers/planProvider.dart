import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/planModel.dart';
import '../service/apiConstant.dart';
import '../service/apiService.dart';
import '../utils/customLoader.dart';
import 'authProvider.dart';

class PlanProvider with ChangeNotifier {
  List<PlanModel> _subscription = [];

  List<PlanModel> get subscription => _subscription;

  Future<void> getSubscription(
      {required BuildContext context, required Map data}) async {
    var url = Uri.parse(Apis.subscription);
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);
    // log('Response--------->>>  ${response.body}');
    var result = jsonDecode(response.body);
    _subscription.clear();
    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        var list = result['subscriptions'] as List;
        _subscription = list.map((e) => PlanModel.fromJson(e)).toList();
        notifyListeners();
      } else if (result['code'] == 401) {
        Provider.of<AuthProvider>(context, listen: false).logout(context);
      } else {
        customToast(context: context, msg: result['message'], type: 0);
        notifyListeners();
      }
    } else {
      customToast(context: context, msg: result['message'], type: 0);
      notifyListeners();
    }
  }
}
