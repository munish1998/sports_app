import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:touchmaster/model/usersModel.dart';
import 'package:touchmaster/service/apiConstant.dart';
import 'package:touchmaster/service/apiService.dart';

class profileProvider with ChangeNotifier {
  List<UsersModel> _userlist = [];
  List<UsersModel> get userlist => _userlist;
  List<UsersModel> _followlist = [];
  List<UsersModel> get followlist => _followlist;
  List<UsersModel> _suggestlist = [];
  List<UsersModel> get suggestlist => _suggestlist;

  bool _isEdit = false;
  bool get isEdit => _isEdit;

  Future<void> getAllUsers(
      {required BuildContext context, required Map data}) async {
    var url = Uri.parse(Apis.allUsers);
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);
    var result = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        var list = result['users'] as List;
        _userlist = list.map((e) => UsersModel.fromJson(e)).toList();
        for (var item in _userlist) {
          if (item.follow == 'yes') {
            _followlist.add(item);
          } else {
            _suggestlist.add(item);
          }
        }
        notifyListeners();
      }
    }
  }
}
