import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:touchmaster/utils/color.dart';

//
// import 'SpeechApi.dart';

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: body,
    );
  }

  Widget get body => SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              CommentWidgetNew(
                commentController: _controller1,
                title: 'Comment 1',
                strResult: '',
                showBorder: true,
              ),
              SizedBox(
                height: 15,
              ),
              CommentWidgetNew(
                commentController: _controller2,
                title: 'Comment 2',
                strResult: '',
                showBorder: true,
              ),
              SizedBox(
                height: 15,
              ),
              CommentWidgetNew(
                commentController: _controller3,
                title: 'Comment 3',
                strResult: '',
                showBorder: true,
              ),
            ],
          ),
        ),
      );
}

class CommentWidgetNew extends StatefulWidget {
  late TextEditingController commentController;
  String title = 'Comment';
  late String strResult;
  bool showBorder = false;
  Color? borderColor;
  Color? backGroundColor;
  double? width;
  double? height;

  CommentWidgetNew(
      {required TextEditingController commentController,
      required String title,
      required String strResult,
      required bool showBorder,
      Color? borderColor,
      Color? backGroundColor,
      double? width,
      double? height,
      Key? key})
      : super(key: key) {
    this.commentController = commentController;
    this.title = title;
    this.strResult = strResult;
    this.showBorder = showBorder;
    this.borderColor = borderColor;
    this.backGroundColor = backGroundColor;
    this.width = width;
    this.height = height;
  }

  @override
  State<CommentWidgetNew> createState() => _CommentWidgetNewState();
}

class _CommentWidgetNewState extends State<CommentWidgetNew> {
  stt.SpeechToText? _speech;
  bool _isListening = false;
  bool _isLoad = false;

  @override
  void initState() {
    super.initState();
    if (_speech != null) _speech!.stop();

    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (widget.width != null) ? widget.width : null,
      height: (widget.height != null) ? widget.height : null,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(10),
          border: (widget.showBorder)
              ? Border.all(width: 1, color: Colors.black)
              : null),
      child: Column(
        children: [
          TextFormField(
            controller: widget.commentController,
            maxLines: 5,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '${widget.title}',
                hintStyle: TextStyle(color: Colors.grey)),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: _listenTopComment,
                child: _isLoad
                    ? CircularProgressIndicator()
                    : Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 1,
                              color: primary,
                            )),
                        child: Icon(
                          (_isListening == true) ? Icons.pause : Icons.mic,
                          color: primary,
                          size: 30,
                        )),
              )
            ],
          ),
        ],
      ),
    );
  }

  /* Future toggleRecording() => SpeechApi.toggleRecording(
        onResult: (text) => setState(() {
          widget.commentController.text =
              widget.commentController.text + ' ' + text;
        }),
        onListening: (isListening) {
          setState(() => this._isListening = isListening);

          if (!isListening) {
            Future.delayed(Duration(seconds: 1), () {
              // Utils.scanText(text);
            });
          }
        },
      );*/

  void _listenTopComment() async {
    if (_isListening == false) {
      setState(() {
        _isLoad = true;
      });

      bool available = await _speech!.initialize(
        onStatus: (val) {
          _isListening = true;

          if (val == 'done') {
            log('ASHISH33 STATUS+==============DONE ');
            if (mounted) {
              _speech!.stop().then((value) {
                setState(() {
                  _isListening = false;

                  _isLoad = false;
                  log('ASHISH34 STATUS+=======11=======DONE $_isListening');
                });
              });
            }
          } else {
            if (mounted) {
              setState(() {
                log('ASHISH2 STATUS+==============$val');
                _isLoad = false;
              });
            }
          }
        },
        onError: (val) {
          if (mounted) {
            setState(() {
              _isListening = false;
              _isLoad = false;
            });
          }
          log('onError: $val');
        },
      );
      if (available) {
        setState(() {
          _isListening = true;
          _isLoad = false;
        });
        _speech!.listen(
            onResult: (val) => setState(() {
                  log('ASHISH2+==============${val.recognizedWords}');
                  widget.commentController.text = val.recognizedWords + '';
                  if (val.finalResult) {
                    _isListening = false;
                  }
                }),
            pauseFor: Duration(seconds: 10),
            listenOptions: stt.SpeechListenOptions(),
            partialResults: true,
            cancelOnError: true,
            listenMode: stt.ListenMode.dictation);
      }
    } else {
      _speech!.stop().then((value) {
        if (mounted) {
          setState(() {
            _isListening = false;
            _isLoad = false;
          });
        }
      });
    }
  }
}
