import 'dart:developer';
import 'package:chewie/chewie.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  const ChallengeScreen({super.key});

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
    //initializePlayer();
    initFun();
  }

  initFun() async {
    var pro = Provider.of<ChallengeProvider>(context, listen: false);

    pref = await SharedPreferences.getInstance();
    var data = {
      'user_id': pref!.getString(userIdKey) ?? '',
    };
    pro.getChallenges(context: context, data: data);
  }

  Future<bool> initializePlayer1(String video) async {
    try {
      showLoaderDialog(context, 'Loading...');
      _vController = VideoPlayerController.networkUrl(Uri.parse(video));
      await Future.wait([_vController!.initialize()]);
      _chewController = ChewieController(
        videoPlayerController: _vController!,
        autoPlay: false,
        showControls: false,
        looping: false,
      );
      return _vController!.value.isInitialized;
    } catch (e) {
      log('response of _chewcontroller======>>>>>$_chewController');
      log('response of _vcontroller=====>>>>>$_vController');
      log('video reponse====>>>>>$video');
      log('initialization error occur======>>>>>>>$e');
    }
    // log('initialization occur======>>>>>$_vController');
    // log('initialization occur occur ======>>>>>>$_chewController');
    // log('intialization video response=====>>>>>$video');

    setState(() {});
    navPop(context: context);
    return _vController!.value.isInitialized;
  }

  Future<bool> initializePlayer(String video) async {
    showLoaderDialog(context, 'Loading...');
    _vController = VideoPlayerController.networkUrl(Uri.parse(video));
    await Future.wait([_vController!.initialize()]);
    _chewController = ChewieController(
      videoPlayerController: _vController!,
      autoPlay: false,
      showControls: false,
      looping: false,
    );
    log('initialization video response=====>>>>>$_vController');
    setState(() {});
    navPop(context: context);
    return _vController!.value.isInitialized;
  }

  Future<bool> initializePlayer2(String video) async {
    try {
      showLoaderDialog(context, 'Loading...');
      _vController = VideoPlayerController.networkUrl(Uri.parse(video));
      await Future.wait([_vController!.initialize()]);
      _chewController = ChewieController(
        videoPlayerController: _vController!,
        autoPlay: false,
        showControls: false,
        looping: false,
      );
      // log('error occur of initialization======>>>>>>>$_vController');
      // log('video initialization successfull========>>>>>>>>>$_chewController');
      return _vController!.value.isInitialized;
    } catch (e) {
      // log('error initialize player=======>>>>>>>>>>>>:$e');
      // log('video url of initialization====>>>>>>$video');
      // log('_vcontroller response=====>>>>>>>$_vController');
      return false;
    }
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
                return challengeItems(data.challengeList[index], () {
                  // Remove the challenge from the list
                  setState(() {
                    data.challengeList.removeAt(index);
                  });
                });
              },
              separatorBuilder: (context, index) => SizedBox(
                    height: 10,
                  )),
        );
      });

  Widget challengeItems(ChallengeModel item, VoidCallback removeChallenge) =>
      Container(
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
                  Row(
                    children: [
                      Text(
                        'challenge send by',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        item.senderName!,
                        style: TextStyle(color: white),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        item.datetime!,
                        style: TextStyle(color: white),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        item.action!,
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      (item.status == 'pending')
                          ? attemptBTN(
                              item.video!,
                              item.id!,
                              item.thumbnail!,
                            )
                          : (item.status == 'attempt')
                              ? approvedBTN()
                              : (item.status == 'decline')
                                  ? reAttendBTN(
                                      item.video!, item.id!, item.thumbnail!)
                                  : SizedBox(
                                      height: 0,
                                      width: 0,
                                    ),
                    ],
                  ),
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
                  if (value) {
                    attemptAlert(
                        context: context,
                        challengeId: challengeId,
                        thumb: thumb);
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    gradient: attempt, borderRadius: BorderRadius.circular(8)),
                child: Text(
                  'Attempt',
                  style: TextStyle(color: white),
                ),
              ),
            )
          ],
        ),
      );

  // Widget attemptBTN(String video, String challengeId, String thumb,
  //         VoidCallback removeChallenge) =>
  //     Container(
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Container(
  //             padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
  //             alignment: Alignment.center,
  //             decoration: BoxDecoration(
  //                 gradient: cancel, borderRadius: BorderRadius.circular(8)),
  //             child: Row(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 InkWell(
  //                   onTap: () {
  //                     // Call the callback to remove the challenge
  //                     removeChallenge();
  //                   },
  //                   child: Icon(
  //                     Icons.cancel_presentation,
  //                     color: white,
  //                     size: 18,
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   width: 3,
  //                 ),
  //                 Text(
  //                   'Cancel',
  //                   style: TextStyle(color: white, fontSize: 12),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           SizedBox(
  //             width: 10,
  //           ),
  //           InkWell(
  //             onTap: () {
  //               initializePlayer(video).then((value) {
  //                 if (value) {
  //                   attemptAlert(
  //                       context: context,
  //                       challengeId: challengeId,
  //                       thumb: thumb);
  //                 }
  //               });
  //             },
  //             child: Container(
  //               padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
  //               alignment: Alignment.center,
  //               decoration: BoxDecoration(
  //                   gradient: attempt, borderRadius: BorderRadius.circular(8)),
  //               child: Text(
  //                 'Attempt',
  //                 style: TextStyle(color: white),
  //               ),
  //             ),
  //           )
  //         ],
  //       ),
  //     );

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

  Widget reAttendBTN(
    String video,
    String challengeId,
    String thumb,
  ) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              initializePlayer(video).then((value) {
                if (value) {
                  attemptAlert(
                      context: context, challengeId: challengeId, thumb: thumb);
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
              // ondecline();
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
                                    style:
                                        TextStyle(color: white, fontSize: 25),
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
                                    style:
                                        TextStyle(color: white, fontSize: 24),
                                  ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Text(
                                    'Declined',
                                    style:
                                        TextStyle(color: white, fontSize: 24),
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
}
