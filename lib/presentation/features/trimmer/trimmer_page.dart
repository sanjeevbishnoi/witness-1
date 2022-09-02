import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nice_shot/data/model/flag_model.dart';
import 'package:nice_shot/presentation/features/trimmer/widget/TrimEditorWidget.dart';
import 'package:nice_shot/presentation/widgets/loading_widget.dart';
import 'package:video_trimmer/video_trimmer.dart';

import 'bloc/trimmer_bloc.dart';

class TrimmerPage extends StatelessWidget {
  final File file;
  final FlagModel flag;

  const TrimmerPage({
    Key? key,
    required this.file,
    required this.flag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: File(file.path).existsSync() == true
            ? Builder(builder: (context) {
                context.read<TrimmerBloc>().add(InitTrimmerEvent(file: file));
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Stack(
                      children: [
                        BlocBuilder<TrimmerBloc, TrimmerState>(
                          builder: (context, state) {
                            return state is InitTrimmerState
                                ? VideoViewer(trimmer: state.trimmer)
                                : const LoadingWidget();
                          },
                        ),
                        BlocBuilder<TrimmerBloc, TrimmerState>(
                          builder: (context, state) {
                            return Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.save,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  context.read<TrimmerBloc>().add(
                                        ExportVideoEvent(
                                          flagModel: flag,
                                        ),
                                      );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const Spacer(),
                    BlocBuilder<TrimmerBloc, TrimmerState>(
                      builder: (context, state) {
                        return state is InitTrimmerState
                            ? TrimEditorWidget(
                                bloc: context.read<TrimmerBloc>(),
                                trimmer: state.trimmer,
                              )
                            : Container();
                      },
                    ),
                  ],
                );
              })
            : const Center(
                child: Text("Unknown video "),
              ),
      ),
    );
  }
}
