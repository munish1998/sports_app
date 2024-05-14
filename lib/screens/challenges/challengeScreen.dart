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
    _vController = VideoPlayerController.networkUrl(Uri.parse(video))
      ..initialize().then((value) async {
        await Future.wait([_vController!.initialize()]);
        _chewController = ChewieController(
          videoPlayerController: _vController!,
          autoPlay: false,
          showControls: false,
          looping: false,
        );
        setState(() {});
      });
    log('video response ====>>>>$video');
    log('_vcontroller response====>>>>$_vController');

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
        if (data.challengeList.isEmpty) {
          return Center(
            child: Text(
              'No challenge found',
              style: TextStyle(color: Colors.white),
            ),
          );
        } else {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: ListView.separated(
                itemCount: data.challengeList.length,
                itemBuilder: (context, index) {
                  return challengeItems(
                      data.challengeList[index], widget.userId);
                },
                separatorBuilder: (context, index) => SizedBox(
                      height: 10,
                    )),
          );
        }
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
                      ? 'assets/approved.png'
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
                  // Text(
                  //   (item.status == 'pending' &&
                  //           item.senderUserId == widget.userId)
                  //       ? 'Challenge send to ${item.reciverName}'
                  //       : '${item.senderName} send you challenge',
                  //   style: TextStyle(color: Colors.white),
                  // ),
                  Text(
                    (item.status == 'pending' &&
                            item.senderUserId == widget.userId)
                        ? 'Challenge send to ${item.reciverName}'
                        : (item.status == 'attempt')
                            ? 'Challenge attempted by ${item.reciverName}'
                            : (item.status == 'approve')
                                ? 'Challenge approved by ${item.senderName}'
                                : (item.status == 'pending')
                                    ? 'challenge send to ${item.senderName}'
                                    : (item.status == 'attempt' &&
                                            item.action == 'receiver')
                                        ? 'challenge attempt by ${item.senderName}'
                                        : (item.status == 'decline' &&
                                                item.action == 'sent')
                                            ? '${item.senderName} declined your challenge'
                                            : (item.status == 'decline' &&
                                                    item.action == 'receive')
                                                ? '${item.senderName}declned your challenge'
                                                : (item.status == 'cancel' &&
                                                        item.action == 'sent')
                                                    ? '${item.senderName} cancel your challenge'
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
                        item.senderUserId == widget.userId
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
                  // Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  //   (item.senderUserId != item.reciverUserId &&
                  //           item.status == 'pending')
                  //       ? attemptBTN(item.video!, item.id!, item.thumbnail!)
                  //       : Text(
                  //           'challenge send',
                  //           style: TextStyle(color: Colors.white),
                  //         )
                  // ]),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    (item.status == 'pending' && item.action == 'receive')
                        ? attemptBTN(item.video!, item.id!, item.thumbnail!)
                        : (item.status == 'attempt' && item.action == 'sent')
                            ? approvedBTN(item.id.toString())
                            : (item.status == 'decline' &&
                                    item.senderUserId != widget.userId)
                                ? reAttendBTN(
                                    item.video!, item.id!, item.thumbnail!)
                                : (item.status == 'approve' &&
                                        item.action == 'sent')
                                    ? Text(
                                        'approved',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : (item.status == 'attempt' &&
                                            item.action == 'receive')
                                        ? Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 15),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                gradient: approved,
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Text(
                                              'Attempted',
                                              style: TextStyle(color: white),
                                            ),
                                          )
                                        : (item.status == 'pending' &&
                                                item.action == 'sent')
                                            ? Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal: 15),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    gradient: approved,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: Text(
                                                  'challenged',
                                                  style:
                                                      TextStyle(color: white),
                                                ),
                                              )
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
            InkWell(
              onTap: () {
                Oncancel(challengeId, 'cancel');
                log('challengeID response ===>>>>$challengeId');
              },
              child: Container(
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

  Widget approvedBTN(String challengeId) => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                log("challengeId:-> ${challengeId.toString()}");
                log('_videocontroller response====>>>>$_vController');
                log('_chewcontroller response====>>>>>$_chewController');
                approveAlert(context: context, challengeId: challengeId);
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
                    decline(challengeId,
                        'decline'); // Call decline function with challengeId
                  }
                });
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
            InkWell(
              onTap: () {
                Oncancel(challengeId, 'cancel');
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    gradient: declined, borderRadius: BorderRadius.circular(8)),
                child: Text(
                  'Declined',
                  style: TextStyle(color: white),
                ),
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
                            log("challengeId:-> ${challengeId.toString()}");
                            log('_videocontroller response====>>>>$_vController');
                            log('_chewcontroller response====>>>>>$_chewController');
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
                                //  color: secondary,
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

  Future<void> approveAlert(
      {required BuildContext context, required String challengeId}) async {
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
                                        InkWell(
                                          onTap: () {
                                            approve(challengeId, 'approve');
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChallengeScreen()));
                                          },
                                          child: Text(
                                            'Approve',
                                            style: TextStyle(
                                                color: white, fontSize: 24),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            decline(challengeId, 'decline');
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChallengeScreen()));
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
    log('challenges decline update data response=====>>>>>>>>>$data');
    log('response of challenge id=====>>>>>$challengeId');

    try {
      await pro.updateChallengeStatus(
        context: context,
        data: data,
      );
      //pro.removeChallenge(challengeId);
      customToast(context: context, msg: 'Challenge decline updated', type: 1);
      Navigator.pop(context);
    } catch (error) {
      log('Error while updating challenge status: $error');

      customToast(
          context: context, msg: 'Failed to update challenge status', type: 0);
    }
  }

  Future<void> Oncancel(
    String challengeId,
    String status,
  ) async {
    var pro = Provider.of<ChallengeProvider>(context, listen: false);
//var senderUserId = preferences!.getString(userIdKey).toString();
    var data = {
      'user_id': preferences!.getString(userIdKey).toString(),
      'challenge_id': challengeId,
      'status': 'cancel',
    };
    //log('print sender user id =======>>>>>>>>$');
    log('challenges decline update data response=====>>>>>>>>>$data');
    log('response of challenge id=====>>>>>$challengeId');

    try {
      await pro.updateChallengeStatus(
        context: context,
        data: data,
      );
      pro.removeChallenge(challengeId);
      customToast(context: context, msg: 'Challenge decline updated', type: 1);
      Navigator.pop(context);
    } catch (error) {
      log('Error while updating challenge status: $error');

      customToast(
          context: context, msg: 'Failed to update challenge status', type: 0);
    }
  }

  Future<void> approve(
    String challengeId,
    String status,
  ) async {
    var pro = Provider.of<ChallengeProvider>(context, listen: false);
//var senderUserId = preferences!.getString(userIdKey).toString();
    var data = {
      'user_id': preferences!.getString(userIdKey).toString(),
      'challenge_id': challengeId,
      'status': 'approve',
    };
    log('challenge id response=====>>>>>$challengeId');
    log('status response====>>>>$status');
    log('userId response====>>>>$userIdKey');
    //log('print sender user id =======>>>>>>>>$');
    log('challenges update data response=====>>>>>>>>>$data');

    try {
      await pro.updateChallengeStatus(
        context: context,
        data: data,
      );
      customToast(context: context, msg: 'Challenge status updated', type: 1);
      Navigator.pop(context);
    } catch (error) {
      log('Error while updating challenge status: $error');

      customToast(
          context: context, msg: 'Failed to update challenge status', type: 0);
    }
  }
}

