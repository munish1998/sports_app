import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../service/apiConstant.dart';
import '../service/apiService.dart';
import '../utils/color.dart';
import '../utils/constant.dart';
import '../utils/customLoader.dart';
import '/model/commentModel.dart';
import '/utils/commonMethod.dart';
import 'authProvider.dart';

class VideoProvider with ChangeNotifier {
  bool _isUpload = false;

  bool get isUpload => _isUpload;

  String _thumbFile = '';

  String get thumbFile => _thumbFile;

  List<CommentModel> _comments = [];

  List<CommentModel> get comments => _comments;

  UploadModel? _uploadModel;

  UploadModel? get uploadModel => _uploadModel;

  void onChange() async {
    _isUpload = false;
  }

  Future<void> uploadVideo({
    required BuildContext context,
    required Map<String, String> data,
    required String videoFile,
    required String thumbFile,
  }) async {
    var url = Uri.parse(Apis.upLoadVideo);
    showLoaderDialog(context, 'Video uploading...');
    SharedPreferences pref = await SharedPreferences.getInstance();
    //var fileName = path.basename(filePath);
    _isUpload = false;
    _thumbFile = '';
    try {
      var request = http.MultipartRequest('POST', url);
      log('video file is empyty on thisline =====>>>>>');
      if (videoFile.isNotEmpty) {
        var thumbnail =
            await http.MultipartFile.fromPath('thumbnail', thumbFile);
        var video = await http.MultipartFile.fromPath('video', videoFile);
        log('respopnse of video ===>>>>$video');
        request.files.add(thumbnail);
        request.files.add(video);
        log("FileName:--->${videoFile}");
      }
      // 'Content-Type': 'application/x-www-form-urlencoded'
      request.headers['access_token'] =
          pref.getString(accessTokenKey).toString();
      request.headers['Content-Type'] = 'application/x-www-form-urlencoded';

      request.fields.addAll(data);

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      log("Requests Progress--->$request    }");
      log('request of upload video==>>>$response');
      log('response of thumbnail====>>>>$_thumbFile');
      log("PostResponse----> $responseString");
      log("StatusCodePost---->${response.statusCode}");
      navPop(context: context);
      var result = jsonDecode(responseString);
      if (response.statusCode >= 200) {
        if (result['code'] == 200) {
          _uploadModel = UploadModel.fromJson(result);
          log('response of _uploadmodel====>>>>$_uploadModel');
          // getThumb(_uploadModel!.thumbnail);
          _isUpload = true;
          commonToast(msg: result['message'], color: green);

          notifyListeners();
        } else {
          commonToast(msg: result['message'], color: red);
          _isUpload = false;
          notifyListeners();
        }
      } else {
        commonToast(msg: result['message'], color: red);
        _isUpload = false;
        notifyListeners();
      }
    } catch (e) {
      log(e.toString());
    } finally {
      // TODO

      // navPop(context: context);
    }
  }

  Future<void> getThumb(BuildContext context, String url) async {
    _thumbFile = '';
    showLoaderDialog(context, "Please wait...");
    String tempPath = (await getApplicationCacheDirectory()).path;
    log('DataWorkin------------- $url  \n  ------------  $tempPath ');
    await VideoThumbnail.thumbnailFile(
      video: url,
      thumbnailPath: tempPath,
      imageFormat: ImageFormat.PNG,
      // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 100,
    ).then((value) {
      log('ThumbUrlFile----------$value');
      navPop(context: context);
      _thumbFile = value!;
      notifyListeners();
    });
  }

  void onShareSocial(BuildContext context, String video) async {
    await getThumb(context, video).then((value) {
      if (thumbFile.isNotEmpty) {
        Share.shareFiles([thumbFile],
            text: 'Hi, \nWelcome to Touch Master \n$video');
      }
    });
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
        _comments = list.map((e) => CommentModel.fromJson(e)).toList();
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

  Future<void> videoStatics(
      {required BuildContext context, required Map data}) async {
    var url = Uri.parse(Apis.addChat);

    // debugPrint('Data-==>  $url');
    // showLoaderDialog(context, 'Please wait...');
    final response = await ApiClient()
        .postDataByToken(context: context, url: url, body: data);
    // log('Response--Video------->>>  ${response.body}');
    var result = jsonDecode(response.body);
    // navPop(context: context);
    if (response.statusCode == 200) {
      if (result['code'] == 200) {
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

class UploadModel {
  String videoId;
  String thumbnail;
  String video;

  UploadModel({
    required this.videoId,
    required this.thumbnail,
    required this.video,
  });

  factory UploadModel.fromJson(Map<String, dynamic> json) => UploadModel(
        videoId: json["video_id"].toString(),
        thumbnail: json["thumbnail"],
        video: json["video"],
      );

  Map<String, dynamic> toJson() => {
        "video_id": videoId,
        "thumbnail": thumbnail,
        "video": video,
      };
}
