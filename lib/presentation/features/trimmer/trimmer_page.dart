import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nice_shot/core/routes/routes.dart';
import 'package:nice_shot/data/model/flag_model.dart';
import 'package:video_trimmer/video_trimmer.dart';

import '../../../core/util/boxes.dart';
import '../../../data/model/video_model.dart';

class TrimmerPage extends StatefulWidget {
  final File file;
  final FlagModel flag;
  final VideoModel data;
  final Box<VideoModel> items;
  final int flagIndex;
  final int videoIndex;
  final Duration videoDuration;

  const TrimmerPage({
    Key? key,
    required this.file,
    required this.flag,
    required this.data,
    required this.items,
    required this.flagIndex,
    required this.videoIndex,
    required this.videoDuration,
  }) : super(key: key);

  @override
  State<TrimmerPage> createState() => _TrimmerPageState();
}

class _TrimmerPageState extends State<TrimmerPage> {
  final Trimmer trimmer = Trimmer();
  double startValue = 0.0;
  double endValue = 0.0;
  bool _isPlaying = false;

  @override
  void initState() {
    startValue = widget.flag.startDuration!.inSeconds * 1000;
    trimmer.loadVideo(videoFile: widget.file);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          title: const Text("Editing"),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.save,
                color: Colors.white,
              ),
              onPressed: () async {
                await trimmer.saveTrimmedVideo(
                  startValue: startValue,
                  endValue: endValue,
                  videoFileName: widget.flag.title,
                  videoFolderName: "videos",
                  onSave: (String? outputPath) async {
                    print("path: $outputPath");
                    VideoModel videoModel = VideoModel(
                      id: widget.flag.id,
                      path: outputPath!,
                      title: widget.flag.title,
                      dateTime: DateTime.now(),
                    );
                    await Boxes.exportedVideoBox.add(videoModel);
                    widget.items
                        .putAt(
                      widget.videoIndex,
                      widget.data..flags![widget.flagIndex].isExtracted = true,
                    )
                        .then((value) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.homePage,
                        (route) => false,
                      );
                    });
                  },
                );
              },
            ),
          ],
        ),
        body: File(widget.file.path).existsSync() == true
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 600,
                        child: VideoViewer(trimmer: trimmer),
                      ),
                    ],
                  ),
                  const Spacer(),
                  TrimEditor(
                    trimmer: trimmer,
                    viewerWidth: MediaQuery.of(context).size.width,
                    onChangeStart: (value) {
                      setState(() {
                        startValue = value;
                      });
                    },
                    onChangeEnd: (value) {
                      setState(() {
                        endValue = value;
                      });
                    },
                    onChangePlaybackState: (value) {
                      setState(() {
                        _isPlaying = value;
                      });
                    },
                    flagModel: widget.flag,
                    videoDuration: widget.videoDuration,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton(
                      child: _isPlaying
                          ? const Icon(
                              Icons.pause,
                              size: 50.0,
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.play_arrow,
                              size: 50.0,
                              color: Colors.white,
                            ),
                      onPressed: () async {
                        bool playbackState = await trimmer.videPlaybackControl(
                          startValue: startValue,
                          endValue: endValue,
                        );
                        setState(() {
                          _isPlaying = playbackState;
                        });
                      },
                    ),
                  )
                ],
              )
            : const Center(
                child: Text("Unknown home"),
              ),
      ),
    );
  }
}
