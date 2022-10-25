part of 'raw_video_bloc.dart';

class RawVideoState extends Equatable {
  final Data<VideoModel>? video;
  final Pagination? data;
  final RequestState? requestState;
  final RequestState? uploadingState;
  final RequestState? flagRequest;
  final String? message;
  final String? taskId;
  final int? index;
  final int? progressValue;
  final List<TagModel>? tags;
  const RawVideoState({
    this.video,
    this.data,
    this.requestState,
    this.uploadingState,
    this.message,
    this.index,
    this.progressValue,
    this.taskId,
    this.flagRequest,
    this.tags,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        video,
        requestState,
        message,
        data,
        index,
        progressValue,
        uploadingState,
        taskId,
        flagRequest,
    tags,
      ];

  RawVideoState copyWith({
    Data<VideoModel>? video,
    RequestState? requestState,
    String? message,
    Pagination? data,
    int? index,
    int? progressValue,
    RequestState? uploadingState,
    RequestState? flagRequest,
    String? taskId,
    List<TagModel>? tags,
  }) {
    return RawVideoState(
      requestState: requestState ?? this.requestState,
      message: message ?? this.message,
      video: video ?? this.video,
      data: data ?? this.data,
      index: index ?? this.index,
      progressValue: progressValue ?? this.progressValue,
      uploadingState: uploadingState ?? this.uploadingState,
      taskId: taskId ?? this.taskId,
      flagRequest: flagRequest ?? this.flagRequest,
      tags: tags ?? this.tags,
    );
  }
}
