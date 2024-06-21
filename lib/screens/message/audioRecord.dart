import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'dart:developer';

class AudioRecord extends StatefulWidget {
  const AudioRecord({super.key});

  @override
  State<AudioRecord> createState() => _AudioRecordState();
}

class _AudioRecordState extends State<AudioRecord> {
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  String audioPath = '';
  @override
  void initState() {
    audioRecord = Record();
    audioPlayer = AudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    audioRecord.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    try {
      if (await audioRecord.hasPermission()) {
        audioRecord.start();
        setState(() {
          isRecording = true;
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await audioRecord.stop();
      setState(() {
        isRecording = false;
        audioPath = path!;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> playRecording() async {
    try {
      if (audioPath.isNotEmpty) {
        await audioPlayer.stop(); // Stop any current playback
        await audioPlayer.play(DeviceFileSource(audioPath));
        log('audiopath===>>>>$audioPath');
      } else {
        log('Audio path is empty.');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 150),
          child: Column(
            children: [
              if (isRecording) Text('Recording is in progress'),
              ElevatedButton(
                  onPressed: isRecording ? stopRecording : startRecording,
                  child: isRecording
                      ? Text('stop recording')
                      : Text('Start recording')),
              if (!isRecording && audioPath != null)
                ElevatedButton(
                  onPressed: playRecording,
                  child: Text('play recording'),
                )
            ],
          ),
        ),
      ),
    );
  }
}
