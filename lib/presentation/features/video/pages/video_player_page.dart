import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';

import '../../../../data/model/video_model.dart';

class VideoPlayerPage extends StatefulWidget {
  final VideoModel videoModel;

  const VideoPlayerPage({Key? key, required this.videoModel}) : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  Future _initVideoPlayer() async {
    _videoPlayerController =
        VideoPlayerController.file(File(widget.videoModel.path!));
    await _videoPlayerController!.initialize();

    await _videoPlayerController!.setLooping(false);

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      looping: false,
      showControls: true,
      zoomAndPan: true,
      //  allowFullScreen: true,
      showControlsOnInitialize: true,
      //  progressIndicatorDelay: const Duration(),
      showOptions: true,
      //  materialProgressColors: ChewieProgressColors(playedColor: Colors.red),
       fullScreenByDefault: true,
      //  allowPlaybackSpeedChanging: true,
    );
    _videoPlayerController!.play();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        body: FutureBuilder(
          future: _initVideoPlayer(),
          builder: (context, state) {
            if (state.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Chewie(
                controller: _chewieController!,
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController!.dispose();
    _chewieController!.dispose();
    super.dispose();
  }
}
