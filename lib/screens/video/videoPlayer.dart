import 'dart:developer';

import 'package:card_swiper/card_swiper.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchmaster/common/cacheImage.dart';
import 'package:touchmaster/providers/videoProvider.dart';
import 'package:touchmaster/utils/constant.dart';
import 'package:touchmaster/utils/customLoader.dart';
import 'package:video_player/video_player.dart';

import '../../model/profileVideoModel.dart';
import '/utils/color.dart';
import '/utils/commonMethod.dart';

class VideoPlayerScreen extends StatefulWidget {
  final List<ProfileVideoModel> exercise;
  final int index;

  const VideoPlayerScreen(
      {super.key, required this.exercise, required this.index});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  SwiperController controller = SwiperController();
  int videoIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initFun();
  }

  _initFun() async {
    setState(() {
      videoIndex = widget.index;
    });
    // for (int i = 0; i < widget.exercise.length; i++) {
    //   initializePlayer(i);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              //We need swiper for every content
              Swiper(
                loop: false,
                itemBuilder: (BuildContext context, int index) {
                  return VideoContentScreen(
                    item: widget.exercise[videoIndex],
                    swipeController: controller,
                  );
                },
                onIndexChanged: (index) {
                  videoIndex = index;

                  log('CheckListIndex---------$videoIndex->   ${widget.index}>>   $index');
                },
                itemCount: widget.exercise.length,
                scrollDirection: Axis.vertical,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: white.withOpacity(0.05)),
                      child: IconButton(
                          onPressed: () {
                            navPop(context: context);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: white,
                          )),
                    ),
                    // Icon(Icons.camera_alt),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoContentScreen extends StatefulWidget {
  final ProfileVideoModel item;
  final SwiperController swipeController;

  const VideoContentScreen(
      {Key? key, required this.item, required this.swipeController})
      : super(key: key);

  @override
  State<VideoContentScreen> createState() => _VideoContentScreenState();
}

class _VideoContentScreenState extends State<VideoContentScreen> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewController;
  bool _liked = false;

  @override
  void initState() {
    super.initState();
    // initializePlayer1();
    initializePlayer();
  }

  Future initializePlayer() async {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.item.video));
    await Future.wait([_videoPlayerController!.initialize()]);
    _chewController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      showControls: false,
      looping: true,
    );
    setState(() {});
    _videoPlayerController!.addListener(() {
      if (_videoPlayerController!.value.position ==
          _videoPlayerController!.value.duration) {
        widget.swipeController.next();
      }
    });
  }

  void initializePlayer1() async {
    final fileInfo = await checkCacheFor(widget.item.video);
    if (fileInfo == null) {
      _videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(widget.item.video));
      _videoPlayerController!.initialize().then((value) {
        cachedForUrl(widget.item.video);
        setState(() {
          _videoPlayerController!.play();
        });
      });
    } else {
      final file = fileInfo.file;
      _videoPlayerController = VideoPlayerController.file(file);
      _videoPlayerController!.initialize().then((value) {
        setState(() {
          _videoPlayerController!.play();
        });
      });
    }
  }

//: check for cache
  Future<FileInfo?> checkCacheFor(String url) async {
    final FileInfo? value = await DefaultCacheManager().getFileFromCache(url);
    log('DataFound==============>>${widget.item.video}   ${value!.file.path}');

    return value;
  }

