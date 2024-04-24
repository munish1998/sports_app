import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchmaster/model/personalizeModel.dart';
import 'package:touchmaster/model/rewardModel.dart';

import '../screens/authScreen/login.dart';
import '../service/apiConstant.dart';
import '../service/apiService.dart';
import '../utils/color.dart';
import '../utils/commonMethod.dart';
import '../utils/constant.dart';
import '../utils/customLoader.dart';
import '/model/profileModel.dart';
import '/model/profileVideoModel.dart';
import '/providers/authProvider.dart';

class ProfileProvider with ChangeNotifier {
  bool _isEdit = false;

  bool get isEdit => _isEdit;
  ProfileModel? _profileModel;

  ProfileModel? get profileModel => _profileModel;

  List<RewardModel> _rewardList = [];

  List<RewardModel> get rewardList => _rewardList;

  List<PersonalizeModel> _personalizeCards = [];

  List<PersonalizeModel> get personalizeCards => _personalizeCards;

  List<ProfileVideoModel> _profilePostVideos = [];

  List<ProfileVideoModel> get profilePostVideos => _profilePostVideos;

  List<ProfileVideoModel> _profileDraftVideos = [];

  List<ProfileVideoModel> get profileDraftVideos => _profileDraftVideos;

  List<ProfileVideoModel> _profileSaveVideos = [];

  List<ProfileVideoModel> get profileSaveVideos => _profileSaveVideos;

  // List<ReelModel> _postReelVideo = [];

  TextEditingController _nameController = TextEditingController();

  TextEditingController get nameController => _nameController;
  TextEditingController _emailController = TextEditingController();

  TextEditingController get emailController => _emailController;
  TextEditingController _phoneController = TextEditingController();

  TextEditingController get phoneController => _phoneController;
  TextEditingController _countryController = TextEditingController();

  TextEditingController get countryController => _countryController;
  TextEditingController _cityController = TextEditingController();

  TextEditingController get cityController => _cityController;
  TextEditingController _areaController = TextEditingController();

  TextEditingController get areaController => _areaController;

  setFalse() async {
    _isEdit = false;
    notifyListeners();
  }