// import 'dart:developer';
// import 'package:chewie/chewie.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:touchmaster/main.dart';
// import 'package:touchmaster/utils/customLoader.dart';
// import 'package:video_player/video_player.dart';

// import '../../model/challengeModel.dart';
// import '../../utils/color.dart';
// import '../../utils/constant.dart';
// import '/app_image.dart';
// import '/common/cacheImage.dart';
// import '/providers/challengesProvider.dart';
// import '/utils/commonMethod.dart';
// import 'videoChRecordingScreen.dart';

// class ChallengeScreen extends StatefulWidget {
//   String userId = preferences!.getString(userIdKey) ?? '';
//   ChallengeScreen({super.key});

//   @override
//   State<ChallengeScreen> createState() => _ChallengeScreenState();
// }

// class _ChallengeScreenState extends State<ChallengeScreen> {
//   double height = 0;
//   double width = 0;
//   SharedPreferences? pref;
//   VideoPlayerController? _vController;
//   ChewieController? _chewController;
//   ValueNotifier<VideoPlayerValue?> currentPosition = ValueNotifier(null);

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _vController?.addListener(() {
//       if (_vController!.value.isInitialized) {
//         currentPosition.value = _vController!.value;
//       }
//     });
//     // initializePlayer();
//     initFun();
//     log('Current User ID: $userIdKey');
//   }

//   initFun() async {
//     var pro = Provider.of<ChallengeProvider>(context, listen: false);

//     pref = await SharedPreferences.getInstance();
//     String userId = pref!.getString(userIdKey) ?? '';
//     var data = {'user_id': userId};
//     pro.getChallenges(context: context, data: data);
//     log('userId ====>>>$userId');
//     log('userIdkey====>>>$userIdKey');
//   }

//   Future<bool> initializePlayer(String video) async {
//     showLoaderDialog(context, 'Loading...');
//     _vController = VideoPlayerController.networkUrl(Uri.parse(video))
//       ..initialize().then((value) {
//         _chewController = ChewieController(
//           videoPlayerController: _vController!,
//           autoPlay: false,
//           showControls: false,
//           looping: false,
//         );
//         setState(() {});
//       });
//     log('video response ====>>>>$video');
//     log('_vcontroller response====>>>>$_vController');

//     navPop(context: context);
//     return _vController!.value.isInitialized;
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     _vController!.dispose();
//     _chewController!.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     height = MediaQuery.sizeOf(context).height;
//     width = MediaQuery.sizeOf(context).width;
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: appBar,
//       body: body,
//     );
//   }

//   AppBar get appBar => AppBar(
//         backgroundColor: Colors.black,
//         leading: InkWell(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: Icon(
//             Icons.arrow_back_ios_new,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         title: Text(
//           'Challenges',
//           style: TextStyle(
//               letterSpacing: 2,
//               fontFamily: "BankGothic",
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold),
//         ),
//       );

//   Widget get body =>
//       Consumer<ChallengeProvider>(builder: (context, data, child) {
//         if (data.challengeList.isEmpty) {
//           return Center(
//             child: Text(
//               'No challenge found',
//               style: TextStyle(color: Colors.white),
//             ),
//           );
//         } else {
//           return Container(
//             padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//             child: ListView.separated(
//                 itemCount: data.challengeList.length,
//                 itemBuilder: (context, index) {
//                   return challengeItems(
//                       data.challengeList[index], widget.userId);
//                 },
//                 separatorBuilder: (context, index) => SizedBox(
//                       height: 10,
//                     )),
//           );
//         }
//       });

//   Widget challengeItems(ChallengeModel item, String currentUserId) => Container(
//         decoration: BoxDecoration(color: grey.withOpacity(0.3)),
//         padding: EdgeInsets.all(5),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             AppImage(
//               (item.status == 'pending')
//                   ? 'assets/target.png'
//                   : (item.status == 'approve')
//                       ? 'assets/approved.png'
//                       : 'assets/declined.png',
//               height: 75,
//               width: 75,
//             ),
//             SizedBox(
//               width: 10,
//             ),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text(
//                     (item.status == 'pending' &&
//                             item.senderUserId == widget.userId)
//                         ? 'Challenge send to ${item.reciverName}'
//                         : (item.status == 'attempt')
//                             ? 'Challenge attempted by ${item.reciverName}'
//                             : (item.status == 'approve')
//                                 ? 'Challenge approved by ${item.senderName}'
//                                 : (item.status == 'pending')
//                                     ? 'challenge send to ${item.senderName}'
//                                     : (item.status == 'attempt' &&
//                                             item.action == 'receiver')
//                                         ? 'challenge attempt by ${item.senderName}'
//                                         : (item.status == 'decline' &&
//                                                 item.action == 'sent')
//                                             ? '${item.senderName} declined your challenge'
//                                             : (item.status == 'decline' &&
//                                                     item.action == 'receive')
//                                                 ? '${item.senderName}declned your challenge'
//                                                 : '',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text(
//                         item.senderUserId == widget.userId
//                             ? item.status!
//                             : item.datetime!,
//                         style: TextStyle(color: white),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       Text(
//                         item.senderUserId == currentUserId ? item.action! : '',
//                         style: TextStyle(color: white),
//                       ),
//                     ],
//                   ),
//                   Row(mainAxisAlignment: MainAxisAlignment.end, children: [
//                     (item.status == 'pending' && item.action == 'receive')
//                         ? attemptBTN(item.video!, item.id!, item.thumbnail!)
//                         : (item.status == 'attempt' && item.action == 'sent')
//                             ? approvedBTN(item.id.toString())
//                             : (item.status == 'decline' &&
//                                     item.senderUserId != widget.userId)
//                                 ? reAttendBTN(
//                                     item.video!, item.id!, item.thumbnail!)
//                                 : (item.status == 'approve' &&
//                                         item.action == 'sent')
//                                     ? Text(
//                                         'approved',
//                                         style: TextStyle(color: Colors.white),
//                                       )
//                                     : (item.status == 'attempt' &&
//                                             item.action == 'receive')
//                                         ? Container(
//                                             padding: EdgeInsets.symmetric(
//                                                 vertical: 5, horizontal: 15),
//                                             alignment: Alignment.center,
//                                             decoration: BoxDecoration(
//                                                 gradient: approved,
//                                                 borderRadius:
//                                                     BorderRadius.circular(8)),
//                                             child: Text(
//                                               'Attempted',
//                                               style: TextStyle(color: white),
//                                             ),
//                                           )
//                                         : (item.status == 'pending' &&
//                                                 item.action == 'sent')
//                                             ? Container(
//                                                 padding: EdgeInsets.symmetric(
//                                                     vertical: 5,
//                                                     horizontal: 15),
//                                                 alignment: Alignment.center,
//                                                 decoration: BoxDecoration(
//                                                     gradient: approved,
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             8)),
//                                                 child: Text(
//                                                   'challenged',
//                                                   style:
//                                                       TextStyle(color: white),
//                                                 ),
//                                               )
//                                             : SizedBox(
//                                                 height: 0,
//                                                 width: 0,
//                                               )
//                   ]),
//                 ],
//               ),
//             )
//           ],
//         ),
//       );

