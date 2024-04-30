import 'dart:developer';
import 'package:chewie/chewie.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchmaster/main.dart';
import 'package:touchmaster/utils/customLoader.dart';
import 'package:video_player/video_player.dart';

import '../../model/challengeModel.dart';
import '../../utils/color.dart';
import '../../utils/constant.dart';
import '/app_image.dart';
import '/common/cacheImage.dart';
import '/providers/challengesProvider.dart';
import '/utils/commonMethod.dart';
import 'videoChRecordingScreen.dart';

class ChallengeScreen extends StatefulWidget {
  String userId = preferences!.getString(userIdKey) ?? '';
  ChallengeScreen({super.key});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  double height = 0;
  double width = 0;
  SharedPreferences? pref;
  VideoPlayerController? _vController;
  ChewieController? _chewController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initializePlayer();
    initFun();
    log('Current User ID: $userIdKey');
  }

  initFun() async {
    var pro = Provider.of<ChallengeProvider>(context, listen: false);

    pref = await SharedPreferences.getInstance();
    String userId = pref!.getString(userIdKey) ?? '';
    var data = {'user_id': userId};
    pro.getChallenges(context: context, data: data);
    log('userId ====>>>$userId');
    log('userIdkey====>>>$userIdKey');
  }

  Future<bool> initializePlayer(String video) async {
    showLoaderDialog(context, 'Loading...');
    _vController = VideoPlayerController.networkUrl(Uri.parse(video));
    log('video response ====>>>>$video');
    log('_vcontroller response====>>>>$_vController');
    await Future.wait([_vController!.initialize()]);
    _chewController = ChewieController(
      videoPlayerController: _vController!,
      autoPlay: false,
      showControls: false,
      looping: false,
    );

    setState(() {});
    navPop(context: context);
    return _vController!.value.isInitialized;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _vController!.dispose();
    _chewController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.sizeOf(context).height;
    width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: appBar,
      body: body,
    );
  }

  AppBar get appBar => AppBar(
        backgroundColor: Colors.black,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Challenges',
          style: TextStyle(
              letterSpacing: 2,
              fontFamily: "BankGothic",
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
      );

  Widget get body =>
      Consumer<ChallengeProvider>(builder: (context, data, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: ListView.separated(
              itemCount: data.challengeList.length,
              itemBuilder: (context, index) {
                return challengeItems(data.challengeList[index], userIdKey);
              },
              separatorBuilder: (context, index) => SizedBox(
                    height: 10,
                  )),
        );
      });

  Widget challengeItems(ChallengeModel item, String currentUserId) => Container(
        decoration: BoxDecoration(color: grey.withOpacity(0.3)),
        padding: EdgeInsets.all(5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppImage(
              (item.status == 'pending')
                  ? 'assets/target.png'
                  : (item.status == 'approve')
                      ? 'assets/approve.png'
                      : 'assets/declined.png',
              height: 75,
              width: 75,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    (item.status == 'decline')
                        ? 'Challenge declined by ${item.senderName}'
                        : (item.status == 'attempt')
                            ? 'Challenge attempted by ${item.senderName}'
                            : (item.status == 'approve')
                                ? 'Challenge approved by ${item.senderName}'
                                : '',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        item.senderUserId != currentUserId
                            ? item.status!
                            : item.datetime!,
                        style: TextStyle(color: white),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        item.senderUserId == currentUserId ? item.action! : '',
                        style: TextStyle(color: white),
                      ),
                    ],
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    (item.senderUserId == widget.userId &&
                            item.status == 'pending')
                        ? attemptBTN(item.video!, item.id!, item.thumbnail!)
                        : (item.status == 'attempt')
                            ? approvedBTN()
                            : (item.status == 'decline' &&
                                    item.senderUserId == widget.userId)
                                ? reAttendBTN(
                                    item.video!, item.id!, item.thumbnail!)
                                : (item.status == 'approve')
                                    ? Text('approved')
                                    : SizedBox(
                                        height: 0,
                                        width: 0,
                                      )
                  ]),
                ],
              ),
            )
          ],
        ),
      );

  Widget attemptBTN(String video, String challengeId, String thumb) =>
      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  gradient: cancel, borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.cancel_presentation,
                    color: white,
                    size: 18,
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    'Cancel',
                    style: TextStyle(color: white, fontSize: 12),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                initializePlayer(video).then((value) {
                  attemptAlert(
                      context: context, challengeId: challengeId, thumb: thumb);

                  log('response of pending challenge ====>>>>$video');
                  log('response of pending challenge ====>>>>$thumb');
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    gradient: attempt, borderRadius: BorderRadius.circular(8)),
                child: Text(
                  'attempt',
                  style: TextStyle(color: white),
                ),
              ),
            )
          ],
        ),
      );

  Widget attempted(String video, String challengeId, String thumb) => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  gradient: cancel, borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.cancel_presentation,
                    color: white,
                    size: 18,
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    'Cancel',
                    style: TextStyle(color: white, fontSize: 12),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                initializePlayer(video).then((value) {
                  attemptAlert(
                      context: context, challengeId: challengeId, thumb: thumb);

                  log('response of pending challenge ====>>>>$video');
                  log('response of pending challenge ====>>>>$thumb');
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    gradient: attempt, borderRadius: BorderRadius.circular(8)),
                child: Text(
                  'attempted',
                  style: TextStyle(color: white),
                ),
              ),
            )
          ],
        ),
      );
  Widget approvedBTN() => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                approveAlert(context: context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    gradient: approved, borderRadius: BorderRadius.circular(8)),
                child: Text(
                  'Approved',
                  style: TextStyle(color: white),
                ),
              ),
            )
          ],
        ),
      );

  Widget reAttendBTN(String video, String challengeId, String thumb) =>
      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                initializePlayer(video).then((value) {
                  if (value) {
                    attemptAlert(
                        context: context,
                        challengeId: challengeId,
                        thumb: thumb);
                  }
                });
                log('response of reattempt challenge====>>>>>$thumb');
                log('response of chllengeId===>>$challengeId');
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    gradient: attempt, borderRadius: BorderRadius.circular(8)),
                child: Text(
                  'ReAttempt',
                  style: TextStyle(color: white, fontSize: 12),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  gradient: declined, borderRadius: BorderRadius.circular(8)),
              child: Text(
                'Declined',
                style: TextStyle(color: white),
              ),
            )
          ],
        ),
      );

  Future<void> attemptAlert({
    required BuildContext context,
    required String challengeId,
    required String thumb,
  }) async {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return Container(
              height: 500,
              width: width * 0.8,
              margin: EdgeInsets.symmetric(horizontal: 20) +
                  EdgeInsets.only(top: 100, bottom: 100),
              decoration: BoxDecoration(
                  color: Color(0xff323232),
                  borderRadius: BorderRadius.circular(8)),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            navPop(context: context);
                            _vController!.pause();
                          },
                          icon: Icon(
                            Icons.clear,
                            color: white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Beat him to earn more rewards",
                      style: TextStyle(
                          letterSpacing: 2,
                          fontFamily: "BankGothic",
                          color: white,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox.fromSize(
                      size: Size(width * 0.9, 350),
                      child: Stack(
                        children: [
                          _vController != null &&
                                  _vController!.value.isInitialized
                              ? Chewie(controller: _chewController!)
                              : _vController!.value.isPlaying
                                  ? VideoPlayer(_vController!)
                                  : cacheImages(
                                      image: thumb,
                                      radius: 0,
                                      height: 350,
                                      width: width),
                          Positioned(
                              bottom: 5,
                              left: 0,
                              right: 0,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '${_vController!.value.duration.abs()}',
                                  style: TextStyle(color: white, fontSize: 25),
                                ),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            state(() {
                              if (_vController!.value.isPlaying) {
                                _vController!.pause();
                              } else {
                                _vController!.play();
                              }
                            });
                          },
                          child: DottedBorder(
                            // strokeWidth: 0.5,
                            // stackFit: StackFit.loose,
                            radius: Radius.circular(35),
                            borderType: BorderType.RRect,
                            dashPattern: [30, 3],
                            color: primary,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: secondary,
                                borderRadius: BorderRadius.circular(35),
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                _vController!.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                size: 35,
                                color: white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            navPush(
                                context: context,
                                action:
                                    VideoChRecording(challengeId: challengeId));
                          },
                          child: DottedBorder(
                            strokeWidth: 2,
                            // stackFit: StackFit.loose,
                            radius: Radius.circular(35),
                            borderType: BorderType.RRect,
                            dashPattern: [25, 5],
                            color: primary,
                            child: Container(
                              width: 250,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                color: secondary,
                                borderRadius: BorderRadius.circular(35),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Attempt',
                                style: TextStyle(color: white, fontSize: 25),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  Future<void> approveAlert({
    required BuildContext context,
  }) async {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return Consumer<ChallengeProvider>(builder: (context, data, child) {
              return (data == null)
                  ? SizedBox(
                      height: 0,
                    )
                  : Container(
                      height: 500,
                      width: width * 0.8,
                      margin: EdgeInsets.symmetric(horizontal: 20) +
                          EdgeInsets.only(top: 100, bottom: 100),
                      decoration: BoxDecoration(
                          color: Color(0xff323232),
                          borderRadius: BorderRadius.circular(8)),
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        body: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    navPop(context: context);
                                  },
                                  icon: Icon(
                                    Icons.clear,
                                    color: white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 25,
                                ),
                                Text(
                                  "Challenge",
                                  style: TextStyle(
                                      letterSpacing: 2,
                                      fontFamily: "BankGothic",
                                      color: white,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            SizedBox.fromSize(
                              size: Size(width * 0.9, 350),
                              child: Stack(
                                children: [
                                  _vController != null &&
                                          _vController!.value.isInitialized
                                      ? Chewie(controller: _chewController!)
                                      : _vController!.value.isPlaying
                                          ? VideoPlayer(_vController!)
                                          : cacheImages(
                                              image: data.thumb,
                                              radius: 0,
                                              height: 350,
                                              width: width),
                                  Positioned(
                                      bottom: 5,
                                      left: 0,
                                      right: 0,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          '${_vController!.value.duration.abs()}',
                                          style: TextStyle(
                                              color: white, fontSize: 25),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    state(() {
                                      if (_vController!.value.isPlaying) {
                                        _vController!.pause();
                                      } else {
                                        _vController!.play();
                                      }
                                    });
                                  },
                                  child: DottedBorder(
                                    // strokeWidth: 0.5,
                                    // stackFit: StackFit.loose,
                                    radius: Radius.circular(35),
                                    borderType: BorderType.RRect,
                                    dashPattern: [30, 3],
                                    color: primary,
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: secondary,
                                        borderRadius: BorderRadius.circular(35),
                                      ),
                                      alignment: Alignment.center,
                                      child: Icon(
                                        _vController!.value.isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        size: 35,
                                        color: white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DottedBorder(
                                  strokeWidth: 2,
                                  // stackFit: StackFit.loose,
                                  radius: Radius.circular(35),
                                  borderType: BorderType.RRect,
                                  dashPattern: [25, 5],
                                  color: primary,
                                  child: Container(
                                    width: width * 0.8,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: secondary,
                                      borderRadius: BorderRadius.circular(35),
                                    ),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Approve',
                                          style: TextStyle(
                                              color: white, fontSize: 24),
                                        ),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            decline(widget.userId, 'decline');
                                          },
                                          child: Text(
                                            'Declined',
                                            style: TextStyle(
                                                color: white, fontSize: 24),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
            });
          });
        });
  }

  Future<void> decline(
    String challengeId,
    String status,
  ) async {
    var pro = Provider.of<ChallengeProvider>(context, listen: false);
//var senderUserId = preferences!.getString(userIdKey).toString();
    var data = {
      'user_id': preferences!.getString(userIdKey).toString(),
      'challenge_id': challengeId,
      'status': 'decline',
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
