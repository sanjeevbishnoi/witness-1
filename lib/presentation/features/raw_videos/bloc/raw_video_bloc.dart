import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/util/enums.dart';
import '../../../../data/model/api/data_model.dart';
import '../../../../data/model/api/video_model.dart';
import '../../../../data/repositories/raw_video_repository.dart';

part 'raw_video_event.dart';

part 'raw_video_state.dart';

class RawVideoBloc extends Bloc<RawVideoEvent, RawVideoState> {
  final RawVideosRepository rawVideosRepository;

  RawVideoBloc({required this.rawVideosRepository})
      : super(const RawVideoState()) {
    on<RawVideoEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<UploadRawVideoEvent>(_uploadRawVideoEvent);
  }

  Future<void> _uploadRawVideoEvent(
    UploadRawVideoEvent event,
    Emitter<RawVideoState> emit,
  ) async {
    emit(state.copyWith(requestState: RequestState.loading));
    var successOrFailure = await rawVideosRepository.uploadVideo(
      video: event.video,
    );
    successOrFailure.fold(
      (l) => emit(state.copyWith(
        requestState: RequestState.error,
        message: l.runtimeType.toString(),
      )),
      (r) => emit(state.copyWith(
        requestState: RequestState.loaded,
        video: r,
      )),
    );
  }
}
