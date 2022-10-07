import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nice_shot/core/util/global_variables.dart';
import 'package:nice_shot/core/routes/routes.dart';
import 'package:nice_shot/core/themes/app_theme.dart';
import 'package:nice_shot/presentation/features/edited_videos/pages/uploaded_edited_videos_page.dart';
import 'package:nice_shot/presentation/features/main_layout/bloc/main_layout_bloc.dart';
import 'package:nice_shot/presentation/features/profile/bloc/user_bloc.dart';
import 'package:nice_shot/presentation/features/profile/bloc/user_bloc.dart';
import 'package:nice_shot/presentation/features/profile/pages/profile_page.dart';
import 'package:nice_shot/presentation/features/raw_videos/raw_videos_page.dart';
import 'package:nice_shot/presentation/features/settings/pages/settings.dart';
import 'package:nice_shot/presentation/widgets/snack_bar_widget.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/functions/functions.dart';
import '../../../../data/model/api/User_model.dart';
import '../../../icons/icons.dart';
import '../../edited_videos/pages/edited_videos_page.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainLayoutBloc, MainLayoutState>(
      builder: (BuildContext context, state) {
        MainLayoutBloc bloc = context.read<MainLayoutBloc>();
        return Scaffold(
          appBar: AppBar(
            title: Text(drawerTitles[bloc.currentIndex].toUpperCase()),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    UserModel? user = state.user?.data;
                    return DrawerHeader(
                      decoration:
                          const BoxDecoration(color: MyColors.primaryColor),
                      child:  Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                user?.logoUrl != null
                                    ? CircleAvatar(
                                        radius: 50.0,
                                        backgroundImage: NetworkImage(
                                          "${user!.logoUrl}",
                                        ),
                                      )
                                    : const CircleAvatar(
                                        radius: 50.0,
                                        backgroundImage: AssetImage(
                                          "assets/images/defaultImage.jpg",
                                        ),
                                      ),
                                const SizedBox(height: MySizes.horizontalSpace),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(user?.name??"loading..",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: MyColors.backgroundColor,
                                            ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.close, color: Colors.white),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: drawerTitles.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      tileColor: bloc.currentIndex == index
                          ? Colors.grey.shade200
                          : MyColors.scaffoldBackgroundColor,
                      leading: drawerIcons[index],
                      title: Text(drawerTitles[index]),
                      onTap: () {
                        Navigator.pop(context);
                        bloc.add(ChangeScaffoldBodyEvent(index));
                      },
                    );
                  },
                ),
                const SizedBox(height: MySizes.widgetSideSpace),
                Center(
                  child: TextButton(
                    onPressed: () => logOut(context: context),
                    child: const Text(
                      "LOGOUT",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            elevation: 5.0,
            onPressed: () async {
              if (permissionsGranted) {
                Navigator.pushNamed(context, Routes.cameraPage);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
                  message:
                      "Required permissions were not granted!, Open settings and give permissions.",
                  label: "SETTINGS",
                  onPressed: () => openAppSettings(),
                ));
              }
            },
            backgroundColor: MyColors.primaryColor,
            child: const Icon(Icons.camera_alt),
          ),
          body: pages[bloc.currentIndex],
        );
      },
    );
  }
}

List<Widget> pages = [
  const EditedVideoPage(),
  const RawVideosPage(),
  const UploadedEditedVideoPage(),
  const ProfilePage(),
  const SettingsPage(),
];
List<String> drawerTitles = [
  'Edited Videos',
  'Raw Videos',
  'Uploaded Videos',
  'Profile',
  'Settings',
];
List<Icon> drawerIcons = const [
  Icon(Icons.video_settings, color: Colors.black54),
  Icon(MyIcons.flag, color: Colors.black54),
  Icon(Icons.upload, color: Colors.black54),
  Icon(Icons.person, color: Colors.black54),
  Icon(Icons.settings, color: Colors.black54),
];