//:cached Url Data
  void cachedForUrl(String url) async {
    await DefaultCacheManager().getSingleFile(url).then((value) {
      print('downloaded successfully done for $url');
    });
  }

  @override
  void dispose() {
    _videoPlayerController!.dispose();
    _chewController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _chewController != null &&
                _chewController!.videoPlayerController.value.isInitialized
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _liked = true;
                  });

                  log('DoubleTapped');
                },
                child: AspectRatio(
                    aspectRatio: _chewController!
                        .videoPlayerController.value.aspectRatio,
                    child: Chewie(
                      controller: _chewController!,
                    )),
              )
            : Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(widget.item.thumbnail),
                        fit: BoxFit.fill))),
        if (_liked)
          Center(
            child: LikeIcon(),
          ),
        OptionsScreen(
            item: widget.item,
            progress: VideoProgressIndicator(
              _videoPlayerController!,
              allowScrubbing: false,
              colors: const VideoProgressColors(
                backgroundColor: Colors.blueGrey,
                bufferedColor: Colors.blueGrey,
                playedColor: primary,
              ),
            ))
      ],
    );
  }
}

class LikeIcon extends StatelessWidget {
  Future<int> tempFuture() async {
    return Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: tempFuture(),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.done
                ? Icon(
                    Icons.favorite,
                    size: 110,
                    color: red,
                  )
                : SizedBox(),
      ),
    );
  }
}

class OptionsScreen extends StatefulWidget {
  final ProfileVideoModel item;
  final Widget progress;

