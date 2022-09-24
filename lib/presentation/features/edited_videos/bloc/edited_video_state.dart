part of 'edited_video_bloc.dart';

class EditedVideoState extends Equatable {
  final Data<VideoModel>? video;
  final RequestState? requestState;
  final String? message;

  const EditedVideoState({
    this.video,
    this.requestState,
    this.message,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [video, requestState, message];

  EditedVideoState copyWith({
    Data<VideoModel>? video,
    RequestState? requestState,
    String? message,
  }) {
    return EditedVideoState(
      requestState: requestState ?? this.requestState,
      message: message ?? this.message,
      video: video ?? this.video,
    );
  }
}
