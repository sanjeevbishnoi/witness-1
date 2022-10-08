import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:nice_shot/core/util/global_variables.dart';
import 'package:nice_shot/core/themes/app_theme.dart';
import 'package:nice_shot/core/util/my_box_decoration.dart';
import 'package:nice_shot/data/model/api/video_model.dart' as video;
import 'package:nice_shot/presentation/widgets/error_widget.dart';
import 'package:nice_shot/presentation/widgets/slidable_action_widget.dart';
import 'package:nice_shot/presentation/widgets/video_details_widget.dart';
import '../../../../core/util/boxes.dart';
import '../../../../core/util/enums.dart';
import '../../../../core/util/my_alert_dialog.dart';
import '../../../../data/model/video_model.dart';
import 'package:share/share.dart';

import '../../video_player/video_player_page.dart';
import '../bloc/edited_video_bloc.dart';

class EditedVideoPage extends StatelessWidget {
  const EditedVideoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(MySizes.widgetSideSpace),
      child: ValueListenableBuilder(
        valueListenable: Boxes.exportedVideoBox.listenable(),
        builder: (context, Box<VideoModel> items, _) {
          List<int> keys = items.keys.cast<int>().toList();

          return items.length > 0
              ? ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    height: MySizes.verticalSpace,
                  ),
                  itemCount: keys.length,
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (_, index) {
                    final int key = keys[index];

                    final VideoModel data = items.get(key)!;
                    final String time =
                        DateFormat().add_jm().format(data.dateTime!);
                    final String date =
                        DateFormat().add_yMEd().format(data.dateTime!);
                    // String minutes = strDigits(
                    //   data.videoDuration!.inMinutes.remainder(60),
                    // );
                    // String seconds = strDigits(
                    //   data.videoDuration!.inSeconds.remainder(60),
                    // );
                    return Slidable(
                      closeOnScroll: true,
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableActionWidget(
                            color: Colors.teal,
                            context: context,
                            function: () async {
                              await Share.shareFiles([data.path!],
                                  text: data.title);
                            },
                            icon: Icons.share,
                          ),
                          SlidableActionWidget(
                            color: Colors.blueAccent,
                            context: context,
                            function: () async {
                              myAlertDialog(
                                controller: controller,
                                context: context,
                                function: () async {
                                  if (controller.text.isNotEmpty) {
                                    await items
                                        .putAt(
                                      index,
                                      data..title = controller.text,
                                    )
                                        .then(
                                      (value) {
                                        Navigator.pop(context);
                                      },
                                    );
                                  }
                                },
                              );
                            },
                            icon: Icons.edit,
                          ),
                          SlidableActionWidget(
                            color: MyColors.primaryColor,
                            context: context,
                            function: () async {
                              // showDialog(
                              //   context: context,
                              //   builder: (context) => VideoDetailsWidget(
                              //     videoPath: data.path!,
                              //     title: data.title ?? "No title",
                              //
                              //   ),
                              // );
                              await File(data.path!).delete();
                              items.deleteAt(index);
                            },
                            icon: Icons.delete,
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return VideoPlayerPage(path: data.path);
                            },
                          ));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(
                            MySizes.widgetSideSpace / 2,
                          ),
                          height: 120.0,
                          decoration: myBoxDecoration,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      height: double.infinity,
                                      width: double.infinity,
                                      decoration: myBoxDecoration,
                                      child: data.videoThumbnail != null
                                          ? Image.file(
                                              File(data.videoThumbnail!),
                                              fit: BoxFit.cover,
                                            )
                                          : const SizedBox(),
                                    ),
                                    Icon(
                                      Icons.play_arrow,
                                      color: Colors.white.withOpacity(0.8),
                                      size: 64.0,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: MySizes.widgetSideSpace,
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        data.title ?? "No title",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "$date At $time",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ),
                                    const SizedBox(
                                        height: MySizes.verticalSpace),
                                    BlocConsumer<EditedVideoBloc,
                                        EditedVideoState>(
                                      listener: (context, state) {},
                                      builder: (context, state) {
                                        switch (state.uploadingState) {
                                          case RequestState.loading:
                                            int progress = state.progressValue!;
                                            if (state.index == index) {
                                              return Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      flex: 3,
                                                      child:
                                                          LinearProgressIndicator(
                                                        color: MyColors
                                                            .primaryColor,
                                                        value: progress
                                                                .toDouble() /
                                                            100,
                                                        backgroundColor: Colors
                                                            .grey.shade100,
                                                            minHeight: 10.0,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: MySizes
                                                          .horizontalSpace,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        "$progress%",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: MySizes
                                                          .horizontalSpace,
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: InkWell(
                                                        onTap: () {
                                                          context
                                                              .read<
                                                                  EditedVideoBloc>()
                                                              .add(
                                                                CancelUploadVideoEvent(
                                                                  taskId: state
                                                                      .taskId!,
                                                                ),
                                                              );
                                                        },
                                                        child:const Icon(Icons.cancel),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                            return Align(
                                              alignment: Alignment.bottomRight,
                                              child: InkWell(
                                                onTap: () {
                                                  context
                                                      .read<EditedVideoBloc>()
                                                      .add(UploadVideoEvent(
                                                    index: index,
                                                    video: video.VideoModel(
                                                      categoryId: "1",
                                                      name: data.title ??
                                                          "No title",
                                                      userId: userId,
                                                      file:
                                                      File(data.path!),
                                                    ),
                                                  ));
                                                },
                                                child: Container(
                                                  decoration: myBoxDecoration,
                                                  padding:
                                                  const EdgeInsets.all(4.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: const [
                                                      Icon(Icons.upload),
                                                      Text(
                                                        "UPLOAD",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                            default:
                                            return Align(
                                              alignment: Alignment.bottomRight,
                                              child: InkWell(
                                                onTap: () {
                                                  context
                                                      .read<EditedVideoBloc>()
                                                      .add(UploadVideoEvent(
                                                        index: index,
                                                        video: video.VideoModel(
                                                          categoryId: "1",
                                                          name: data.title ??
                                                              "No title",
                                                          userId: userId,
                                                          file:
                                                              File(data.path!),
                                                        ),
                                                      ));
                                                },
                                                child: Container(
                                                  decoration: myBoxDecoration,
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: const [
                                                      Icon(Icons.upload),
                                                      Text(
                                                        "UPLOAD",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: ErrorMessageWidget(
                  message: "You have not edited any video yet!",
                ));
        },
      ),
    );
  }
}
