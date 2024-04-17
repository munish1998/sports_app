import 'dart:convert';

import 'package:flutter/material.dart';

import '../service/apiConstant.dart';
import '../service/apiService.dart';
import '../utils/customLoader.dart';
import '/model/contentModel.dart';

class ContentProvider with ChangeNotifier {
  ContentModel? _contentAbout;

  ContentModel? get contentAbout => _contentAbout;
  ContentModel? _contentTerms;

  ContentModel? get contentTerms => _contentTerms;
  ContentModel? _contentPrivacy;

  ContentModel? get contentPrivacy => _contentPrivacy;

  Future<void> getAbout({required BuildContext context}) async {
    var url = Uri.parse(Apis.about);
    // debugPrint('Data-==>  $url');

    final response = await ApiClient().getData(
      context: context,
      uri: url,
    );

    var result = jsonDecode(response.body);

    // log('TnCDetail ----->>>  $result');

    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        _contentAbout = ContentModel.fromJson(result);

        notifyListeners();
      } else {
        customToast(context: context, msg: result['message'], type: 0);

        notifyListeners();
      }
      notifyListeners();
    }
  }

  Future<void> getPrivacy({required BuildContext context}) async {
    var url = Uri.parse(Apis.privacyPolicy);
    // debugPrint('Data-==>  $url');

    final response = await ApiClient().getData(
      context: context,
      uri: url,
    );

    var result = jsonDecode(response.body);

    // log('TnCDetail ----->>>  $result');

    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        _contentPrivacy = ContentModel.fromJson(result);

        notifyListeners();
      } else {
        customToast(context: context, msg: result['message'], type: 0);

        notifyListeners();
      }
      notifyListeners();
    }
  }

  Future<void> getTnC({required BuildContext context}) async {
    var url = Uri.parse(Apis.termsCondition);
    // debugPrint('Data-==>  $url');

    final response = await ApiClient().getData(
      context: context,
      uri: url,
    );

    var result = jsonDecode(response.body);

    // log('TnCDetail ----->>>  $result');

    if (response.statusCode == 200) {
      if (result['code'] == 200) {
        _contentTerms = ContentModel.fromJson(result);
        // log('TnCDetail ----->>>  $_contentTerms');
        notifyListeners();
      } else {
        customToast(context: context, msg: result['message'], type: 0);

        notifyListeners();
      }
      notifyListeners();
    }
  }
}
