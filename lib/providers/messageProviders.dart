import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touchmaster/model/mesageModel.dart';
import 'package:touchmaster/providers/authProvider.dart';
import 'package:touchmaster/service/apiConstant.dart';
import 'package:touchmaster/service/apiService.dart';
import 'package:touchmaster/utils/customLoader.dart';

class MessageProvider with ChangeNotifier {
  bool isMessage = false;
  String _msg = '';

  String get msg => _msg;
  List<MessageModel> _chatList = [];
  List<MessageModel> get chatList => _chatList;

  Future<void> getChat({
    required BuildContext context,
    required Map data,
  }) async {
    try {
      var url = Uri.parse(Apis.getchatHistory);

      final response = await ApiClient().postDataByToken(
        context: context,
        url: url,
        body: data,
      );
      log('respone of chatlist api=======>>>>>>>>${response.body}');
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result['code'] == 200) {
          var list = result['chats'] as List;
          _chatList.clear(); // Clear existing chat list
          _chatList = list.map((e) => MessageModel.fromJson(e)).toList();
          notifyListeners();
        } else if (result['code'] == 401) {
          Provider.of<AuthProvider>(context, listen: false).logout(context);
        } else if (result['code'] == 201) {
        } else {}
      } else {}
    } catch (error) {}
  }

  Future<void> addChat({
    required BuildContext context,
    required Map data,
  }) async {
    var url = Uri.parse(Apis.addChat);
    log('url response=====$url');
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);
    var result = jsonDecode(response.body);
    log('provider chat response===========================${response.body}');
    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        notifyListeners();
      } else if (result['code'] == 401) {
      } else if (result['code'] == 201) {
      } else {
        notifyListeners();
      }
    } else {
      customToast(context: context, msg: result['message'], type: 0);

      notifyListeners();
    }
  }
}
