part of 'trimmer_bloc.dart';

@immutable
abstract class TrimmerState {}

class TrimmerInitial extends TrimmerState {}

class InitTrimmerState extends TrimmerState {
  final Trimmer trimmer;

  InitTrimmerState({required this.trimmer});
}
