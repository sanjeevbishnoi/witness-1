import 'package:flutter/material.dart';
import 'package:nice_shot/core/routes/routes.dart';
import 'package:nice_shot/core/themes/app_theme.dart';
import 'package:nice_shot/presentation/features/video/pages/extracted_videos_page.dart';
import 'package:nice_shot/presentation/features/video/pages/videos_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("WITNESS"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "VIDEOS"),
              Tab(text: "RECORDS"),
            ],
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            physics: BouncingScrollPhysics(),
          ),
        ),
        body: const TabBarView(
          physics: BouncingScrollPhysics(),
          children: [
            ExtractedVideoPage(),
            VideosPage(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 5.0,
          onPressed: () async {
            Navigator.pushNamed(context, Routes.cameraPage);
          },
          backgroundColor: MyColors.primaryColor,
          child: const Icon(Icons.video_call),
        ),
      ),
    );
  }
}
