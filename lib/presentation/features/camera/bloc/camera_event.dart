import 'package:camera/camera.dart';
import 'package:nice_shot/data/model/flag_model.dart';
import '../../../../data/model/video_model.dart';

abstract class CameraEvent {
  const CameraEvent();
}

class InitCameraEvent extends CameraEvent {}

class StartRecordingEvent extends CameraEvent {
  final bool fromUser;

  StartRecordingEvent({required this.fromUser});
}

class StopRecordingEvent extends CameraEvent {
  final VideoModel video;
  final bool fromUser;

  const StopRecordingEvent({required this.video, required this.fromUser});
}

class PausedRecordingEvent extends CameraEvent {}

class ResumeRecordingEvent extends CameraEvent {}

//to test
class CheckingEvent extends CameraEvent {}

class ChangeZoomLeveEvent extends CameraEvent {
  double currentZoomLevel = 1.0;

  ChangeZoomLeveEvent({required this.currentZoomLevel});
}

class OpenFlashEvent extends CameraEvent {
  bool isOpen = false;

  OpenFlashEvent({required this.isOpen});
}

class DeleteRecordingEvent extends CameraEvent {
  final XFile file;

  const DeleteRecordingEvent({required this.file});
}

class AddVideoEvent extends CameraEvent {
  final VideoModel video;

  const AddVideoEvent({required this.video});
}

class AddFlagEvent extends CameraEvent {
  final List<FlagModel> flags;

  AddFlagEvent({required this.flags});
}
