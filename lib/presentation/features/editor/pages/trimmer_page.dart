import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nice_shot/core/routes/routes.dart';
import 'package:nice_shot/data/model/flag_model.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:video_trimmer/video_trimmer.dart';
import '../../../../core/functions/functions.dart';
import '../../../../core/util/boxes.dart';
import '../../../../data/model/video_model.dart';
import '../../../widgets/loading_widget.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/session_state.dart';

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
  bool doMute = false;

  @override
  void initState() {
    startValue = widget.flag.startDuration!.inSeconds.toDouble();
    trimmer.loadVideo(videoFile: widget.file);
    endTemp = widget.flag.endDuration!.inSeconds.toDouble();

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
                        "the default start is the ${startValue.toInt()}th second and the end is the  ${endTemp.toInt()}th second\n "
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
                                            ? startValue.toInt()
                                            : StartCurrentValue <
                                                    (EndCurrentValue == 0
                                                        ? endTemp
                                                        : EndCurrentValue)
                                                ? StartCurrentValue
                                                : EndCurrentValue - 1),
                                        minValue: startValue.toInt(),
                                        maxValue: (endTemp.toInt()) - 1,
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
                                                ? endTemp.toInt()
                                                : endValue.toInt())
                                            : (EndCurrentValue),
                                        minValue: (startValue.toInt()) + 1,
                                        maxValue: endValue == 0
                                            ? endTemp.toInt()
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
                                      doMute = true;
                                      showNumberPickerDialog = false;
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
                color: !isLoading || startValue.toInt() - endTemp.toInt() >= 1
                    ? Colors.white
                    : Colors.white60,
              ),
              onPressed: !isLoading
                  ? () async {
                int startMute=0;
                int endMute=0;
                if(endTemp.toInt()-startValue.toInt()>=1) {
                  isLoading = true;
                  setState(() {});
                  if(StartCurrentValue==0){
                    startMute=0;
                  }else{
                    startMute=StartCurrentValue-startValue.toInt();
                  }
                  if(EndCurrentValue==0){
                    endMute=endTemp.toInt()-startValue.toInt();
                  }else{
                    //endMute=EndCurrentValue-(EndCurrentValue-startValue.toInt());
                    endMute=EndCurrentValue-startValue.toInt();
                  }
                  await trimmer.saveTrimmedVideo(
                    ffmpegCommand: doMute
                        ? "-af \"volume=enable='between(t,$startMute,$endMute)':volume=0\" -q:v 4 -q:a 4 "
                        : null,
                    customVideoFormat: doMute ? ".mp4" : null,
                    startValue: startValue * 1000,
                    endValue: endTemp * 1000,
                    onSave: (String? outputPath) async {
                   print(startMute);
                   print(endMute);
                   print("sdfsdf");
                      Directory d = await getExternalStoragePath();
                      String title = widget.flag.title != null
                          ? "${DateTime
                          .now()
                          .microsecondsSinceEpoch}_${widget.flag.title}"
                          : DateTime
                          .now()
                          .microsecondsSinceEpoch
                          .toString();
                      File finalOutputPath = File("${d.path}/$title.mp4");
                      String command =
                          '-i ${outputPath
                          .toString()} -i $logoPath -filter_complex overlay=10:10 -codec:a copy -q:v 4 -q:a 4 ${finalOutputPath
                          .path}';
                      FFmpegKit.executeAsync(command, (session) async {
                        SessionState state = await session.getState();
                        if (state == SessionState.completed) {
                          File(outputPath.toString()).deleteSync();
                          VideoModel videoModel = VideoModel(
                            id: widget.flag.id,
                            path: finalOutputPath.path,
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
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              Routes.homePage,
                                  (route) => false,
                            );
                          });
                        } else {
                          if (mounted) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("something went wrong"),
                            ));
                          }
                        }
                      });
                    },
                  );
                }else{
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(
                    backgroundColor: Colors.white,
                    content: Text(
                      "choose a valid trimming area please",
                      style: TextStyle(color: Colors.black),
                    ),
                  ));
                }
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
                          startValue = (value / 1000);
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
                                  if (endTemp.toInt() - startValue.toInt() >=
                                      1) {
                                    showNumberPickerDialog = true;
                                    await trimmer.videoPlayerController!
                                        .pause();
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      backgroundColor: Colors.white,
                                      content: Text(
                                          "choose a valid trimming area please",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ));
                                  }
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
                                  ? (startValue)
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
