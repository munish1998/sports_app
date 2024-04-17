import 'package:card_swiper/card_swiper.dart';
import 'package:chewie/chewie.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '/app_image.dart';
import '/model/exerciseModel.dart';
import '/utils/color.dart';
import '/utils/commonMethod.dart';
import 'videoExRecordingScreen.dart';

class ExercisePlayerScreen extends StatefulWidget {
  final List<ExerciseModel> exercise;

  const ExercisePlayerScreen({super.key, required this.exercise});

  @override
  State<ExercisePlayerScreen> createState() => _ExercisePlayerScreenState();
}

class _ExercisePlayerScreenState extends State<ExercisePlayerScreen> {
  final List<String> videos = [
    'https://assets.mixkit.co/videos/preview/mixkit-taking-photos-from-different-angles-of-a-model-34421-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-young-mother-with-her-little-daughter-decorating-a-christmas-tree-39745-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-mother-with-her-little-daughter-eating-a-marshmallow-in-nature-39764-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-girl-in-neon-sign-1232-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-winter-fashion-cold-looking-woman-concept-video-39874-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-womans-feet-splashing-in-the-pool-1261-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4'
  ];

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
                itemBuilder: (BuildContext context, int index) {
                  return ExerciseContentScreen(
                    exercise: widget.exercise[index],
                  );
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
                    Icon(Icons.camera_alt),
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

class ExerciseContentScreen extends StatefulWidget {
  final ExerciseModel exercise;

  const ExerciseContentScreen({Key? key, required this.exercise})
      : super(key: key);

  @override
  State<ExerciseContentScreen> createState() => _ExerciseContentScreenState();
}

class _ExerciseContentScreenState extends State<ExerciseContentScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewController;
  bool _liked = false;
  SharedPreferences? pref;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future initializePlayer() async {
    pref = await SharedPreferences.getInstance();
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.exercise.video));
    await Future.wait([_videoPlayerController.initialize()]);
    _chewController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      showControls: true,
      looping: true,
      allowFullScreen: false,
      cupertinoProgressColors: ChewieProgressColors(playedColor: primary),
    );
    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(child: body),
    );
  }

  Widget get body => Container(
        child: Stack(
          fit: StackFit.expand,
          children: [
            _chewController != null &&
                    _chewController!.videoPlayerController.value.isInitialized
                ? GestureDetector(
                    onDoubleTap: () {
                      setState(() {
                        // _liked = !_liked;
                      });
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: Chewie(
                            controller: _chewController!,
                          ),
                        ),
                        practiceBTN,
                      ],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text(
                        'Loading...',
                        style: TextStyle(color: white),
                      )
                    ],
                  ),
            Positioned(
              top: 10,
              left: 10,
              child: Padding(
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
                  ],
                ),
              ),
            ),
            // Positioned(bottom: 100, left: 5, right: 5, child: playerController),
          ],
        ),
      );

  Widget get playerController => Container(
        width: double.infinity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      // if (_chewController!.isPlaying) {
                      //   _chewController!.pause();
                      // } else {
                      //   _chewController!.play();
                      // }
                    });
                  },
                  icon: AppImage(
                    'assets/playBack.svg',
                    height: 15,
                    width: 15,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (_chewController!.isPlaying) {
                          _chewController!.pause();
                        } else {
                          _chewController!.play();
                        }
                      });
                    },
                    icon: Icon(
                      _chewController!.isPlaying
                          ? Icons.pause_circle
                          : Icons.play_circle_fill_outlined,
                      size: 30,
                      color: white,
                    )),
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (_chewController!.isPlaying) {
                          _chewController!.pause();
                        } else {
                          _chewController!.play();
                        }
                      });
                    },
                    icon: AppImage(
                      'assets/playForward.svg',
                      height: 15,
                      width: 15,
                    )),
              ],
            ),
            VideoProgressIndicator(_chewController!.videoPlayerController,
                colors: VideoProgressColors(playedColor: primary),
                allowScrubbing: false),
          ],
        ),
      );

  Widget get practiceBTN => InkWell(
        onTap: () {
          navPush(
              context: context,
              action: VideoExRecording(exerciseId: widget.exercise.id));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DottedBorder(
            // strokeWidth: 0.5,
            // stackFit: StackFit.loose,
            radius: Radius.circular(35),
            borderType: BorderType.RRect,
            dashPattern: [10, 10],
            color: primary,
            child: Container(
              width: 250,
              padding: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(35),
              ),
              alignment: Alignment.center,
              child: Text(
                'Practice',
                style: TextStyle(color: white, fontSize: 30),
              ),
            ),
          ),
        ),
      );
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
            snapshot.connectionState != ConnectionState.done
                ? Icon(Icons.favorite, size: 110)
                : SizedBox(),
      ),
    );
  }
}

class OptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: 110),
                  Row(
                    children: [
                      CircleAvatar(
                        child: Icon(Icons.person, size: 18),
                        radius: 16,
                      ),
                      SizedBox(width: 6),
                      Text('flutter_developer02'),
                      SizedBox(width: 10),
                      Icon(Icons.verified, size: 15),
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
                  Text('Flutter is beautiful and fast 💙❤💛 ..'),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.music_note,
                        size: 15,
                      ),
                      Text('Original Audio - some music track--'),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.favorite_outline),
                  Text('601k'),
                  SizedBox(height: 20),
                  Icon(Icons.comment_rounded),
                  Text('1123'),
                  SizedBox(height: 20),
                  Transform(
                    transform: Matrix4.rotationZ(5.8),
                    child: Icon(Icons.send),
                  ),
                  SizedBox(height: 50),
                  Icon(Icons.more_vert),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
