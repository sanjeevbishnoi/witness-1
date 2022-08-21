import 'dart:async';
import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:nice_shot/core/util/boxes.dart';
import 'package:nice_shot/core/error/exceptions.dart';
import 'package:nice_shot/core/error/failure.dart';
import 'package:nice_shot/presentation/features/camera/widgets/actions_widget.dart';

import 'bloc.dart';

enum States { isInit, isRecording, isStop, isPause, isResume }

enum Times { one, two, three, four, five, six, seven, eight, nine }

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraController? controller;
  ResolutionPreset currentResolutionPreset = ResolutionPreset.high;
  Timer? countdownTimer;
  Duration duration = const Duration(seconds: 0);
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.newPlayer();

  String strDigits(int n) => n.toString().padLeft(2, '0');

  get minutes => strDigits(duration.inMinutes.remainder(60));

  get seconds => strDigits(duration.inSeconds.remainder(60));
  States states = States.isInit;
  double minAvailableZoom = 1.0;
  double maxAvailableZoom = 1.0;
  double currentZoomLevel = 1.0;

  CameraBloc() : super(const CameraInitial()) {
    on<InitCameraEvent>(_initCamera);
    on<StartRecordingEvent>(_onStartRecording);
    on<StopRecordingEvent>(_onStopRecording);
    on<PausedRecordingEvent>(_onPauseRecording);
    on<ResumeRecordingEvent>(_onResumeRecording);
    on<DeleteRecordingEvent>(_onDeleteRecording);
    on<OpenFlashEvent>(_onOpenFlash);
    on<ChangeZoomLeveEvent>(_onChangeCurrentZoomLevel);
    on<CheckingEvent>(_checking);
  }

  Future<void> _initCamera(
    InitCameraEvent event,
    Emitter<CameraState> emit,
  ) async {
    try {
      final cameras = await availableCameras();
      final back = cameras.firstWhere((camera) {
        return camera.lensDirection == CameraLensDirection.back;
      });

      controller = CameraController(
        back,
        currentResolutionPreset,
        enableAudio: true,
      );

      await controller!.initialize();

      controller!.getMaxZoomLevel().then((value) => maxAvailableZoom = value);
      controller!.getMinZoomLevel().then((value) => minAvailableZoom = value);
      emit(InitCameraState());
    } on CameraException catch (e) {
      debugPrint("$e");
    }
  }

  Future<void> _onStartRecording(
    StartRecordingEvent event,
    Emitter<CameraState> emit,
  ) async {
    try {
      states = States.isRecording;
      startTimer();
      await startRecording();
      // int seconds = 60;
      // Duration currentDuration = duration;
      // Duration selectedDuration = Duration(seconds: seconds);
      // List<String> paths = [];
      //
      // if (currentDuration == selectedDuration) {
      //   await stopRecording().then((value) => paths.add(value!.path));
      //   _startRecording();
      // }
      // if (currentDuration == (selectedDuration * 2) && flags.isEmpty) {
      //   await File(paths.first).delete();
      // }
      emit(StartRecordingState());
    } on CameraException catch (e) {
      debugPrint("$e");
    }
  }

  void startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      const reduceSecondsBy = 1;
      // const reduceSecondsBy = 1;
      final seconds = duration.inSeconds + reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
      emit(StartTimerState());
    });
  }

  Future<void> _onStopRecording(
    StopRecordingEvent event,
    Emitter<CameraState> emit,
  ) async {
    try {
      states = States.isStop;
      var file = await stopRecording();
      countdownTimer!.cancel();
      duration = const Duration(seconds: 0);
      emit(StopRecordingState(file: file!));
      event.videoModel.path = file.path;
      try {
        await Boxes.videoBox.add(event.videoModel);
      } on AddOrUpdateOrDeleteVideoFailure catch (e) {
        debugPrint("$e");
      }
    } on CameraException catch (e) {
      debugPrint("$e");
    }
  }

  Future<void> _onResumeRecording(
    ResumeRecordingEvent event,
    Emitter<CameraState> emit,
  ) async {
    try {
      states = States.isResume;
      startTimer();
      await _resumeRecording();

      emit(ResumeRecordingState());
    } on CameraException catch (e) {
      debugPrint("$e");
    }
  }

  Future<void> _onPauseRecording(
    PausedRecordingEvent event,
    Emitter<CameraState> emit,
  ) async {
    try {
      states = States.isPause;
      countdownTimer!.cancel();
      await _pauseRecording();
      emit(PauseRecordingState());
    } on CameraException catch (e) {
      debugPrint("$e");
    }
  }

  Future<void> _onDeleteRecording(
    DeleteRecordingEvent event,
    Emitter<CameraState> emit,
  ) async {
    try {
      await File(event.file.path).delete();
      emit(DeleteRecordingSuccessState());
    } on DeleteVideoException catch (e) {
      debugPrint("$e");
    }
  }

  Future<void> _onOpenFlash(
    OpenFlashEvent event,
    Emitter<CameraState> emit,
  ) async {
    try {
      await _openFlash(isOpen: event.isOpen);
      emit(FlashOpenedState());
    } catch (e) {
      emit(FlashErrorState(error: e.toString()));
      debugPrint("$e");
    }
  }

  Future<void> _onChangeCurrentZoomLevel(
    ChangeZoomLeveEvent event,
    Emitter<CameraState> emit,
  ) async {
    currentZoomLevel = event.currentZoomLevel;
    emit(ChangeCurrentZoomState());
  }

  Future<void> startRecording() async {
    final CameraController? cameraController = controller;

    if (!cameraController!.value.isInitialized) {
      return;
    }

    // audioPlayer.open(Audio("assets/audios/start.mp3"));
    await cameraController.prepareForVideoRecording();
    await cameraController.startVideoRecording();
  }

  Future<XFile?> stopRecording() async {
    final CameraController? cameraController = controller;

    if (!cameraController!.value.isInitialized) {
      return null;
    }

    //  audioPlayer.open(Audio("assets/audios/stop.mp3"));
    return await cameraController.stopVideoRecording();
  }

  Future<void> _pauseRecording() async {
    final CameraController? cameraController = controller;

    if (!cameraController!.value.isInitialized) {
      return;
    }
    // audioPlayer.open(Audio("assets/audios/pause.mp3"));
    await cameraController.pauseVideoRecording();
  }

  Future<void> _resumeRecording() async {
    final CameraController? cameraController = controller;

    if (!cameraController!.value.isInitialized) {
      return;
    }
    // audioPlayer.open(Audio("assets/audios/resume.mp3"));
    await cameraController.resumeVideoRecording();
  }

  Future<void> _openFlash({required bool isOpen}) async {
    final CameraController? cameraController = controller;
    if (!cameraController!.value.isInitialized) {
      return;
    }
    await cameraController
        .setFlashMode(isOpen ? FlashMode.off : FlashMode.always);
  }

  Future<void> _checking(
    CheckingEvent event,
    Emitter<CameraState> emit,
  ) async {}

@override
  Future<void> close() {
    controller?.dispose();
    return super.close();
  }

}
