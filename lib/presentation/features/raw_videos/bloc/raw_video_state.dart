part of 'raw_video_bloc.dart';

class RawVideoState extends Equatable {
  final Data<VideoModel>? video;
  final RequestState? requestState;
  final String? message;

  const RawVideoState({
    this.requestState,
    this.message,
    this.video,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [video,requestState, message];

  RawVideoState copyWith({
    RequestState? requestState,
    String? message,
    Data<VideoModel>? video
  }) {
    return RawVideoState(
      requestState: requestState ?? this.requestState,
      message: message ?? this.message,
      video: video ?? this.video,
    );
  }
}
