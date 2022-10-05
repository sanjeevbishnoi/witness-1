part of 'raw_video_bloc.dart';

@immutable
abstract class RawVideoEvent {}

class UploadRawVideoEvent extends RawVideoEvent {
  final VideoModel video;

  UploadRawVideoEvent({required this.video});
}
