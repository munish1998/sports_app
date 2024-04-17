import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../app_image.dart';
import '../../utils/color.dart';
import '/screens/home/dashboard.dart';
import '/utils/commonMethod.dart';
import 'recordPreviewScreen.dart';

class VideoRecording extends StatefulWidget {
  final bool isDashboard;

  const VideoRecording({super.key, required this.isDashboard});

  @override
  State<VideoRecording> createState() => _VideoRecordingState();
}

class _VideoRecordingState extends State<VideoRecording>
    with WidgetsBindingObserver {
  late List<CameraDescription> cameras;
  bool _isLoading = true;
  CameraController? _cameraController;

  bool isRecordingDone = false;
  XFile? recordedVideo;
  File? galleryFile;
  int selectedCameraIndex = 0;
  bool isFront = false;
  double height = 0;
  double width = 0;
  int secondsRecorded = 0;
  Timer? timer;

  bool isRecording = false;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController!.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // final CameraController cameraController = _cameraController;
    // log('message ----------1------->>>  ${AppLifecycleState.detached}');

    // App state changed before we got the chance to initialize.
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      _cameraController!.dispose();
      log('message ----------1------->>>  ${AppLifecycleState.detached}');
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
      log('message ----------------->>>  ${AppLifecycleState.resumed}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    if (_isLoading) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              SizedBox(
                height: height * 0.9,
                child: CameraPreview(
                  _cameraController!,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      _formatDuration(secondsRecorded),
                      style: GoogleFonts.mulish(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white24),
                  child: IconButton(
                    onPressed: () {
                      if (widget.isDashboard) {
                        navPushRemove(
                            context: context, action: DashboardScreen());
                      } else {
                        navPop(context: context);
                      }
                    },
                    icon: Icon(
                      Icons.clear,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 65,
                left: 0,
                right: 0,
                child: /* isRecordingDone ? saveOrShare :*/ record,
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget get record => Padding(
        padding: EdgeInsets.only(
          left: 60,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: onGalleryPick,
                icon: Icon(
                  Icons.image_outlined,
                  size: 45,
                  color: white,
                )),
            InkWell(
              onTap: () async {
                if (isRecording == true) {
                  await _cameraController!.stopVideoRecording().then((value) {
                    if (timer != null) {
                      timer!.cancel();
                      setState(() {
                        isRecording = false;
                        recordedVideo = value;
                        isRecordingDone = true;
                        secondsRecorded = 0;
                        timer = null;
                      });
                    }
                    // _cameraController!.stopImageStream();
                    navPush(
                        context: context,
                        action: RecordPreviewScreen(
                          file: value.path,
                        ));
                    log('VideoPath---------->>>  ${value.path}');
                  });
                } else {
                  await _cameraController!.startVideoRecording().then((value) {
                    setState(() {
                      isRecording = true;
                      timer =
                          Timer.periodic(const Duration(seconds: 1), (Timer t) {
                        setState(() {
                          secondsRecorded = t.tick;
                        });
                      });
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Started Practicing",
                        ),
                      ),
                    );
                  });
                }
              },
              child: DottedBorder(
                color: const Color(0xff24D993),
                dashPattern: const [13, 4],
                strokeWidth: 2,
                borderType: BorderType.Circle,
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: const ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.12, -0.99),
                      end: Alignment(-0.12, 0.99),
                      colors: [
                        Color(0xFF7971B5),
                        Color(0xFF202243),
                      ],
                    ),
                    shape: OvalBorder(
                      side: BorderSide(width: 0.50, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                if (isRecording == true) {
                  _cameraController!.stopVideoRecording().then((value) {
                    if (timer != null) {
                      timer!.cancel();
                      setState(() {
                        isRecording = false;
                        toggleCamera();
                      });
                    }
                  });
                } else {
                  setState(() {
                    toggleCamera();
                  });
                }
                //    _cameraController!.
              },
              icon: Container(
                height: 45,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(right: 35),
                width: 45,
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.12, -0.99),
                    end: Alignment(-0.12, 0.99),
                    colors: [Color(0xFF7971B5), Color(0xFF202243)],
                  ),
                  shape: OvalBorder(
                    side: BorderSide(width: 0.0, color: Colors.transparent),
                  ),
                ),
                child: const AppImage(
                  "assets/ic_switch.svg",
                ),
              ),
            ),
          ],
        ),
      );

  _initCamera() async {
    cameras = await availableCameras();
    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);
    _cameraController = CameraController(front, ResolutionPreset.max);
    await _cameraController!.initialize();
    setState(() => _isLoading = false);
  }

  void toggleCamera() {
    setState(() {
      isFront = !isFront;
    });
    _cameraController =
        CameraController(cameras[isFront ? 1 : 0], ResolutionPreset.high);
    _cameraController!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
    log(errorText);
  }

  void onGalleryPick() async {
    if (isRecording == true) {
      await _cameraController!.stopVideoRecording().then((value) {
        if (timer != null) {
          timer!.cancel();
          setState(() {
            isRecording = false;
            isRecordingDone = true;
            secondsRecorded = 0;
            timer = null;
          });
        }
        // _cameraController!.stopImageStream();
      });
    }
    final pickedFile = await ImagePicker().pickVideo(
        source: ImageSource.gallery,
        preferredCameraDevice: CameraDevice.front,
        maxDuration: Duration(seconds: 30));
    VideoPlayerController testLengthController =
        VideoPlayerController.file(File(pickedFile!.path)); //Your file here
    await testLengthController.initialize();

    if (testLengthController.value.duration.inSeconds <= 30) {
      setState(() {
        if (pickedFile != null) {
          galleryFile = File(pickedFile.path);
          navPush(
              context: context,
              action: RecordPreviewScreen(
                file: galleryFile!.path,
              ));
          log('VideoPath---------->>>  ${galleryFile!.path}');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      });
    } else {
      setState(() {
        galleryFile = null;
      });
      commonAlert(
          context, 'File is too long \n Please select max 30 sec video');
    }
  }
}
