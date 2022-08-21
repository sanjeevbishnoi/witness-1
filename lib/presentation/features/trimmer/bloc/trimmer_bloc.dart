import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:video_trimmer/video_trimmer.dart';

part 'trimmer_event.dart';

part 'trimmer_state.dart';

class TrimmerBloc extends Bloc<TrimmerEvent, TrimmerState> {
  final Trimmer _trimmer = Trimmer();
  double startValue = 0.0;
  double endValue = 0.0;

  TrimmerBloc() : super(TrimmerInitial()) {
    on<TrimmerEvent>((event, emit) {});
    on<InitTrimmerEvent>(_onInitTrimmer);
  }

  Future<void> _onInitTrimmer(
    InitTrimmerEvent event,
    Emitter<TrimmerState> emit,
  ) async {
    _trimmer.loadVideo(videoFile: event.file);
    _trimmer.videPlaybackControl(
      startValue: startValue,
      endValue: endValue,
    );
    emit(InitTrimmerState(trimmer: _trimmer));
  }
}
