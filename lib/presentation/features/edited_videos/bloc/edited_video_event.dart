part of 'edited_video_bloc.dart';

abstract class EditedVideoEvent {}

class GetEditedVideosEvent extends EditedVideoEvent {
  final String id;

  GetEditedVideosEvent({required this.id});
}

class UploadVideoEvent extends EditedVideoEvent {
  final VideoModel video;
  final int index;

  UploadVideoEvent({required this.video, required this. index});
}

class UpdateVideoEvent extends EditedVideoEvent {
  final VideoModel video;

  UpdateVideoEvent({required this.video});
}

class DeleteEditedVideoEvent extends EditedVideoEvent {
  final String id;

  DeleteEditedVideoEvent({required this.id});
}

//class CheckVideosEvent extends EditedVideoEvent {}

class UploadEvent extends EditedVideoEvent {}

class CancelUploadVideoEvent extends EditedVideoEvent {
  final String taskId;

  CancelUploadVideoEvent({required this.taskId});
}
