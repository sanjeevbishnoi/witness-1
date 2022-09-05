import 'dart:async';
import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nice_shot/core/util/boxes.dart';
import 'package:nice_shot/core/error/exceptions.dart';
import 'package:nice_shot/data/model/video_model.dart';
import 'package:nice_shot/presentation/features/camera/widgets/actions_widget.dart';

import 'bloc.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraController? controller;
  ResolutionPreset currentResolutionPreset = ResolutionPreset.high;
  Timer? countdownTimer;
  Duration duration = const Duration(seconds: 0);
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.newPlayer();
  Duration selectedDuration = const Duration(minutes: 1);

  String strDigits(int n) => n.toString().padLeft(2, '0');

  get minutes => strDigits(duration.inMinutes.remainder(60));

  get seconds => strDigits(duration.inSeconds.remainder(60));
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
      emit(InitCameraState());
      controller!.getMaxZoomLevel().then((value) => maxAvailableZoom = value);
      controller!.getMinZoomLevel().then((value) => minAvailableZoom = value);
    } on CameraException catch (e) {
      debugPrint("$e");
    }
  }

  Future<void> _onStartRecording(
    StartRecordingEvent event,
    Emitter<CameraState> emit,
  ) async {
    try {
      if (!event.fromUser) {
        startTimer();
        await _startRecording();
        emit(StartRecordingState());
      }
    } on CameraException catch (e) {
      debugPrint("$e");
    }
  }

  Future<void> _onStopRecording(
    StopRecordingEvent event,
    Emitter<CameraState> emit,
  ) async {
    List<String> paths = [];
    try {
      var file = await _stopRecording();
      countdownTimer!.cancel();
      duration = const Duration(seconds: 0);
      var value = await _getPath();
      String newPath = "${value.path}/${file!.name}";
      await file.saveTo(newPath);
      event.video.path = newPath;
      File(file.path).deleteSync();
      emit(StopRecordingState(fromUser: event.fromUser));
      if (event.video.flags!.isEmpty) {
        paths.isNotEmpty ? File(paths.first).deleteSync() : paths.add(newPath);
      } else {
        await Boxes.videoBox.add(event.video);
        flags = [];
        add(StartRecordingEvent(fromUser: event.fromUser));
      }
      // if (!event.fromUser) {
      //   add(StartRecordingEvent());
      // }
      // if (!event.fromUser) {
      //   add(StartRecordingEvent());
      // } else {
      //   await Boxes.videoBox.add(event.videoModel);
      //   flags = [];
      //   if (!event.fromUser) {
      //     add(StartRecordingEvent());
      //   }
      // }
    } on CameraException catch (e) {
      debugPrint("$e");
    }
  }

  Future<void> _onResumeRecording(
    ResumeRecordingEvent event,
    Emitter<CameraState> emit,
  ) async {
    try {
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

  Future<void> _startRecording() async {
    final CameraController? cameraController = controller;

    if (!cameraController!.value.isInitialized) {
      return;
    }
    await cameraController.prepareForVideoRecording();
    await cameraController.startVideoRecording();
  }

  Future<XFile?> _stopRecording() async {
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

  Future<Directory> _getPath() async {
    var path = await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DCIM,
    );
    Directory directory = Directory("$path/witness/records");
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    return directory;
  }
  void startTimer() {
    countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) async {
        const reduceSecondsBy = 1;
        final seconds = duration.inSeconds + reduceSecondsBy;
        if (seconds < 0) {
          countdownTimer!.cancel();
        }
        else {
          duration = Duration(seconds: seconds);
          Duration currentDuration = duration;
          VideoModel video = VideoModel(
            dateTime: DateTime.now(),
            timeVideo: "$minutes:$seconds",
            flags: flags,
          );
          if (currentDuration == selectedDuration && flags.isEmpty) {

            add(StopRecordingEvent(
              video: video..flags = [],
              fromUser: false,
            ));
          } else if (currentDuration == selectedDuration && flags.isNotEmpty) {
            add(StopRecordingEvent(
              video: video,
              fromUser: false,
            ));
            flags = [];
          }
        }
        emit(StartTimerState());
      },
    );
  }

  @override
  Future<void> close() {
    controller?.dispose();
    return super.close();
  }
}
