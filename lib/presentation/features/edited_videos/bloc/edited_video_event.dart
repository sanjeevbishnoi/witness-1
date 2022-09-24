part of 'edited_video_bloc.dart';

abstract class EditedVideoEvent {}

class UploadVideoEvent extends EditedVideoEvent {
  final VideoModel video;

  UploadVideoEvent({required this.video});
}