  Future<void> getProfile(
      {required BuildContext context, required Map data}) async {
    var url = Uri.parse(Apis.getProfile);
    // debugPrint('Data-==>  $url');
    // showLoaderDialog(context, 'Please wait...');
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);
    // log('Response--------->>>  ${response.statusCode}');
    // navPop(context: context);
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      if (result['code'] == 200) {
        _profileModel = ProfileModel.fromJson(result['user']);
        _nameController.text = _profileModel!.name;
        _emailController.text = _profileModel!.email;
        _phoneController.text = _profileModel!.contactNumber;
        _countryController.text = _profileModel!.country;
        _cityController.text = _profileModel!.city;
        _areaController.text = _profileModel!.area;
        _isEdit = false;
        notifyListeners();
      } else {
        Provider.of<AuthProvider>(context, listen: false).logout(context);
        // customToast(context: context, msg: result['message'], type: 0);
        notifyListeners();
      }
    } else {
      Provider.of<AuthProvider>(context, listen: false).logout(context);
      // customToast(context: context, msg: result['message'], type: 0);

      notifyListeners();
    }
  }

  Future<void> editProfile(
      {required BuildContext context, required Map data}) async {
    var url = Uri.parse(Apis.updateProfile);
    _isEdit = false;
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

        _isEdit = true;
        notifyListeners();
        commonToast(msg: result['message'], color: green);
        getProfile(context: context, data: {'user_id': data['user_id']});

        // customToast(context: context, msg: result['message'], type: 1);
      } else if (result['code'] == 401) {
        navPushRemove(context: context, action: LoginScreen());
      } else {
        commonToast(msg: result['message'], color: red);
        // customToast(context: context, msg: result['message'], type: 0);
        _isEdit = false;
        notifyListeners();
      }
    } else {
      commonToast(msg: result['message'], color: red);

      // customToast(context: context, msg: result['message'], type: 0);
      _isEdit = false;
      notifyListeners();
    }
  }

  Future<void> editProfileIMG(
      {required BuildContext context,
      required Map<String, String> data,
      required String filePath}) async {
    var url = Uri.parse(Apis.updateProfile);
    showLoaderDialog(context, 'Please wait...');
    SharedPreferences pref = await SharedPreferences.getInstance();
    //var fileName = path.basename(filePath);
    _isEdit = false;
    try {
      var request = http.MultipartRequest('POST', url);

      if (filePath.isNotEmpty) {
        var pic =
            await http.MultipartFile.fromPath('profile_picture', filePath);
        request.files.add(pic);
        log("FileName:--->$filePath");
      }
      // 'Content-Type': 'application/x-www-form-urlencoded'
      request.headers['access_token'] =
          pref.getString(accessTokenKey).toString();
      request.headers['Content-Type'] = 'application/x-www-form-urlencoded';

      request.fields.addAll(data);

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      log("Requests--->$request");
      log("PostResponse----> $responseString");
      log("StatusCodePost---->${response.statusCode}");
      var result = jsonDecode(responseString);
      if (response.statusCode >= 200) {
        if (result['code'] == 200) {
          _isEdit = true;
          commonToast(msg: result['message'], color: green);
          notifyListeners();
          getProfile(context: context, data: {'user_id': data['user_id']});
        } else {
          commonToast(msg: result['message'], color: red);
          _isEdit = false;
          notifyListeners();
        }
      } else {
        commonToast(msg: result['message'], color: red);
        _isEdit = false;
        notifyListeners();
      }
    } catch (e) {
      log(e.toString());
    } finally {
      // TODO

      navPop(context: context);
    }
  }

  Future<void> editProfileBG(
      {required BuildContext context, required String filePath}) async {
    var url = Uri.parse(Apis.updateProfileBG);
    // showLoaderDialog(context, 'Please wait...');
    SharedPreferences pref = await SharedPreferences.getInstance();
    //var fileName = path.basename(filePath);
    _isEdit = false;
    try {
      var request = http.MultipartRequest('POST', url);

      if (filePath.isNotEmpty) {
        var pic = await http.MultipartFile.fromPath('bg_picture', filePath);
        request.files.add(pic);
        log("FileName:--->$filePath");
      }
      // 'Content-Type': 'application/x-www-form-urlencoded'
      request.headers['access_token'] =
          pref.getString(accessTokenKey).toString();
      request.headers['Content-Type'] = 'application/x-www-form-urlencoded';

      request.fields.addAll({'user_id': pref.getString(userIdKey).toString()});

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      log("Requests--->$request");
      log("PostResponse----> $responseString");
      log("StatusCodePost---->${response.statusCode}");
      var result = jsonDecode(responseString);
      if (response.statusCode >= 200) {
        if (result['code'] == 200) {
          _isEdit = true;
          commonToast(msg: result['message'], color: green);
          getProfile(
              context: context,
              data: {'user_id': pref.getString(userIdKey).toString()});
          notifyListeners();
        } else {
          commonToast(msg: result['message'], color: red);
          _isEdit = false;
          notifyListeners();
        }
      } else {
        commonToast(msg: result['message'], color: red);
        _isEdit = false;
        notifyListeners();
      }
    } catch (e) {
      log(e.toString());
    } finally {
      // TODO

      // navPop(context: context);
    }
  }

  Future<void> _editpersonalizeCard(
      {required BuildContext context,
      required String filepath,
      required String cardId}) async {
    var data = Uri.parse(Apis.updatePersonalizeCard);
    SharedPreferences pref = await SharedPreferences.getInstance();
    // _edit = false;
    try {
      var request = http.MultipartRequest('POST', data);
      if (filepath.isNotEmpty) {
        var pic = await http.MultipartFile.fromPath('image', filepath);
        request.files.add(pic);
      }
      request.headers['access_Token'] =
          pref.getString(accessTokenKey).toString();
      request.headers['content_Type'] = 'application/x-www-form-urlencoded';
      request.fields.addAll({'user_id': pref.getString(userIdKey).toString()});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> editProfileCard({
    required BuildContext context,
    required String filePath,
    required String cardId,
  }) async {
    var url = Uri.parse(Apis.updatePersonalizeCard);
    // showLoaderDialog(context, 'Please wait...');
    SharedPreferences pref = await SharedPreferences.getInstance();
    //var fileName = path.basename(filePath);
    _isEdit = false;
    try {
      var request = http.MultipartRequest('POST', url);

      if (filePath.isNotEmpty) {
        var pic = await http.MultipartFile.fromPath('image', filePath);
        request.files.add(pic);
        log("FileName:--->$filePath");
      }
      // 'Content-Type': 'application/x-www-form-urlencoded'
      request.headers['access_token'] =
          pref.getString(accessTokenKey).toString();
      request.headers['Content-Type'] = 'application/x-www-form-urlencoded';

      request.fields.addAll(
          {'user_id': pref.getString(userIdKey).toString(), 'card_id': cardId});

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      log("Requests--->$request");
      log("PostResponse----> $responseString");
      log("StatusCodePost---->${response.statusCode}");
      var result = jsonDecode(responseString);
      if (response.statusCode >= 200) {
        if (result['code'] == 200) {
          _isEdit = true;
          commonToast(msg: result['message'], color: green);
          getProfile(
              context: context,
              data: {'user_id': pref.getString(userIdKey).toString()});
          notifyListeners();
        } else {
          commonToast(msg: result['message'], color: red);
          _isEdit = false;
          notifyListeners();
        }
      } else {
        commonToast(msg: result['message'], color: red);
        _isEdit = false;
        notifyListeners();
      }
    } catch (e) {
      log(e.toString());
    } finally {
      // TODO

      // navPop(context: context);
    }
  }

  Future<void> _personalizecardImage(
      {required BuildContext context,
      required String filePath,
      required String cardId}) async {
    var url = Uri.parse(Apis.updatePersonalizeCard);
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      var request = http.MultipartRequest('post', url);
      if (filePath.isEmpty) {
        var pic = await http.MultipartFile.fromPath('image', filePath);
        request.files.add(pic);
        log('filepath name=======>>>>>>>$filePath');
      }
      request.headers['access_Token'] =
          pref.getString(accessTokenKey).toString();
      request.headers['content_Type'] = 'application/x-www-form-urlencoded';
      request.fields.addAll(
          {'user_id': pref.getString(userIdKey).toString(), 'card_id': cardId});
    } catch (e) {
      return print(e.toString());
    }
  }

  Future<void> getProfilePostVideos(
      {required BuildContext context, required Map data}) async {
    var url = Uri.parse(Apis.getProfileVideo);
    // debugPrint('Data-==>  $url');
    // showLoaderDialog(context, 'Please wait...');
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);
    // log('Response--Video------->>>  ${response.body}');
    var result = jsonDecode(response.body);
    // navPop(context: context);
    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        var list = result['videos'] as List;
        _profilePostVideos =
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

  Future<void> getProfileDraftVideos(
      {required BuildContext context, required Map data}) async {
    var url = Uri.parse(Apis.getProfileVideo);
    // debugPrint('Data-==>  $url');
    // showLoaderDialog(context, 'Please wait...');
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);
    // log('Response--------->>>  ${response.body}');
    var result = jsonDecode(response.body);
    // navPop(context: context);
    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        var list = result['videos'] as List;
        _profileDraftVideos =
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

  Future<void> getProfileSaveVideos(
      {required BuildContext context, required Map data}) async {
    var url = Uri.parse(Apis.getProfileVideo);
    // debugPrint('Data-==>  $url');
    // showLoaderDialog(context, 'Please wait...');
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);
    // log('Response--------->>>  ${response.body}');
    var result = jsonDecode(response.body);
    // navPop(context: context);
    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        var list = result['videos'] as List;
        _profileSaveVideos =
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

  Future<void> getRewards(
      {required BuildContext context, required Map data}) async {
    var url = Uri.parse(Apis.getRewards);
    // debugPrint('Data-==>  $url');
    // debugPrint('Data-==>  $data');
    // showLoaderDialog(context, 'Please wait...');
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);
    // log('Response--Reward------->>>  ${response.body}');
    var result = jsonDecode(response.body);
    // navPop(context: context);
    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        var list = result['levels'] as List;
        _rewardList = list.map((e) => RewardModel.fromJson(e)).toList();

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

  Future<void> getPersonalizeCard(
      {required BuildContext context, required Map data}) async {
    var url = Uri.parse(Apis.getPersonalizeCard);
    // debugPrint('Data-==>  $url');
    // log('getpersonalizedCard data====>>>>>$url');
    // log('personalizedcard data =====>>>>$data');
    debugPrint('Data-==>  $data');
    _personalizeCards.clear();
    // showLoaderDialog(context, 'Please wait...');
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);
    // log('Response--Card------->>>  ${response.body}');
    var result = jsonDecode(response.body);
    // navPop(context: context);
    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        var list = result['cards'] as List;
        _personalizeCards =
            list.map((e) => PersonalizeModel.fromJson(e)).toList();

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
