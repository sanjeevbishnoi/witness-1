// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:nice_shot/core/themes/app_theme.dart';
import 'package:nice_shot/data/model/flag_model.dart';
import 'package:nice_shot/data/model/video_model.dart';

import '../bloc/bloc.dart';

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
      children: _mapToActions(),
    );
  }

  List<Widget> _mapToActions() {
    CameraState state = cameraBloc.state;
    if (state is StartRecordingState ||
        state is ResumeRecordingState ||
        state is StartTimerState) {
      return [
        FloatingActionButton(
          onPressed: () => _onPressStop(),
          child: const Icon(Icons.stop),
        ),
        FloatingActionButton(
          backgroundColor: MyColors.backgroundColor,
          onPressed: () => _onPressFlag(),
          child: const Icon(Icons.flag, color: MyColors.primaryColor),
        ),
        FloatingActionButton(
          onPressed: () => cameraBloc.add(PausedRecordingEvent()),
          child: const Icon(Icons.pause),
        ),
      ];
    } else if (state is PauseRecordingState) {
      return [
        FloatingActionButton(
          onPressed: () => _onPressStop(),
          child: const Icon(Icons.stop),
        ),
        FloatingActionButton(
          onPressed: () => cameraBloc.add(ResumeRecordingEvent()),
          child: const Icon(Icons.play_arrow),
        ),
      ];
    } else if (state is StopRecordingState) {
      return [startVideoButton(clickAble: state.fromUser)];
    }

    return [startVideoButton(clickAble: true)];
  }

  Widget startVideoButton({required bool clickAble}) => clickAble
      ? FloatingActionButton(
          onPressed: () => cameraBloc.add(StartRecordingEvent(fromUser: false)),
          child: const Icon(Icons.circle_rounded),
        )
      : const CircularProgressIndicator();

  void _onPressFlag() {
    //cameraBloc.audioPlayer.open(Audio("assets/audios/flags.mp3"));
    FlagModel flag = FlagModel(flagPoint: cameraBloc.videoDuration);
    flags.add(flag);
  }

  Future<void> _onPressStop() async {
    VideoModel video = VideoModel(
      dateTime: DateTime.now(),
      videoDuration: cameraBloc.videoDuration,
      flags: flags,
    );
    if (cameraBloc.videoDuration == cameraBloc.selectedDuration && flags.isEmpty) {
      cameraBloc.add(StopRecordingEvent(video: video, fromUser: true));
    } else {
      cameraBloc.add(StopRecordingEvent(video: video, fromUser: true));
      flags = [];
    }
  }
}