//   Widget attemptBTN(String video, String challengeId, String thumb) =>
//       Container(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                   gradient: cancel, borderRadius: BorderRadius.circular(8)),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     Icons.cancel_presentation,
//                     color: white,
//                     size: 18,
//                   ),
//                   SizedBox(
//                     width: 3,
//                   ),
//                   Text(
//                     'Cancel',
//                     style: TextStyle(color: white, fontSize: 12),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               width: 10,
//             ),
//             InkWell(
//               onTap: () {
//                 initializePlayer(video).then((value) {
//                   attemptAlert(
//                       context: context, challengeId: challengeId, thumb: thumb);

//                   log('response of pending challenge ====>>>>$video');
//                   log('response of pending challenge ====>>>>$thumb');
//                 });
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                     gradient: attempt, borderRadius: BorderRadius.circular(8)),
//                 child: Text(
//                   'attempt',
//                   style: TextStyle(color: white),
//                 ),
//               ),
//             )
//           ],
//         ),
//       );

//   Widget approvedBTN(String challengeId) => Container(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             InkWell(
//               onTap: () {
//                 log("challengeId:-> ${challengeId.toString()}");
//                 log('video_id=====>>>>>>$_vController');
//                 log('chewcontroller====>>>>$_chewController');
//                 approveAlert(context: context, challengeId: challengeId);
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                     gradient: approved, borderRadius: BorderRadius.circular(8)),
//                 child: Text(
//                   'Approved',
//                   style: TextStyle(color: white),
//                 ),
//               ),
//             )
//           ],
//         ),
//       );

