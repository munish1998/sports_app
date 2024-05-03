import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touchmaster/model/mesageModel.dart';

import '../model/profileModel.dart';
import '../model/profileVideoModel.dart';
import '../model/usersModel.dart';
import '../service/apiConstant.dart';
import '../service/apiService.dart';
import 'authProvider.dart';

class UsersProvider with ChangeNotifier {
  List<UsersModel> _usersList = [];

  List<UsersModel> get usersList => _usersList;
  List<UsersModel> _usersFollowList = [];

  List<MessageModel> _chatList = [];
  List<MessageModel> get chatList => _chatList;

  List<UsersModel> get usersFollowList => _usersFollowList;

  List<UsersModel> _usersSuggestList = [];

  List<UsersModel> get usersSuggestList => _usersSuggestList;

  List<ProfileVideoModel> _profileVideos = [];

  List<ProfileVideoModel> get profileVideos => _profileVideos;

  ProfileModel? _userProfile;

  ProfileModel? get userProfile => _userProfile;

  bool _isProfile = false;

  bool get isProfile => _isProfile;

  Map<String, Color> challengeButtonColors = {};

  // Method to update the color of the challenge button for a user
  void updateChallengeButtonColor(String userId, Color color) {
    challengeButtonColors[userId] = color;
    notifyListeners();
  }

  Future<void> removeUser(UsersModel item, int type) async {
    if (type == 0) {
      _usersFollowList.remove(item);
    } else {
      _usersSuggestList.remove(item);
    }
    notifyListeners();
  }

  Future<void> getChat5({
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
          var list = result['Chat History'] as List;
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

  Future<void> addUser(UsersModel item, int type) async {
    if (type == 0) {
      _usersFollowList.add(item);
    } else {
      _usersSuggestList.add(item);
    }
    notifyListeners();
  }

  Future<void> getAllUsers(
      {required BuildContext context, required Map data}) async {
    var url = Uri.parse(Apis.allUsers);
    _usersList.clear();
    _usersSuggestList.clear();
    _usersFollowList.clear();
    // debugPrint('Data-==>  $url');
    // showLoaderDialog(context, 'Please wait...');
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);
    // log('Response--------->>>  ${response.body}');
    var result = jsonDecode(response.body);
    // navPop(context: context);
    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        var list = result['users'] as List;
        _usersList = list.map((e) => UsersModel.fromJson(e)).toList();
        for (var item in _usersList) {
          if (item.follow == 'yes') {
            _usersFollowList.add(item);
          } else if (item.follow == 'no') {
            _usersSuggestList.add(item);
          }
        }
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

  Future<void> getUsersProfile(
      {required BuildContext context, required Map data}) async {
    var url = Uri.parse(Apis.getUsersProfile);
    _isProfile = false;
    _userProfile = null;
    notifyListeners();
    // debugPrint('Data-==>  $url');
    // showLoaderDialog(context, 'Please wait...');
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);
    // log('Response--------->>>  ${response.body}');
    var result = jsonDecode(response.body);
    // navPop(context: context);
    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        _userProfile = ProfileModel.fromJson(result['user']);
        _isProfile = true;
        notifyListeners();
      } else if (result['code'] == 401) {
        Provider.of<AuthProvider>(context, listen: false).logout(context);
      } else if (result['code'] == 201) {
        _isProfile = false;
        notifyListeners();
        // Provider.of<AuthProvider>(context, listen: false).logout(context);
      } else {
        _isProfile = false;
        // customToast(context: context, msg: result['message'], type: 0);
        notifyListeners();
      }
    } else {
      // customToast(context: context, msg: result['message'], type: 0);

      notifyListeners();
    }
  }

  List<String> _challengedUserIds = [];

  // Method to mark a user as challenged
  void markAsChallenged(String userId) {
    _challengedUserIds.add(userId);
    notifyListeners(); // Notify listeners that the state has changed
  }

  Future<void> followUnFollow({
    required BuildContext context,
    required Map data,
  }) async {
    var url = Uri.parse(Apis.followUnfollow);
    // debugPrint('Data-==>  $url');
    // showLoaderDialog(context, 'Please wait...');
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);
    // log('Response--------->>>  ${response.body}');
    var result = jsonDecode(response.body);
    // navPop(context: context);
    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        log('DataFollow----------->>>>  ${data['user_id']}');
        // getAllUsers(
        //     context: context, data: {'user_id': data['user_id'].toString()});

        // customToast(
        //     context: context, msg: capitalize(result['message']), type: 1);
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

  Future<void> getUserProfileVideos(
      {required BuildContext context, required Map data}) async {
    var url = Uri.parse(Apis.getUsersProfileVideo);
    // debugPrint('Data-==>  $url');
    // showLoaderDialog(context, 'Please wait...');
    _profileVideos.clear();
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);
    log('Response--VideoUser------->>>  ${response.body}');
    var result = jsonDecode(response.body);
    // navPop(context: context);
    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        var list = result['videos'] as List;
        _profileVideos =
            list.map((e) => ProfileVideoModel.fromJson(e)).toList();

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
