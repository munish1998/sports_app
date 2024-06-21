import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touchmaster/utils/commonMethod.dart';

import '../model/planModel.dart';
import '../service/apiConstant.dart';
import '../service/apiService.dart';
import '../utils/customLoader.dart';
import 'authProvider.dart';

class PlanProvider with ChangeNotifier {
  List<PlanModel> _subscription = [];
  PlanModel? planModel;
  List<PlanModel> get subscription => _subscription;

  Future<void> getSubscription(
      {required BuildContext context, required Map data}) async {
    var url = Uri.parse(Apis.subscription);
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);
    // log('Response--------->>>  ${response.body}');
    var result = jsonDecode(response.body);
    log('response of get subscription===>>>$result');
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

  Future<void> buySubscription(
      {required BuildContext context, required Map data}) async {
    var url = Uri.parse(Apis.buySubscription);
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);
    log('Response--------->>>  ${response.body}');
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

  Future buySubsciption11(
      {required BuildContext context, required Map data}) async {
    var url = Uri.parse(Apis.buySubscription);

    notifyListeners();
    showLoaderDialog(context, 'Please wait...');

    try {
      final response = await ApiClient()
          .postDataByToken(context: context, url: url, body: data);
      navPop(context: context);
      log('final response subscription===>>>$url');
      log('data response rresponmse fvff----- ===>>>$data');
      //  if (response.statusCode == 200) {
      return jsonDecode(response.body);
      // log('result of subscription====>>>>$result');
      // int code = result['code'];
      // String message = result['message'];

      // if (code == 200) {
      //   // Subscription details received successfully
      //   Map<String, dynamic> subscription = result['subscription'];
      //   String orderId = subscription['order_id'];
      //   String secretKey = subscription['secret_key'];
      //   String amount = subscription['amount'];
      //   String currency = subscription['currency'];
      //   String enviroment = subscription['enviroment'];
      //   String merchantName = subscription['merchant_name'];
      // } else if (code == 401) {
      //   Provider.of<AuthProvider>(context, listen: false).logout(context);
      // } else {
      //   customToast(context: context, msg: message, type: 0);
      // }
      // } else {
      //   customToast(
      //       context: context,
      //       msg: 'Failed to load subscription details',
      //       type: 0);
      // }
    } catch (e) {
      customToast(context: context, msg: 'Error: $e', type: 0);
    }
    notifyListeners();
  }

  Future buySubscription1({
    required BuildContext context,
    required Map data,
  }) async {
    var url = Uri.parse(Apis.buySubscription);

    notifyListeners();
    // showLoaderDialog(context, 'Please wait...');
    try {} catch (e) {}
    try {
      final response = await ApiClient().postDataByToken(
        context: context,
        url: url,
        body: data,
      );
      return jsonDecode(response.body);
      // if (response.statusCode == 200) {
      //   // Decode the response body
      //   var result = jsonDecode(response.body);

      //   // Check the 'code' from the response
      //   int code = result['code'];
      //   String message = result['message'];

      //   if (code == 200) {
      //     // Subscription details received successfully
      //     Map<String, dynamic> subscription = result['subscription'];
      //     String orderId = subscription['order_id'];
      //     String secretKey = subscription['secret_key'];
      //     String amount = subscription['amount'];
      //     String currency = subscription['currency'];
      //     String environment = subscription['environment'];
      //     String merchantName = subscription['merchant_name'];

      //     // Return the subscription details
      //     return {
      //       'order_id': orderId,
      //       'secret_key': secretKey,
      //       'amount': amount,
      //       'currency': currency,
      //       'environment': environment,
      //       'merchant_name': merchantName,
      //     };
      //   } else if (code == 401) {
      //     Provider.of<AuthProvider>(context, listen: false).logout(context);
      //   } else {
      //     customToast(context: context, msg: message, type: 0);
      //   }
      // } else {
      //   customToast(
      //     context: context,
      //     msg: 'Failed to load subscription details',
      //     type: 0,
      //   );
      // }
    } catch (e) {
      customToast(context: context, msg: 'Error: $e', type: 0);
    }

    // Dismiss the loader dialog
    // navPop(context: context);
    navPop(context: context);
    // Notify listeners
    // notifyListeners();
    notifyListeners();

    return null;
  }
}
