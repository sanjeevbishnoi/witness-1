import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nice_shot/core/routes/routes.dart';
import 'package:nice_shot/data/model/flag_model.dart';
import 'package:video_trimmer/video_trimmer.dart';

import '../../../../core/functions/functions.dart';
import '../../../../core/util/boxes.dart';
import '../../../../data/model/video_model.dart';

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
  double endTemp = 0;

  @override
  void initState() {
    print("path: ${widget.file.path}");
    startValue = widget.flag.startDuration!.inSeconds.toDouble() * 1000;
    trimmer.loadVideo(videoFile: widget.file);
    endTemp = widget.flag.endDuration!.inSeconds.toDouble() * 1000;
    super.initState();
  }

  @override
  void dispose() {
    trimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text("EDITOR"),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.save,
                color: Colors.white,
              ),
              onPressed: () async {
                await trimmer.saveTrimmedVideo(
                  startValue: startValue,
                  endValue: endValue == 0 ? endTemp : endValue,
                  videoFileName: widget.flag.title,
                  videoFolderName: "edited_videos",
                  onSave: (String? outputPath) async {
                    final value = await getPath();
                    final file = File(outputPath!);
                    String newPath =
                        "${value.path}/${DateTime.now().microsecondsSinceEpoch}.mp4";
                    await file.copy(newPath);
                    File(file.path).deleteSync();

                    VideoModel videoModel = VideoModel(
                      id: widget.flag.id,
                      path: newPath,
                      title: widget.flag.title,
                      dateTime: DateTime.now(),
                      videoThumbnail: widget.data.videoThumbnail!,
                      videoDuration: widget.data.videoDuration!,
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
                  Expanded(
                    flex: 6,
                    child: Container(
                      color: Colors.black,
                      child: VideoViewer(trimmer: trimmer),
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    child: TrimEditor(
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
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Align(
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
                          bool playbackState =
                              await trimmer.videPlaybackControl(
                            startValue: startValue,
                            endValue: endValue,
                          );
                          setState(() {
                            _isPlaying = playbackState;
                          });
                        },
                      ),
                    ),
                  )
                ],
              )
            : const Center(
                child: Text("Unknown video"),
              ),
      ),
    );
  }
}
