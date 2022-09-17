import 'dart:async';
import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:nice_shot/core/ffmpeg/ffmpeg_service.dart';
import 'package:nice_shot/core/util/boxes.dart';
import 'package:nice_shot/core/error/exceptions.dart';
import 'package:nice_shot/data/model/video_model.dart';
import 'package:nice_shot/presentation/features/camera/widgets/actions_widget.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'bloc.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraController? controller;

  ResolutionPreset currentResolutionPreset = ResolutionPreset.high;
  Timer? countdownTimer;
  Duration videoDuration = const Duration(seconds: 0);
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.newPlayer();
  Duration selectedDuration = const Duration(minutes: 3);

  String strDigits(int n) => n.toString().padLeft(2, '0');

  get minutes => strDigits(videoDuration.inMinutes.remainder(60));

  get second => strDigits(videoDuration.inSeconds.remainder(60));
  double minAvailableZoom = 1.0;
  double maxAvailableZoom = 1.0;
  double currentZoomLevel = 1.0;

  CameraBloc() : super(CameraInitial()) {
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

  List<String> paths = [];
  final Trimmer trimmer = Trimmer();

  // v1 - v2 - v3
  // case 1 [no flags in v1] -> add to paths
  // case 2 [no flags in v2] -> add to paths and remove path v1
  // case 3 [no flags in v3] -> add to paths and remove path v2
  // case 3 [found flags in v1] -> store in local db
  // case 3 [found flags in last [51s - 60s] in v1 and not stop home] ->
  //..save v1 and get last 20s from v1 and first 10s from v2 and stop home when
  //..current duration is equal selected duration ex: [1 min] and start new home
  //result case 3 -> 20s+60s = 80s
  FFmpegService fFmpegService = FFmpegService();

  Future<void> _onStopRecording(
    StopRecordingEvent event,
    Emitter<CameraState> emit,
  ) async {
    try {
      var file = await _stopRecording();
      emit(StopRecordingState(fromUser: event.fromUser));
      countdownTimer!.cancel();
      videoDuration = const Duration(seconds: 0);
      var value = await _getPath();
      String newPath = "${value.path}/${file!.name}";
      await file.saveTo(newPath);
      event.video.path = newPath;
      File(file.path).deleteSync();
      if (event.video.flags!.isEmpty) {
        paths.add(newPath);
        if (paths.length > 1) {
          File(paths.first).deleteSync();
          paths.removeAt(0);
        }
      } else {
        await Boxes.videoBox.add(event.video);
        if (paths.isNotEmpty) paths.removeAt(0);
      }
      add(StartRecordingEvent(fromUser: event.fromUser));
    } on CameraException catch (e) {
      throw Exception(e);
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
        final seconds = videoDuration.inSeconds + reduceSecondsBy;
        if (seconds < 0) {
          countdownTimer!.cancel();
        } else {
          videoDuration = Duration(seconds: seconds);
          Duration currentDuration = videoDuration;
          VideoModel video = VideoModel(
            dateTime: DateTime.now(),
            videoDuration: videoDuration,
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
