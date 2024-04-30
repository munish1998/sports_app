import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touchmaster/model/inboxMessageModel.dart';
import 'package:touchmaster/model/mesageModel.dart';
import 'package:touchmaster/providers/authProvider.dart';
import 'package:touchmaster/service/apiConstant.dart';
import 'package:touchmaster/service/apiService.dart';
import 'package:touchmaster/utils/customLoader.dart';

class MessageProvider with ChangeNotifier {
  bool isMessage = false;
  String _msg = '';

  String get msg => _msg;
  List<MessageInboxModel> _inboxList = [];
  List<MessageInboxModel> get inboxList => _inboxList;
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

  Future<void> getChatInbox({
    required BuildContext context,
    required Map data,
  }) async {
    try {
      var url = Uri.parse(Apis.inboxHistory);

      final response = await ApiClient().postDataByToken(
        context: context,
        url: url,
        body: data,
      );
      log('respone of inboxlist api=======>>>>>>>>${response.body}');
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result['code'] == 200) {
          var list = result['chats'] as List;
          _inboxList.clear(); // Clear existing chat list
          _inboxList = list.map((e) => MessageInboxModel.fromJson(e)).toList();
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
        // Add the new message to the local chat list
        _chatList.add(MessageModel.fromJson(result['message']));
        // Notify listeners to update the UI
        notifyListeners();
      } else if (result['code'] == 401) {
        // Handle unauthorized access
      } else if (result['code'] == 201) {
        // Handle other status codes if needed
      } else {
        // Handle other cases
        notifyListeners();
      }
    } else {
      customToast(context: context, msg: result['message'], type: 0);
      notifyListeners();
    }
  }

  Future<void> getComment(
      {required BuildContext context, required Map data}) async {
    var url = Uri.parse(Apis.getComment);
    // debugPrint('Data-==>  $url');
    // showLoaderDialog(context, 'Please wait...');
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);
    // log('Response--Comment------->>>  ${response.body}');
    var result = jsonDecode(response.body);
    // navPop(context: context);
    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        var list = result['comments'] as List;
        // _comments = list.map((e) => CommentModel.fromJson(e)).toList();
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

  Future<void> addComment(
      {required BuildContext context, required Map data}) async {
    var url = Uri.parse(Apis.addComment);
    // debugPrint('Data-==>  $url');
    // showLoaderDialog(context, 'Please wait...');
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);
    // log('Response--Video------->>>  ${response.body}');
    var result = jsonDecode(response.body);
    // navPop(context: context);
    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        var body = {
          'user_id': data['user_id'],
          'video_id': data['video_id'],
        };
        getComment(context: context, data: body);
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
}
