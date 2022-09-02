import 'package:flutter/material.dart';
import 'package:video_trimmer/video_trimmer.dart';

import '../../../../core/themes/app_theme.dart';
import '../bloc/trimmer_bloc.dart';

class TrimEditorWidget extends StatelessWidget {
  final TrimmerBloc bloc;
  final Trimmer trimmer;

  const TrimEditorWidget({
    Key? key,
    required this.bloc,
    required this.trimmer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TrimEditor(
      trimmer: trimmer,
      borderPaintColor: MyColors.primaryColor,
      circlePaintColor: MyColors.primaryColor,
      viewerWidth: MediaQuery.of(context).size.width,
      onChangeStart: (value) {
        bloc.startValue = value;
      },
      onChangeEnd: (value) {
        bloc.endValue = value;
      },
      onChangePlaybackState: (value) {},
    );
  }
}
