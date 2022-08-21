// ignore_for_file: must_be_immutable
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:nice_shot/core/themes/app_theme.dart';
import 'package:nice_shot/data/model/flag_model.dart';
import 'package:nice_shot/data/model/video_model.dart';

import '../bloc/bloc.dart';

enum Events { onStart, onPause, onResume, onStop, onFlag }

List<FlagModel> flags = [];

class ActionsWidget extends StatelessWidget {
  final CameraBloc cameraBloc;

  const ActionsWidget({
    Key? key,
    required this.cameraBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _mapState(),
    );
  }

  List<Widget> _mapState() {
    switch (cameraBloc.states) {
      case States.isStop:
        cameraBloc.states = States.isInit;
        return [
          actions(Events.onStart),
        ];
      case States.isRecording:
      case States.isResume:
        return [
          actions(Events.onPause),
          actions(Events.onFlag),
          actions(Events.onStop),
        ];
      case States.isPause:
        return [
          actions(Events.onResume),
          actions(Events.onStop),
        ];
      default:
        cameraBloc.states = States.isInit;
        return [
          actions(Events.onStart),
        ];
    }
  }

  Widget actions(Events e) {
    switch (e) {
      case Events.onStart:
        return FloatingActionButton(
          onPressed: () => cameraBloc.add(StartRecordingEvent()),
          child: const Icon(Icons.circle_rounded),
        );

      case Events.onPause:
        return FloatingActionButton(
          onPressed: () => cameraBloc.add(PausedRecordingEvent()),
          child: const Icon(Icons.pause),
        );
      case Events.onFlag:
        return FloatingActionButton(
          backgroundColor: MyColors.backgroundColor,
          onPressed: () => _onPressFlag(),
          child: const Icon(Icons.flag, color: MyColors.primaryColor),
        );
      case Events.onResume:
        return FloatingActionButton(
          onPressed: () => cameraBloc.add(ResumeRecordingEvent()),
          child: const Icon(Icons.play_arrow),
        );
      case Events.onStop:
        return FloatingActionButton(
          onPressed: () => _onPressStop(),
          child: const Icon(Icons.stop),
        );
    }
  }

  void _onPressFlag() {
    //cameraBloc.audioPlayer.open(Audio("assets/audios/flag.mp3"));
    FlagModel flag = FlagModel(
      id: "${DateTime.now().microsecondsSinceEpoch}",
      time: "${cameraBloc.minutes}:${cameraBloc.seconds}",
    );

    flags.add(flag);
  }

  void _onPressStop() {
    VideoModel video = VideoModel(
      id: "${DateTime.now().microsecondsSinceEpoch}",
      dateTime: DateTime.now(),
      timeVideo: "${cameraBloc.minutes}:${cameraBloc.seconds}",
      flags: flags,
    );
    cameraBloc.add(StopRecordingEvent(videoModel: video));
    flags = [];
  }

  Future<void> checking() async {
    int seconds = 60;
    Duration currentDuration = cameraBloc.duration;
    Duration selectedDuration = Duration(seconds: seconds);
    List<String> paths = [];

    if (currentDuration == selectedDuration) {
      await cameraBloc.stopRecording().then((value) => paths.add(value!.path));
      await cameraBloc.startRecording();
    }
    if (currentDuration == (selectedDuration * 2) && flags.isEmpty) {
      await File(paths.first).delete();
      cameraBloc.duration = const Duration(seconds: 0);
    }
  }
}

//Times? times;
// switch (times) {
//   case Times.one:
//     seconds = 60;
//     break;
//   case Times.two:
//     seconds = 120;
//     break;
//   case Times.three:
//     seconds = 180;
//     break;
//   case Times.four:
//     seconds = 240;
//     break;
//   case Times.five:
//     seconds = 300;
//     break;
//   case Times.six:
//     seconds = 360;
//     break;
//   case Times.seven:
//     seconds = 420;
//     break;
//   case Times.eight:
//     seconds = 480;
//     break;
//   case Times.nine:
//     seconds = 540;
//     break;
//   default:
//     seconds = 60;
// }
