import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nice_shot/core/routes/routes.dart';
import 'package:nice_shot/data/model/flag_model.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:video_trimmer/video_trimmer.dart';
import '../../../../core/functions/functions.dart';
import '../../../../core/util/boxes.dart';
import '../../../../data/model/video_model.dart';
import '../../../widgets/loading_widget.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';

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
  int StartCurrentValue = 0;
  int EndCurrentValue = 0;
  int userClicks = 0;
  int pausedValue = 0;
  bool isLoading = false;

  bool showNumberPickerDialog = false;

  @override
  void initState() {
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (showNumberPickerDialog) {
        showDialog(
            context: context,
            builder: (context) {
              return WillPopScope(
                onWillPop: () async {
                  showNumberPickerDialog = false;
                  StartCurrentValue = 0;
                  EndCurrentValue = 0;
                  return true;
                },
                child: StatefulBuilder(
                  builder: (BuildContext context,
                      void Function(void Function()) setState) {
                    return AlertDialog(
                      title: const Text("select start & end point to mute"),
                      content: Text(
                        "the default start is the ${startValue ~/ 1000}th second and the end is the  ${endTemp ~/ 1000}th second\n "
                        "the numbers interval are chosen from the video tag not the whole video ",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      actions: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    const Text("Start"),
                                    NumberPicker(
                                        infiniteLoop: true,
                                        itemCount: 3,
                                        value: (StartCurrentValue == 0
                                            ? startValue ~/ 1000
                                            : StartCurrentValue <
                                                    (EndCurrentValue == 0
                                                        ? endTemp ~/ 1000
                                                        : EndCurrentValue)
                                                ? StartCurrentValue
                                                : EndCurrentValue - 1),
                                        minValue: startValue ~/ 1000,
                                        maxValue: (endTemp ~/ 1000) - 1,
                                        onChanged: (value) {
                                          setState(() {
                                            StartCurrentValue = value;
                                          });
                                        }),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text("End"),
                                    NumberPicker(
                                        infiniteLoop: true,
                                        itemCount: 3,
                                        value: EndCurrentValue == 0
                                            ? (endValue == 0
                                                ? endTemp ~/ 1000
                                                : endValue.toInt())
                                            : (EndCurrentValue),
                                        minValue: (startValue ~/ 1000) + 1,
                                        maxValue: endValue == 0
                                            ? endTemp ~/ 1000
                                            : endValue.toInt(),
                                        onChanged: (value) {
                                          setState(() {
                                            EndCurrentValue = value;
                                          });
                                        }),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("ok")),
                              ],
                            )
                          ],
                        )
                      ],
                    );
                  },
                ),
              );
            });
      }
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text("EDITOR"),
          actions: [
            IconButton(
              icon: Icon(
                Icons.save,
                color: !isLoading ? Colors.white : Colors.white60,
              ),
              onPressed: !isLoading
                  ? () async {
                      final valuee = await getPath();
                      isLoading = true;
                      setState(() {});
                      await trimmer.saveTrimmedVideo(
                        ffmpegCommand:
                            "-af \"volume=enable='between(t,${StartCurrentValue - startValue ~/ 1000},${EndCurrentValue - startValue ~/ 1000})':volume=0\" ",
                        customVideoFormat: ".mp4",
                        startValue: startValue,
                        endValue: endValue == 0 ? endTemp : endValue,
                        onSave: (String? outputPath) async {
                          final file = File(outputPath.toString());
                          String title = widget.flag.title != null
                              ? "${DateTime.now().microsecondsSinceEpoch}_${widget.flag.title}"
                              : DateTime.now()
                                  .microsecondsSinceEpoch
                                  .toString();
                          String newPath = "${valuee.path}/$title.mp4";
                          await file.copy(newPath);
                          File(file.path).deleteSync();
                          print("ThE KING");
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
                            widget.data
                              ..flags![widget.flagIndex].isExtracted = true,
                          )
                              .then((value) {
                            File outputPath = File('${valuee.path}/$title.mp4');
                            String command =
                                '-i $newPath -i $logoPath -filter_complex overlay=10:10 -codec:a copy ${outputPath.path}';
                            file.create(recursive: true).then((value) {
                              FFmpegKit.executeAsync(command)
                                  .then((session) async {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  Routes.homePage,
                                  (route) => false,
                                );
                              }).catchError((error) {});
                            }).catchError((onError) {
                              print(onError.toString());
                            });
                          });
                        },
                      );
                    }
                  : null,
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
                  Expanded(
                    child: TrimEditor(
                      trimmer: trimmer,
                      viewerWidth: MediaQuery.of(context).size.width,
                      onChangeStart: (value) {
                        setState(() {
                          startValue = value / 1000;
                        });
                      },
                      onChangeEnd: (value) {
                        setState(() {
                          endValue = value / 1000;
                          endTemp = endValue;
                          trimmer.videoPlayerController!
                              .seekTo(const Duration(seconds: 0));
                          pausedValue = trimmer.videoPlayerController!.value
                                  .position.inSeconds
                                  .toInt() -
                              1;
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
                  StatefulBuilder(
                    builder: (context, setInnerState) {
                      return isLoading
                          ? const LoadingWidget()
                          : Expanded(
                              child: InkWell(
                                onTap: () async {
                                  showNumberPickerDialog = true;
                                  await trimmer.videoPlayerController!.pause();
                                },
                                child: const Icon(
                                  Icons.music_off_rounded,
                                  color: Colors.yellow,
                                ),
                              ),
                            );
                    },
                  ),
                  Expanded(
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
                        int duration = trimmer
                            .videoPlayerController!.value.duration.inSeconds;
                        if (pausedValue != -1) {
                          pausedValue = trimmer
                              .videoPlayerController!.value.position.inSeconds;
                        }
                        bool playbackState = await trimmer.videPlaybackControl(
                          startValue: ((pausedValue == 0 ||
                                      pausedValue == endTemp ||
                                      pausedValue == endTemp - 1 ||
                                      pausedValue == -1)
                                  ? (startValue ~/ 1000)
                                  : (pausedValue)) *
                              1000,
                          endValue: endValue,
                        );
                        setState(() {
                          _isPlaying = playbackState;
                          pausedValue = trimmer
                              .videoPlayerController!.value.position.inSeconds;
                        });
                      },
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
