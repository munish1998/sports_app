import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_saver/files.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchmaster/model/inboxMessageModel.dart';
import 'package:touchmaster/model/mesageModel.dart';
import 'package:touchmaster/model/notificationModel.dart';
import 'package:touchmaster/providers/authProvider.dart';
import 'package:touchmaster/service/apiConstant.dart';
import 'package:touchmaster/service/apiService.dart';
import 'package:touchmaster/utils/color.dart';
import 'package:touchmaster/utils/constant.dart';
import 'package:touchmaster/utils/customLoader.dart';

class MessageProvider with ChangeNotifier {
  bool isMessage = false;
  String _msg = '';
  SharedPreferences? pref;
  String get msg => _msg;
  List<MessageInboxModel> _inboxList = [];
  List<MessageInboxModel> get inboxList => _inboxList;
  List<MessageModel> _chatList = [];
  List<MessageModel> get chatList => _chatList;
  List<NotificationModel> _notifyList = [];

  List<NotificationModel> get notifyList => _notifyList;

  Future<void> getChatHistory({
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
      log('response of chat list api=======>>>>>>>>${response.body}');
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
    required Map<String, dynamic> data,
    File? imageFile,
  }) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userId = pref.getString(userIdKey);
    if (userId != null) {
      data['user_id'] = userId;
    }

    var url = Uri.parse(Apis.addChat);
    log('url response=====$url');

    try {
      // Use ApiClient.postDataByToken to send the request with the access token
      final response = await ApiClient().postDataByToken(
          context: context, url: url, body: data, imageFile: imageFile);

      var result = jsonDecode(response.body);
      log('provider chat response===========================${response.body}');

      // Handle response based on status code and result
      if (response.statusCode == 200) {
        if (result['code'] == 200) {
          // Call getChatInbox to update the inbox messages list
          await getChatInbox(context: context, data: {'user_id': userId});
          // Call getChatHistory to update the chat messages list
          await getChatHistory(
              context: context,
              data: {'user_id': userId, 'chat_user_id': data['receiver_id']});
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
    } catch (error) {
      // Handle any errors that occur during the request
      log('Error sending message: $error');
    }
  }

  Future<void> editProfileBG(
      {required BuildContext context,
      required Map<String, dynamic> data,
      required String filePath,
      required String msg,
      required String receiverID}) async {
    var url = Uri.parse(Apis.addChat);
    // showLoaderDialog(context, 'Please wait...');
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userId = pref.getString(userIdKey);
    if (userId != null) {
      data['user_id'] = userId;
    }
    //var fileName = path.basename(filePath);

    try {
      var request = http.MultipartRequest('POST', url);

      if (filePath.isNotEmpty) {
        var pic = await http.MultipartFile.fromPath('filename', filePath);
        request.files.add(pic);
        log("FileName:--->$filePath");
      }
      // 'Content-Type': 'application/x-www-form-urlencoded'
      request.headers['access_token'] =
          pref.getString(accessTokenKey).toString();
      request.headers['Content-Type'] = 'application/x-www-form-urlencoded';

      request.fields.addAll({
        'sender_id': pref.getString(userIdKey).toString(),
        'receiver_id': receiverID,
        'message': msg,
        'filename': filePath
      });

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      log('response of data fetch by cat screen===>>>${response.contentLength}');
      log("Requests--->$request");
      log("PostResponse----> $responseString");
      log("StatusCodePost---->${response.statusCode}");
      var result = jsonDecode(responseString);
      if (response.statusCode >= 200) {
        if (result['code'] == 200) {
          commonToast(msg: result['message'], color: green);
          getChatInbox(context: context, data: {'user_id': userId});
          // getProfile(
          //     context: context,
          //     data: {'user_id': pref.getString(userIdKey).toString()});
          notifyListeners();
        } else {
          commonToast(msg: result['message'], color: red);

          notifyListeners();
        }
      } else {
        commonToast(msg: result['message'], color: red);

        notifyListeners();
      }
    } catch (e) {
      log(e.toString());
    } finally {
      // TODO

      // navPop(context: context);
    }
  }

  sendMessage(
      {required BuildContext context, required Map<String, Object?> data}) {}
}
