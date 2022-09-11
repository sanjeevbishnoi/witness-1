//import 'package:equatable/equatable.dart';

// enum RequestState {
//   loading,
//   loaded,
//   error,
// }
//
// class CameraStateTest extends Equatable {
//   final bool fromUser;
//   final RequestState requestState;
//   final String message;
//
//   const CameraStateTest({
//     this.fromUser = false,
//     this.requestState = RequestState.loading,
//     this.message = "",
//   });
//
//   @override
//   // TODO: implement props
//   List<Object?> get props => throw UnimplementedError();
//
//   CameraStateTest copyWith({
//     bool? fromUser,
//     RequestState? requestState,
//     String? message,
//   }) {
//     return CameraStateTest(
//       requestState: requestState ?? this.requestState,
//       message: message ?? this.message,
//       fromUser: fromUser ?? this.fromUser,
//     );
//   }
// }
abstract class CameraState {
  const CameraState();
}

class CameraInitial extends CameraState {}

class InitCameraState extends CameraState {}

class ChangeCurrentZoomState extends CameraState {}

class StartRecordingState extends CameraState {}

class StopRecordingState extends CameraState {
  final bool fromUser;

  StopRecordingState({required this.fromUser});
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
