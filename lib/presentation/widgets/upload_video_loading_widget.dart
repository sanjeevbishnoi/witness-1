import 'package:flutter/material.dart';

import '../../core/themes/app_theme.dart';
import '../features/edited_videos/bloc/edited_video_bloc.dart';

class UploadVideoLoadingWidget extends StatelessWidget {
  final EditedVideoBloc videoBloc;

  const UploadVideoLoadingWidget({Key? key, required this.videoBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int progress = videoBloc.state.progressValue!;
    String taskId = videoBloc.state.taskId!;
    return Align(
      alignment: Alignment.bottomRight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: LinearProgressIndicator(
              color: MyColors.primaryColor,
              value: progress.toDouble() / 100,
              backgroundColor: Colors.grey.shade100,
              minHeight: 10.0,
            ),
          ),
          const SizedBox(width: MySizes.horizontalSpace),
          Expanded(
            child: Text(
              "$progress%",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(width: MySizes.horizontalSpace),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                videoBloc.add(CancelUploadVideoEvent(taskId: taskId));
              },
              child: const Icon(Icons.cancel),
            ),
          ),
        ],
      ),
    );
  }
}