//   Widget reAttendBTN(String video, String challengeId, String thumb) =>
//       Container(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             InkWell(
//               onTap: () {
//                 initializePlayer(video).then((value) {
//                   if (value) {
//                     attemptAlert(
//                         context: context,
//                         challengeId: challengeId,
//                         thumb: thumb);
//                   }
//                 });
//                 log('response of reattempt challenge====>>>>>$thumb');
//                 log('response of chllengeId===>>$challengeId');
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                     gradient: attempt, borderRadius: BorderRadius.circular(8)),
//                 child: Text(
//                   'ReAttempt',
//                   style: TextStyle(color: white, fontSize: 12),
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: 10,
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                   gradient: declined, borderRadius: BorderRadius.circular(8)),
//               child: Text(
//                 'Declined',
//                 style: TextStyle(color: white),
//               ),
//             )
//           ],
//         ),
//       );

//   Future<void> attemptAlert({
//     required BuildContext context,
//     required String challengeId,
//     required String thumb,
//   }) async {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return StatefulBuilder(builder: (context, state) {
//             return Container(
//               height: 500,
//               width: width * 0.8,
//               margin: EdgeInsets.symmetric(horizontal: 20) +
//                   EdgeInsets.only(top: 100, bottom: 100),
//               decoration: BoxDecoration(
//                   color: Color(0xff323232),
//                   borderRadius: BorderRadius.circular(8)),
//               child: Scaffold(
//                 backgroundColor: Colors.transparent,
//                 body: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         IconButton(
//                           onPressed: () {
//                             navPop(context: context);
//                             _vController!.pause();
//                           },
//                           icon: Icon(
//                             Icons.clear,
//                             color: white,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 8,
//                     ),
//                     Text(
//                       "Beat him to earn more rewards",
//                       style: TextStyle(
//                           letterSpacing: 2,
//                           fontFamily: "BankGothic",
//                           color: white,
//                           fontWeight: FontWeight.w400),
//                     ),
//                     SizedBox(
//                       height: 8,
//                     ),
//                     SizedBox.fromSize(
//                       size: Size(width * 0.9, 350),
//                       child: Stack(
//                         children: [
//                           _vController != null &&
//                                   _vController!.value.isInitialized
//                               ? Chewie(controller: _chewController!)
//                               : _vController!.value.isPlaying
//                                   ? VideoPlayer(_vController!)
//                                   : cacheImages(
//                                       image: thumb,
//                                       radius: 0,
//                                       height: 350,
//                                       width: width),
//                           Positioned(
//                               bottom: 5,
//                               left: 0,
//                               right: 0,
//                               child: Align(
//                                 alignment: Alignment.center,
//                                 child: Text(
//                                   '${_vController!.value.duration.abs()}',
//                                   style: TextStyle(color: white, fontSize: 25),
//                                 ),
//                               )),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             state(() {
//                               if (_vController!.value.isPlaying) {
//                                 _vController!.pause();
//                               } else {
//                                 _vController!.play();
//                               }
//                             });
//                           },
//                           child: DottedBorder(
//                             // strokeWidth: 0.5,
//                             // stackFit: StackFit.loose,
//                             radius: Radius.circular(35),
//                             borderType: BorderType.RRect,
//                             dashPattern: [30, 3],
//                             color: primary,
//                             child: Container(
//                               padding: EdgeInsets.all(10),
//                               decoration: BoxDecoration(
//                                 color: secondary,
//                                 borderRadius: BorderRadius.circular(35),
//                               ),
//                               alignment: Alignment.center,
//                               child: Icon(
//                                 _vController!.value.isPlaying
//                                     ? Icons.pause
//                                     : Icons.play_arrow,
//                                 size: 35,
//                                 color: white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             navPush(
//                                 context: context,
//                                 action:
//                                     VideoChRecording(challengeId: challengeId));
//                           },
//                           child: DottedBorder(
//                             strokeWidth: 2,
//                             // stackFit: StackFit.loose,
//                             radius: Radius.circular(35),
//                             borderType: BorderType.RRect,
//                             dashPattern: [25, 5],
//                             color: primary,
//                             child: Container(
//                               width: 250,
//                               padding: EdgeInsets.symmetric(vertical: 5),
//                               decoration: BoxDecoration(
//                                 //  color: secondary,
//                                 borderRadius: BorderRadius.circular(35),
//                               ),
//                               alignment: Alignment.center,
//                               child: Text(
//                                 'Attempt',
//                                 style: TextStyle(color: white, fontSize: 25),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             );
//           });
//         });
//   }

