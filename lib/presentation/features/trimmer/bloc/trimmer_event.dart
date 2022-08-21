part of 'trimmer_bloc.dart';

@immutable
abstract class TrimmerEvent{}

class InitTrimmerEvent extends TrimmerEvent {
 final File file;

  InitTrimmerEvent({required this.file});
}

class ChangeStartPointEvent extends TrimmerEvent {}

class ChangeEndPointEvent extends TrimmerEvent {}

class ExportVideoEvent extends TrimmerEvent {}

class PauseVideoPlayerEvent extends TrimmerEvent {}

class ResumeVideoPlayerEvent extends TrimmerEvent {}
