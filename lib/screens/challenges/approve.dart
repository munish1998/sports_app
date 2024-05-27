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
import 'package:touchmaster/screens/exercise/exercisePlayerScreen.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

import '../../providers/levelProvider.dart';
import '../../providers/videoProvider.dart';
import '../../utils/color.dart';
import '../../utils/constant.dart';
import '/utils/commonMethod.dart';
import '/utils/customLoader.dart';

class RecordChPreviewScreen1 extends StatefulWidget {
  final String file;
  final String challengeId;

  const RecordChPreviewScreen1({
    Key? key,
    required this.file,
    required this.challengeId,
  }) : super(key: key);

  @override
  State<RecordChPreviewScreen1> createState() => _RecordChPreviewScreen1State();
}

class _RecordChPreviewScreen1State extends State<RecordChPreviewScreen1> {
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
    super.initState();
    _initFun();
  }

  _initFun() async {
    _subscription = VideoCompress.compressProgress$.subscribe((event) {
      setState(() {
        progress = event;
      });
    });
    Provider.of<VideoProvider>(context, listen: false).onChange();
    onCompress();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription!.unsubscribe();
    _playerController!.dispose();
    _chewieController!.dispose();
    VideoCompress.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
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
            fontWeight: FontWeight.w400,
          ),
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
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
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
            fontWeight: FontWeight.w400,
          ),
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
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: DottedBorder(
          color: primary,
          dashPattern: [13, 4],
          strokeWidth: 2,
          radius: Radius.circular(30),
          borderType: BorderType.RRect,
          child: Container(
            height: 60,
            width: (isSaved) ? 200 : double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.12, -0.99),
                end: Alignment(-0.12, 0.99),
                colors: [
                  Color(0xFF7971B5),
                  Color(0xFF202243),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: isSaved
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceEvenly,
              children: [
                (!isSaved)
                    ? InkWell(
                        onTap: onSave,
                        child: Text(
                          "Save",
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    : SizedBox(width: 0),
                (isSaved)
                    ? SizedBox(width: 0)
                    : VerticalDivider(
                        color: Colors.black,
                        thickness: 4,
                      ),
                InkWell(
                  onTap: onShare,
                  child: Text(
                    "Share",
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

    _playerController = VideoPlayerController.file(File(mediaInfo!.file!.path))
      ..initialize().then((value) {
        duration = _playerController!.value.duration.toString();
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
  }

  Future<void> onCreateThumb({required String filePath}) async {
    final thumbnailFile = await VideoCompress.getFileThumbnail(filePath,
        quality: 50, // default(100)
        position: -1 // default(-1)
        );
    setState(() {
      thumbImage = thumbnailFile.path;
      _subscription!.unsubscribe();
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
      ),
    );
  }

  Future<void> onSave() async {
    await saveVideoAndThumbnail();
  }

  Widget get bodyUpload => Consumer<VideoProvider>(
        builder: (context, data, child) {
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
                if (!data.isUpload)
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Color(0xffC4C4C4).withOpacity(0.2),
                    ),
                  ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.25),
                  child: data.isUpload
                      ? button(
                          label: 'Share',
                          isNext: false,
                          onTap: onShareSocial,
                        )
                      : button(
                          label: 'Upload',
                          isNext: false,
                          onTap: () {
                            onPending(
                              widget.challengeId,
                              'attempt',
                            );
                            onUpload('post');
                          },
                        ),
                )
              ],
            ),
          );
        },
      );

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
        'video_type': 'video',
        'title': titleController.text,
        'video_length': duration,
        'status': type
      };
      log('reponse of upload onupload api ===>>>$data');
      pro
          .uploadVideo(
        context: context,
        data: data,
        videoFile: compressedFile,
        thumbFile: thumbImage,
      )
          .then((value) {
        if (pro.isUpload) {
          commonAlert(context, "Exercise has been successfully uploaded");
          var exPro = Provider.of<LevelProvider>(context, listen: false);
          var exData = {
            'user_id': pref.getString(userIdKey).toString(),
            'exercise_id': widget.challengeId,
          };
          exPro.completeExercises(context: context, data: exData);
        }
      });
    }
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

  Future<void> saveVideoAndThumbnail() async {
    await saveVideo();
    await saveThumbnail();
  }

  Future<void> saveVideo() async {
    GallerySaver.saveVideo(compressedFile).whenComplete(() {
      setState(() {
        isSaved = true;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Video Saved!!!!")));
    });
  }

  Future<void> saveThumbnail() async {
    final result = await GallerySaver.saveImage(thumbImage);
    if (result != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Thumbnail Saved!!!!")));
    }
  }

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
}