  const OptionsScreen({super.key, required this.item, required this.progress});

  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  double height = 0;
  double width = 0;
  SharedPreferences? pref;

  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initFun();
  }

  _initFun() async {
    pref = await SharedPreferences.getInstance();
    getComment();
  }

  getComment() async {
    var pro = Provider.of<VideoProvider>(context, listen: false);
    var data = {
      'user_id': pref!.getString(userIdKey).toString() ?? '',
      'video_id': widget.item.videoId,
    };
    pro.getComment(context: context, data: data);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.sizeOf(context).height;
    width = MediaQuery.sizeOf(context).width;
    return Container(
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(color: Colors.black12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    SizedBox(width: 6),
                    Text(
                      widget.item.uName,
                      style: TextStyle(color: white),
                    ),
                    SizedBox(width: 10),
                    (widget.item.uType == 'influencer')
                        ? Icon(
                            Icons.verified,
                            size: 15,
                            color: primary,
                          )
                        : SizedBox(
                            height: 0,
                            width: 0,
                          ),
                    SizedBox(width: 6),
                    // TextButton(
                    //   onPressed: () {},
                    //   child: Text(
                    //     'Follow',
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              cacheImage(
                  image: widget.item.uProfile,
                  radius: 100,
                  height: 45,
                  width: 45),
            ],
          ),
          SizedBox(width: 6),
          Text(
            '${widget.item.title} \n${widget.item.description}',
            style: TextStyle(color: white),
          ),
          Container(
            child: widget.progress,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        widget.item.isLiked = true;
                      });
                      onLike(widget.item.isLiked);
                    },
                    child: Icon(
                      (widget.item.isLiked)
                          ? Icons.favorite
                          : Icons.favorite_outline,
                      color: (widget.item.isLiked) ? red : white,
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      showCommentSheet(context: context);
                    },
                    child: Icon(
                      Icons.comment_rounded,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    // onTap: onShare,
                    child: Transform(
                      transform: Matrix4.rotationZ(5.8),
                      child: Icon(
                        Icons.send,
                        color: white,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: onSave,
                    child: Icon(
                      Icons.save_alt_sharp,
                      color: white,
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${widget.item.totalLikes} Likes',
                    style: TextStyle(color: white),
                  ),
                  Text(
                    '${widget.item.totalComments} Comments',
                    style: TextStyle(color: white),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> showCommentSheet({
    required BuildContext context,
  }) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return Consumer<VideoProvider>(builder: (context, data, child) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  height: 500,
                  width: width,
                  decoration: BoxDecoration(
                      color: Color(0xff323232),
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
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
                      Container(
                        padding: EdgeInsets.all(15),
                        height: 350,
                        child: ListView.separated(
                          itemCount: data.comments.length,
                          itemBuilder: (context, index) {
                            var item = data.comments[index];
                            return Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: grey,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    capitalize(item.comment),
                                    style: TextStyle(color: white),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(item.dateTime,
                                          style: TextStyle(
                                              color: white, fontSize: 10)),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => SizedBox(
                            height: 8,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: TextField(
                          controller: textController,
                          textCapitalization: TextCapitalization.sentences,
                          style: TextStyle(color: Colors.white54),
                          decoration: InputDecoration(
                            hintText: 'Type your comment',
                            hintStyle: TextStyle(color: Colors.white54),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 8),
                            enabledBorder: border,
                            border: border,
                            focusedBorder: border,
                            suffixIcon: IconButton(
                                onPressed: onSend,
                                icon: Icon(
                                  Icons.send,
                                  color: white,
                                  size: 30,
                                )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              );
            });
          });
        });
  }

  Future<void> onSend() async {
    var pro = Provider.of<VideoProvider>(context, listen: false);
    var data = {};
    if (textController.text.isNotEmpty) {
      data = {
        'user_id': pref!.getString(userIdKey).toString() ?? '',
        'video_id': widget.item.videoId,
        'comment': textController.text,
      };
      log('CommentData-------------->>  $data');
      pro.addComment(context: context, data: data).then((value) {
        setState(() {
          textController.clear();
        });
      });
    }
  }

  Future<void> onLike(bool like) async {
    var pro = Provider.of<VideoProvider>(context, listen: false);
    var data = {
      'user_id': pref!.getString(userIdKey).toString() ?? '',
      'video_id': widget.item.videoId,
      'status': like ? 'likes' : 'unlike',
    };
    log('CommentData-------------->>  $data');
    pro.videoStatics(context: context, data: data).then((value) {});
  }

  Future<void> onView() async {
    var pro = Provider.of<VideoProvider>(context, listen: false);
    var data = {
      'user_id': pref!.getString(userIdKey).toString() ?? '',
      'video_id': widget.item.videoId,
      'status': 'views',
    };
    log('CommentData-------------->>  $data');
    pro.videoStatics(context: context, data: data).then((value) {});
  }

  Future<void> onSave() async {
    var pro = Provider.of<VideoProvider>(context, listen: false);
    var data = {
      'user_id': pref!.getString(userIdKey).toString() ?? '',
      'video_id': widget.item.videoId,
      'status': 'save',
    };
    log('SaveData-------------->>  $data');
    pro.videoStatics(context: context, data: data).then((value) {
      customToast(context: context, msg: 'Video has been saved', type: 1);
    });
  }

  void onShare() async {
    var pro = Provider.of<VideoProvider>(context, listen: false);
    pro.onShareSocial(context, widget.item.video);
  }
}

class OptionsScreen1 extends StatelessWidget {
  final ProfileVideoModel item;

  const OptionsScreen1({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(color: Colors.black12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 110),
                  Row(
                    children: [
                      CircleAvatar(
                        child: Icon(Icons.person, size: 18),
                        radius: 16,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'flutter_developer02',
                        style: TextStyle(color: white),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.verified,
                        size: 15,
                        color: primary,
                      ),
                      SizedBox(width: 6),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Follow',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 6),
                  Text(
                    '${item.title} \n${item.description}',
                    style: TextStyle(color: white),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.music_note,
                        size: 15,
                      ),
                      // Text('Original Audio - some music track--'),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Icon(
                    Icons.favorite_outline,
                    color: Colors.white,
                  ),
                  Text(
                    item.totalLikes,
                    style: TextStyle(color: white),
                  ),
                  SizedBox(height: 20),
                  Icon(
                    Icons.comment_rounded,
                    color: Colors.white,
                  ),
                  Text(
                    item.totalComments,
                    style: TextStyle(color: white),
                  ),
                  SizedBox(height: 20),
                  Transform(
                    transform: Matrix4.rotationZ(5.8),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    item.totalShare,
                    style: TextStyle(color: white),
                  ),
                  SizedBox(height: 50),
                  Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
