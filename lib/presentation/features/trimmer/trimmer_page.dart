import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nice_shot/core/themes/app_theme.dart';
import 'package:nice_shot/presentation/widgets/loading_widget.dart';
import 'package:video_trimmer/video_trimmer.dart';

import 'bloc/trimmer_bloc.dart';

class TrimmerPage extends StatelessWidget {
  final File file;

  const TrimmerPage({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: Builder(builder: (context) {
          context.read<TrimmerBloc>().add(InitTrimmerEvent(file: file));
          return BlocConsumer<TrimmerBloc, TrimmerState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              if (state is InitTrimmerState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Stack(
                      children: [
                        VideoViewer(trimmer: state.trimmer),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.save,color: Colors.white),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    TrimEditor(
                      trimmer: state.trimmer,
                      borderPaintColor: MyColors.primaryColor,
                      circlePaintColor: MyColors.primaryColor,
                      viewerWidth: MediaQuery.of(context).size.width,
                      onChangeStart: (value) {
                        context.read<TrimmerBloc>().startValue = value;
                      },
                      onChangeEnd: (value) {
                        context.read<TrimmerBloc>().endValue = value;
                      },
                      onChangePlaybackState: (value) {},
                    ),
                  ],
                );
              }
              return const LoadingWidget();
            },
          );
        }),
      ),
    );
  }

}
