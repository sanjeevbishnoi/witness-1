import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:nice_shot/core/global_variables.dart';
import 'package:nice_shot/core/themes/app_theme.dart';
import 'package:nice_shot/core/util/my_box_decoration.dart';
import 'package:nice_shot/data/model/api/video_model.dart' as video;
import 'package:nice_shot/core/util/enums.dart';
import 'package:nice_shot/presentation/widgets/slidable_action_widget.dart';
import 'package:nice_shot/presentation/widgets/snack_bar_widget.dart';
import '../../../core/functions/functions.dart';
import '../../../core/util/boxes.dart';
import '../../../core/util/my_alert_dialog.dart';
import '../../../data/model/video_model.dart';
import 'package:share/share.dart';

import '../video_player/video_player_page.dart';
import 'bloc/edited_video_bloc.dart';

class EditedVideoPage extends StatelessWidget {
  const EditedVideoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(MySizes.widgetSidePadding),
      child: ValueListenableBuilder(
        valueListenable: Boxes.exportedVideoBox.listenable(),
        builder: (context, Box<VideoModel> items, _) {
          List<int> keys = items.keys.cast<int>().toList();

          return ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(
              height: MySizes.verticalPadding,
            ),
            itemCount: keys.length,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (_, index) {
              final int key = keys[index];

              final VideoModel data = items.get(key)!;
              final String time = DateFormat().add_jm().format(data.dateTime!);
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
                        await Share.shareFiles([data.path!], text: data.title);
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
                        return VideoPlayerPage(videoModel: data);
                      },
                    ));
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.all(MySizes.widgetSidePadding / 2),
                    decoration: myBoxDecoration,
                    child: Row(
                      children: [
                        Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            Container(
                              decoration: myBoxDecoration,
                              child: data.videoThumbnail != null
                                  ? Image.file(
                                      File(data.videoThumbnail!),
                                      width: 90,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    )
                                  : const SizedBox(),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: MySizes.widgetSidePadding,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.title ?? "No title",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              "$date At $time",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: MySizes.verticalPadding),
                            BlocBuilder<EditedVideoBloc, EditedVideoState>(
                              builder: (context, state) {
                                if (state.requestState ==
                                    RequestState.loading) {
                                  return const LinearProgressIndicator(
                                    color: MyColors.primaryColor,
                                  );
                                } else if (state.requestState ==
                                    RequestState.error) {}
                                return Align(
                                  alignment: Alignment.bottomRight,
                                  child: InkWell(
                                    onTap: () {
                                      context
                                          .read<EditedVideoBloc>()
                                          .add(UploadVideoEvent(
                                            video: video.VideoModel(
                                              categoryId: "1",
                                              name: data.title,
                                              userId:
                                                  "${currentUserData!.user!.id}",
                                              file: File(data.path!),
                                            ),
                                          ));
                                    },
                                    child: Container(
                                      decoration: myBoxDecoration,
                                      padding: const EdgeInsets.all(4.0),
                                      child: const Icon(Icons.upload),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
