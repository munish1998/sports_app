import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/commonMethod.dart';
import '../utils/constant.dart';

class ApiClient {
  Future<http.Response> getData(
      {required BuildContext context, required Uri uri}) async {
    try {
      final response = await http.get(
        uri,
      );
      // log('Response__GET___====>>${response.body.toString()}');
      return response;
    } on SocketException catch (e) {
      switch (e.osError!.errorCode) {
        case 7:
          commonAlert(context, 'No Internet Connection!');
          break;
        case 111:
          commonAlert(context, 'Unable to connect to server!');
          break;
      }
      log('Socket Exception thrown --> $e');
      return http.Response(e.toString(), 1);
    } on TimeoutException catch (e) {
      commonAlert(context, 'Please! Try Again');
      log('TimeoutException thrown --> $e');

      return http.Response(e.toString(), 1);
    } catch (e) {
      log(e.toString());
      return http.Response(e.toString(), 1);
    }
  }

  Future<http.Response> getDataByToken(
      {required BuildContext context, required Uri uri}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var header = {
        'id': prefs.getString(userIdKey).toString(),
        'Authorization': prefs.getString(accessTokenKey).toString(),
      };
      final response = await http.get(uri, headers: header);
      // log('Response__GET___====>>${response.body.toString()}');
      return response;
    } on SocketException catch (e) {
      switch (e.osError!.errorCode) {
        case 7:
          commonAlert(context, 'No Internet Connection!');
          break;
        case 111:
          commonAlert(context, 'Unable to connect to server!');
          break;
      }
      log('Socket Exception thrown --> $e');
      return http.Response(e.toString(), 1);
    } on TimeoutException catch (e) {
      commonAlert(context, 'Please! Try Again');
      log('TimeoutException thrown --> $e');

      return http.Response(e.toString(), 1);
    } catch (e) {
      log(e.toString());
      return http.Response(e.toString(), 1);
    }
  }

  Future<http.Response> getDataByPost(
      {required BuildContext context, required Uri uri}) async {
    try {
      final response = await http.post(
        uri,
      );
      // log('Response__GET_BY_POST___====>>${response.body.toString()}');
      return response;
    } on SocketException catch (e) {
      switch (e.osError!.errorCode) {
        case 7:
          commonAlert(context, 'No Internet Connection!');
          break;
        case 111:
          commonAlert(context, 'Unable to connect to server!');
          break;
      }
      log('Socket Exception thrown --> $e');
      return http.Response(e.toString(), 1);
    } on TimeoutException catch (e) {
      commonAlert(context, 'Please! Try Again');
      log('TimeoutException thrown --> $e');

      return http.Response(e.toString(), 1);
    } catch (e) {
      log(e.toString());
      return http.Response(e.toString(), 1);
    }
  }

  Future<http.Response> postData(
      {required BuildContext context,
      required Uri url,
      required Map body}) async {
    var header = {"Content-Type": "application/x-www-form-urlencoded"};
    try {
      // log('BodyData------------>>>>>>   $body');
      final response = await http.post(
        url,
        body: body,
        headers: header,
      );
      // log('Response__POST___====>>${response.body.toString()}');
      return response;
    } on SocketException catch (e) {
      switch (e.osError!.errorCode) {
        case 7:
          commonAlert(context, 'No Internet Connection!');
          break;
        case 111:
          commonAlert(context, 'Unable to connect to server!');
          break;
      }
      log('Socket Exception thrown --> $e');
      return http.Response(e.toString(), 1);
    } on TimeoutException catch (e) {
      commonAlert(context, 'Please! Try Again');
      log('TimeoutException thrown --> $e');

      return http.Response(e.toString(), 1);
    } catch (e) {
      log(e.toString());
      return http.Response(e.toString(), 1);
    }
  }

  Future<http.Response> postDataByToken(
      {required BuildContext context,
      required Uri url,
      required Map body}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var header = {
        'access_token': prefs.getString(accessTokenKey).toString(),
        'Content-Type': 'application/x-www-form-urlencoded'
      };
      // log('Header::---->>>  $header');
      // log('body::---->>>  $body');
      final response = await http.post(url, body: body, headers: header);
      // log('Response__POST___====>>${response.body.toString()}');
      return response;
    } on SocketException catch (e) {
      switch (e.osError!.errorCode) {
        // case 7:
        //   commonAlert(context, 'No Internet Connection!');
        //   break;
        case 111:
          commonAlert(context, 'Unable to connect to server!');
          break;
      }
      log('Socket Exception thrown --> $e');
      return http.Response(e.toString(), 1);
    } on TimeoutException catch (e) {
      commonAlert(context, 'Please! Try Again');
      log('TimeoutException thrown --> $e');

      return http.Response(e.toString(), 1);
    } catch (e) {
      log(e.toString());
      return http.Response(e.toString(), 1);
    }
  }

  Future<http.Response> login(
      {required BuildContext context,
      required Uri url,
      required Map body}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = prefs.getString(accessTokenKey).toString();
      var headers = {
        'Contect-type': 'application/json;charset-UTF-8',
      };
      // debugPrint('BODY___====>>$body');
      final response = await http.post(url, body: body);
      // debugPrint('Response__Status___====>>${response.statusCode.toString()}');
      // debugPrint('Response___====>>${response.body.toString()}');
      return response;
    } on SocketException catch (e) {
      switch (e.osError!.errorCode) {
        case 7:
          commonAlert(context, 'No Internet Connection!');
          break;
        case 111:
          commonAlert(context, 'Unable to connect to server!');
          break;
      }
      log('Socket Exception thrown --> $e');
      return http.Response(e.toString(), 1);
    } on TimeoutException catch (e) {
      commonAlert(context, 'Please! Try Again');
      log('TimeoutException thrown --> $e');

      return http.Response(e.toString(), 1);
    } catch (e) {
      log(e.toString());
      return http.Response(e.toString(), 1);
    }
  }
}
