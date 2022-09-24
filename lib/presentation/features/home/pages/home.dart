import 'package:flutter/material.dart';
import 'package:nice_shot/core/global_variables.dart';
import 'package:nice_shot/core/routes/routes.dart';
import 'package:nice_shot/core/themes/app_theme.dart';
import 'package:nice_shot/presentation/features/raw_videos/videos_page.dart';
import 'package:nice_shot/presentation/widgets/snack_bar_widget.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../edited_videos/edited_videos_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text("WITNESS"),
              // const Spacer(),
              // CircleAvatar(
              //   radius: 15.0,
              //   backgroundImage:currentUserData!.user?.logoUrl != null?
              //   NetworkImage("${currentUserData!.user!.logoUrl}"):
              //   const NetworkImage("https://ernglobal.org/wp-content/uploads/2017/10/default-user-image.png"),
              // ),
            ],
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Edited Videos"),
              Tab(text: "Raw Videos"),
            ],
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            physics: BouncingScrollPhysics(),
          ),
        ),
        body: const TabBarView(
          physics: BouncingScrollPhysics(),
          children: [
            EditedVideoPage(),
            VideosPage(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 5.0,
          onPressed: () async {
            if (permissionsGranted) {
              Navigator.pushNamed(context, Routes.cameraPage);
            }else {
              ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
              message: "Required permissions were not granted!, Open settings and give permissions.",
              label: "SETTINGS",
              onPressed: () => openAppSettings(),
            ));
            }
          },
          backgroundColor: MyColors.primaryColor,
          child: const Icon(Icons.video_call),
        ),
      ),
    );
  }
}