//   Future<void> approveAlert(
//       {required BuildContext context, required String challengeId}) async {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return StatefulBuilder(builder: (context, state) {
//             return Consumer<ChallengeProvider>(builder: (context, data, child) {
//               return (data == null)
//                   ? SizedBox(
//                       height: 0,
//                     )
//                   : Container(
//                       height: 500,
//                       width: width * 0.8,
//                       margin: EdgeInsets.symmetric(horizontal: 20) +
//                           EdgeInsets.only(top: 100, bottom: 100),
//                       decoration: BoxDecoration(
//                           color: Color(0xff323232),
//                           borderRadius: BorderRadius.circular(8)),
//                       child: Scaffold(
//                         backgroundColor: Colors.transparent,
//                         body: Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 IconButton(
//                                   onPressed: () {
//                                     navPop(context: context);
//                                   },
//                                   icon: Icon(
//                                     Icons.clear,
//                                     color: white,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: 8,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 SizedBox(
//                                   width: 25,
//                                 ),
//                                 Text(
//                                   "Challenge",
//                                   style: TextStyle(
//                                       letterSpacing: 2,
//                                       fontFamily: "BankGothic",
//                                       color: white,
//                                       fontWeight: FontWeight.w400),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: 16,
//                             ),
//                             SizedBox.fromSize(
//                               size: Size(width * 0.9, 350),
//                               child: Stack(
//                                 children: [
//                                   _vController != null &&
//                                           _vController!.value.isInitialized
//                                       ? Chewie(controller: _chewController!)
//                                       : _vController!.value.isPlaying
//                                           ? VideoPlayer(_vController!)
//                                           : cacheImages(
//                                               image: data.thumb,
//                                               radius: 0,
//                                               height: 350,
//                                               width: width),
//                                   Positioned(
//                                       bottom: 5,
//                                       left: 0,
//                                       right: 0,
//                                       child: Align(
//                                         alignment: Alignment.center,
//                                         child: Text(
//                                           '${_vController!.value.duration.abs()}',
//                                           style: TextStyle(
//                                               color: white, fontSize: 25),
//                                         ),
//                                       )),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               height: 15,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 InkWell(
//                                   onTap: () {
//                                     state(() {
//                                       if (_vController!.value.isPlaying) {
//                                         _vController!.pause();
//                                       } else {
//                                         _vController!.play();
//                                       }
//                                     });
//                                   },
//                                   child: DottedBorder(
//                                     // strokeWidth: 0.5,
//                                     // stackFit: StackFit.loose,
//                                     radius: Radius.circular(35),
//                                     borderType: BorderType.RRect,
//                                     dashPattern: [30, 3],
//                                     color: primary,
//                                     child: Container(
//                                       padding: EdgeInsets.all(10),
//                                       decoration: BoxDecoration(
//                                         color: secondary,
//                                         borderRadius: BorderRadius.circular(35),
//                                       ),
//                                       alignment: Alignment.center,
//                                       child: Icon(
//                                         _vController!.value.isPlaying
//                                             ? Icons.pause
//                                             : Icons.play_arrow,
//                                         size: 35,
//                                         color: white,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: 15,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 DottedBorder(
//                                   strokeWidth: 2,
//                                   // stackFit: StackFit.loose,
//                                   radius: Radius.circular(35),
//                                   borderType: BorderType.RRect,
//                                   dashPattern: [25, 5],
//                                   color: primary,
//                                   child: Container(
//                                     width: width * 0.8,
//                                     padding: EdgeInsets.symmetric(
//                                         vertical: 5, horizontal: 10),
//                                     decoration: BoxDecoration(
//                                       color: secondary,
//                                       borderRadius: BorderRadius.circular(35),
//                                     ),
//                                     alignment: Alignment.center,
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         InkWell(
//                                           onTap: () {
//                                             approve(challengeId, 'approve');
//                                             Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         ChallengeScreen()));
//                                           },
//                                           child: Text(
//                                             'Approve',
//                                             style: TextStyle(
//                                                 color: white, fontSize: 24),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: 50,
//                                         ),
//                                         InkWell(
//                                           onTap: () {
//                                             decline(challengeId, 'decline');
//                                             Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         ChallengeScreen()));
//                                           },
//                                           child: Text(
//                                             'Declined',
//                                             style: TextStyle(
//                                                 color: white, fontSize: 24),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//             });
//           });
//         });
//   }

//   Future<void> decline(
//     String challengeId,
//     String status,
//   ) async {
//     var pro = Provider.of<ChallengeProvider>(context, listen: false);
// //var senderUserId = preferences!.getString(userIdKey).toString();
//     var data = {
//       'user_id': preferences!.getString(userIdKey).toString(),
//       'challenge_id': challengeId,
//       'status': 'decline',
//     };
//     //log('print sender user id =======>>>>>>>>$');
//     log('challenges decline update data response=====>>>>>>>>>$data');
//     log('response of challenge id=====>>>>>$challengeId');

//     try {
//       await pro.updateChallengeStatus(
//         context: context,
//         data: data,
//       );
//       customToast(context: context, msg: 'Challenge decline updated', type: 1);
//       Navigator.pop(context);
//     } catch (error) {
//       log('Error while updating challenge status: $error');

//       customToast(
//           context: context, msg: 'Failed to update challenge status', type: 0);
//     }
//   }

//   Future<void> approve(
//     String challengeId,
//     String status,
//   ) async {
//     var pro = Provider.of<ChallengeProvider>(context, listen: false);
// //var senderUserId = preferences!.getString(userIdKey).toString();
//     var data = {
//       'user_id': preferences!.getString(userIdKey).toString(),
//       'challenge_id': challengeId,
//       'status': 'approve',
//     };
//     log('challenge id response=====>>>>>$challengeId');
//     log('status response====>>>>$status');
//     log('userId response====>>>>$userIdKey');
//     //log('print sender user id =======>>>>>>>>$');
//     log('challenges update data response=====>>>>>>>>>$data');

//     try {
//       await pro.updateChallengeStatus(
//         context: context,
//         data: data,
//       );
//       customToast(context: context, msg: 'Challenge status updated', type: 1);
//       Navigator.pop(context);
//     } catch (error) {
//       log('Error while updating challenge status: $error');

//       customToast(
//           context: context, msg: 'Failed to update challenge status', type: 0);
//     }
//   }
// }
