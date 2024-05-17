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

  Future buySubsciption1(
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

  Future<void> buySubsciption2({
    required BuildContext context,
    required String userId,
    required String planId,
    required Map<String, String> data,
  }) async {
    var url = Uri.parse(Apis.buySubscription);
    showLoaderDialog(context, 'Please wait...');

    try {
      final response = await ApiClient().postDataByToken(
        context: context,
        url: url,
        body: {
          'user_id': userId,
          'plan_id': planId,
        },
      );
      navPop(context: context);

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        int code = result['code'];
        String message = result['message'];

        if (code == 200) {
          // Subscription details received successfully
          Map<String, dynamic> subscription = result['subscription'];
          String orderId = subscription['order_id'];
          String secretKey = subscription['secret_key'];
          String amount = subscription['amount'];
          String currency = subscription['currency'];
          String enviroment = subscription['enviroment'];
          String merchantName = subscription['merchant_name'];

          // Handle subscription details as needed
          // For example, you can proceed with payment using orderId and secretKey
        } else if (code == 401) {
          // Unauthorized, handle logout or authentication error
          Provider.of<AuthProvider>(context, listen: false).logout(context);
        } else {
          // Handle other cases based on the code and message
          // For example, display an error message
          // customToast(context: context, msg: message, type: 0);
        }
      } else {
        // Handle non-200 status code, display error message if needed
        // customToast(context: context, msg: 'Failed to load subscription details', type: 0);
      }
    } catch (e) {
      // Handle exceptions, display error message if needed
      // customToast(context: context, msg: 'Error: $e', type: 0);
    } finally {
      // Notify listeners to indicate that the state change is complete
      Provider.of<PlanProvider>(context, listen: false).notifyListeners();
    }
  }
}
