import 'package:camera/camera.dart';

abstract class CameraState {
  const CameraState();
}

class CameraInitial extends CameraState {
  const CameraInitial();
}

class InitCameraLoadingState extends CameraState {}

class InitCameraState extends CameraState {}

class ChangeCurrentZoomState extends CameraState {}

class StartRecordingState extends CameraState {}

class StopRecordingState extends CameraState {
  final XFile? file;

  StopRecordingState({this.file});
}

class PauseRecordingState extends CameraState {}

class ResumeRecordingState extends CameraState {}

class FlashOpenedState extends CameraState {}
class FlashErrorState extends CameraState {
  final String error;

  FlashErrorState({required this.error});
}

class DeleteRecordingSuccessState extends CameraState {}

class AddVideoSuccessState extends CameraState {}

class AddVideoErrorState extends CameraState {
  final String error;

  AddVideoErrorState({required this.error});
}
class StartTimerState extends CameraState {}
class CheckingState extends CameraState {}