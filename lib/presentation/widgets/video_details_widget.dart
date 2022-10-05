import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';

VideoData? _videoData;

class VideoDetailsWidget extends StatelessWidget {
  final String videoPath;
  final String title;

  const VideoDetailsWidget({
    Key? key,
    required this.videoPath,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: videoInfo(),
      builder: (context, snapshot) {
        return AlertDialog(
          title: Text(title),
          content: snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Row(
                      children: [
                        const Text("Capture in"),
                        Text(_videoData?.date ?? ""),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Size"),
                        Text(_videoData?.filesize.toString() ?? ""),
                      ],
                    ),
                  ],
                ),
        );
      },
    );
  }

  Future videoInfo() async {
    _videoData = await FlutterVideoInfo().getVideoInfo(videoPath);
  }
}
