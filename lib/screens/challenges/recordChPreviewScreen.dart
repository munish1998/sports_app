import 'dart:developer';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchmaster/main.dart';
import 'package:touchmaster/providers/challengesProvider.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

import '../../providers/videoProvider.dart';
import '../../utils/color.dart';
import '../../utils/constant.dart';
import '../home/dashboard.dart';
import '/utils/commonMethod.dart';
import '/utils/customLoader.dart';

class RecordChPreviewScreen extends StatefulWidget {
  final String file;
  final String challengeId;
  const RecordChPreviewScreen({
    super.key,
    required this.file,
    required this.challengeId,
  });

  @override
  State<RecordChPreviewScreen> createState() => _RecordChPreviewScreenState();
}

class _RecordChPreviewScreenState extends State<RecordChPreviewScreen> {
  VideoPlayerController? _playerController;
  ChewieController? _chewieController;
  Subscription? _subscription;
  TextEditingController titleController = TextEditingController();

  bool isPlay = false;
  String duration = '';

  double progress = 0;
  double height = 0;
  double width = 0;
  String compressedFile = '';
  String thumbImage = '';
  bool isSaved = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initFun();
  }

  _initFun() async {
    _subscription = VideoCompress.compressProgress$.subscribe((event) {
      setState(() {
        progress = event;
      });
    });
    onCompress();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _subscription!.unsubscribe();
    _playerController!.dispose();
    _chewieController!.dispose();
    VideoCompress.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.sizeOf(context).height;
    width = MediaQuery.sizeOf(context).width;
    final double value;
    value = progress / 100;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: appBar,
      body: body(value),
    );
  }

  AppBar get appBar => AppBar(
        backgroundColor: Colors.black,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
            _subscription!.unsubscribe;
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Video Preview',
          style: TextStyle(
              letterSpacing: 2,
              fontFamily: "BankGothic",
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w400),
        ),
      );

  AppBar get appBarUpload => AppBar(
        backgroundColor: Colors.black,
        leading: InkWell(
          onTap: () async {
            var pro = Provider.of<VideoProvider>(context, listen: false);
            if (!pro.isUpload) {
              Navigator.pop(context);
            } else {
              navPushRemove(context: context, action: DashboardScreen());
            }
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Upload Video',
          style: TextStyle(
              letterSpacing: 2,
              fontFamily: "BankGothic",
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w400),
        ),
      );

  Widget body(double value) => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _chewieController != null &&
                    _chewieController!.videoPlayerController.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _chewieController!
                        .videoPlayerController.value.aspectRatio,
                    child: Chewie(
                      controller: _chewieController!,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        backgroundColor: white,
                        value: value,
                        valueColor: AlwaysStoppedAnimation<Color>(green),
                      ),
                      // LinearProgressIndicator(
                      //   value: value,
                      //   minHeight: 5,
                      //   valueColor: AlwaysStoppedAnimation<Color>(green),
                      // ),
                      SizedBox(height: 10),
                      Text(
                        'Loading... ${progress.toInt()}%',
                        style: TextStyle(color: white),
                      )
                    ],
                  ),
            _chewieController != null &&
                    _chewieController!.videoPlayerController.value.isInitialized
                ? saveAndShare
                : Container(),
          ],
        ),
      );

  Widget get saveAndShare => Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: DottedBorder(
          color: primary,
          dashPattern: [13, 4],
          strokeWidth: 2,
          radius: Radius.circular(30),
          borderType: BorderType.RRect,
          child: Container(
            height: 60,
            width: 200,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.12, -0.99),
                  end: Alignment(-0.12, 0.99),
                  colors: [
                    Color(0xFF7971B5),
                    Color(0xFF202243),
                  ],
                ),
                borderRadius: BorderRadius.circular(30)
                // shape: OvalBorder(
                //   side: BorderSide(width: 0.50, color: Colors.white),
                // ),
                ),
            child: Row(
              mainAxisAlignment: isSaved
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    onPending(widget.challengeId, 'attempt');
                    log('onpending response======>>>>>>>$onPending(challengeId, status)');
                    // var data = onPending(widget.challengeId, 'attempt');
                    // log('senderID of challenges=====>>>>>>$data');
                    // log('challenge status details ========>>>>>>>>$data');
                  },

                  // onTap: onShare,
                  child: Text(
                    "Send",
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  Future<void> onPending(
    String challengeId,
    String status,
  ) async {
    var pro = Provider.of<ChallengeProvider>(context, listen: false);
//var senderUserId = preferences!.getString(userIdKey).toString();
    var data = {
      'user_id': preferences!.getString(userIdKey).toString(),
      'challenge_id': challengeId,
      'status': 'attempt',
    };
    //log('print sender user id =======>>>>>>>>$');
    log('challenges update data response=====>>>>>>>>>$data');

    try {
      await pro.updateChallengeStatus(
        context: context,
        data: data,
      );
      customToast(context: context, msg: 'Challenge status updated', type: 1);
    } catch (error) {
      log('Error while updating challenge status: $error');

      customToast(
          context: context, msg: 'Failed to update challenge status', type: 0);
    }
  }

  Future<void> onCompress() async {
    File file = File(widget.file);
    log('MediaFile---------->>>>  ${await file.length() / 1000}');

    MediaInfo? mediaInfo = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.DefaultQuality,
      includeAudio: true,
      deleteOrigin: false, // It's false by default
    );

    setState(() {
      compressedFile = mediaInfo!.file!.path;
    });
    onCreateThumb(filePath: compressedFile);
    // log('MediaFile---------->>>> ${mediaInfo!.filesize! / 1000} ${await file.length() / 1000}');
    _playerController = VideoPlayerController.file(File(mediaInfo!.file!.path))
      ..initialize().then((value) {
        duration = _playerController!.value.duration.toString();
        // log('VideoDuration------>>>${widget.file}  $duration');
        setState(() {});
      });
    _chewieController = ChewieController(
      videoPlayerController: _playerController!,
      autoPlay: true,
      showControls: true,
      looping: false,
      allowFullScreen: false,
      cupertinoProgressColors: ChewieProgressColors(playedColor: primary),
    );
    setState(() {});
    // await Future.wait([
    //   _playerController!.initialize().then((value) {
    //     isPlay = true;
    //     duration = _playerController!.value.captionOffset.toString();
    //     log('VideoDuration------>>>  $duration');
    //   })
    // ]);
  }

  Future<void> onCreateThumb({required String filePath}) async {
    final thumbnailFile = await VideoCompress.getFileThumbnail(filePath,
        quality: 50, // default(100)
        position: -1 // default(-1)
        );
    setState(() {
      thumbImage = thumbnailFile.path;
    });
    log('GetThumbnail---------->>>>>>>>>>>>>>>>${thumbnailFile.path}');
  }

  Future<void> onShare() async {
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        context: context,
        builder: (context) => Container(
              height: height * 0.95,
              child: Scaffold(
                backgroundColor: Colors.black,
                appBar: appBarUpload,
                body: bodyUpload,
              ),
            ));
  }

  Future<void> onSave() async {
    // setState(() {
    //   titleController.text = 'Saved this video';
    // });
    // onUpload('draft');
    saveVideo();
  }

  Widget get bodyUpload =>
      Consumer<VideoProvider>(builder: (context, data, child) {
        return Container(
          margin: EdgeInsets.all(15),
          child: ListView(
            children: [
              Container(
                height: height * 0.5,
                width: width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(
                      File(thumbImage),
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                style: GoogleFonts.mulish(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: white,
                ),
                controller: titleController,
                decoration: InputDecoration(
                    hintText: 'Enter title here',
                    hintStyle: GoogleFonts.mulish(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: white.withOpacity(0.5),
                    ),
                    isDense: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Color(0xffC4C4C4).withOpacity(0.2)),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.25),
                child: data.isUpload
                    ? button(
                        label: 'Share', isNext: false, onTap: onShareSocial)
                    : button(
                        label: 'Upload',
                        isNext: false,
                        onTap: () {
                          onUpload('post');
                        }),
              )
            ],
          ),
        );
      });

  Future<void> onUpload(String type) async {
    var pro = Provider.of<VideoProvider>(context, listen: false);
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String, String> data = {};
    if (titleController.text.isEmpty) {
      customToast(context: context, msg: 'Please enter title', type: 0);
    } else {
      data = {
        'user_id': pref.getString(userIdKey).toString(),
        'challenge_id': widget.challengeId,
        'video_type': 'reel',
        'title': titleController.text,
        'video_length': duration,
        'status': type
      };
      /* {'thumbnail': thumbImage,
        'video': compressedFile,}*/
      pro
          .uploadVideo(
              context: context,
              data: data,
              videoFile: compressedFile,
              thumbFile: thumbImage)
          .then((value) {
        if (pro.isUpload) {
          commonAlert(context, "Video has been successfully uploaded");
          // if (type != 'draft') {
          //   navPushRemove(context: context, action: DashboardScreen());
          // }
        }
      });
    }

    log('Upload Data------------->>>>  $data');
  }

  void saveVideo() async {
    GallerySaver.saveVideo(compressedFile).whenComplete(() {
      setState(() {
        isSaved = true;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Video Saved!!!!")));
    });
  }

  void onShareSocial() async {
    var pro = Provider.of<VideoProvider>(context, listen: false);
    await pro.getThumb(context, pro.uploadModel!.video).then((value) {
      if (pro.thumbFile.isNotEmpty) {
        Share.shareFiles([pro.thumbFile],
            text: 'Hi, \nWelcome to Touch Master \n${pro.uploadModel!.video}');
      }
    });
  }

  // Future<void> onPending(
  //   String challengeid,
  //   String status,
  // ) async {
  //   var pro = Provider.of<ChallengeProvider>(context, listen: false);
  //   var data = {
  //     'user_id': preferences!.getString(userIdKey).toString() ?? '',
  //     'challenge_id': widget.challengeId,
  //     'status': attempt,
  //   };
  //   log('status challenge show details=======>>>>>>>>$status');
  //   pro.updateChallengeStatus(context: context, data: data).then((value) {});
  //   log('onpending response data======>>>>>>> $data');
  //   customToast(context: context, msg: 'challenge has been sent', type: 1);
  // }
}
