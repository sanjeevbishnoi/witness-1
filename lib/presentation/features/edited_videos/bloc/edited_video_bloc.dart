import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nice_shot/core/util/enums.dart';
import 'package:nice_shot/data/model/api/data_model.dart';
import 'package:nice_shot/data/repositories/edited_video_repository.dart';

import '../../../../data/model/api/video_model.dart';

part 'edited_video_event.dart';

part 'edited_video_state.dart';

class EditedVideoBloc extends Bloc<EditedVideoEvent, EditedVideoState> {
  final EditedVideosRepository editedVideosRepository;

  EditedVideoBloc({
    required this.editedVideosRepository,
  }) : super(const EditedVideoState()) {
    on<EditedVideoEvent>((event, emit) async {
      if (event is UploadVideoEvent) {
        emit(state.copyWith(requestState: RequestState.loading));
        var successOrFailure = await editedVideosRepository.uploadVideo(
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
    });
  }
}
