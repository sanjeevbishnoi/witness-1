import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:nice_shot/core/themes/app_theme.dart';
import 'package:nice_shot/core/util/my_alert_dialog.dart';
import 'package:nice_shot/core/util/my_box_decoration.dart';
import 'package:nice_shot/presentation/widgets/slidable_action_widget.dart';
import '../../../core/functions/functions.dart';
import '../../../core/util/boxes.dart';
import '../../../data/model/video_model.dart';
import '../flags/pages/flags_by_video.dart';

class VideosPage extends StatelessWidget {
  const VideosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(MySizes.widgetSidePadding),
      child: ValueListenableBuilder(
        valueListenable: Boxes.videoBox.listenable(),
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
              List duration = data.videoDuration!.split(":");
              final videoDuration = Duration(
                seconds: int.parse(duration.last.toString().split(".").first),
                minutes: int.parse(duration[1]),
                hours: int.parse(duration.first),
              );
              if (File(data.path!).existsSync() == true) {
                String minutes = strDigits(
                  videoDuration.inMinutes.remainder(60),
                );
                String seconds = strDigits(
                  videoDuration.inSeconds.remainder(60),
                );
                return Slidable(
                  closeOnScroll: true,
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableActionWidget(
                        color: MyColors.primaryColor,
                        context: context,
                        function: () async {
                          await File(data.path!).delete();
                          items.deleteAt(index);
                        },
                        icon: Icons.delete,
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
                                      (value) => Navigator.pop(context),
                                    );
                              }
                            },
                          );
                        },
                        icon: Icons.edit,
                      ),
                    ],
                  ),
                  child: Container(
                    height: 130,
                    padding: const EdgeInsets.all(
                      MySizes.widgetSidePadding / 2,
                    ),
                    decoration: myBoxDecoration,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FlagsByVideoPage(
                              flags: data.flags ?? [],
                              path: data.path ?? "",
                              data: data,
                              videoIndex: index,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                decoration: myBoxDecoration,
                                child: data.videoThumbnail != null
                                    ? Image.file(
                                        File(data.videoThumbnail!),
                                        width: 110,
                                        height: double.infinity,
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
                          const SizedBox(
                            width: MySizes.widgetSidePadding,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.title ?? "No title",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                "${data.flags!.length} FLAGS",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                "$date At $time",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  decoration: myBoxDecoration,
                                  padding: const EdgeInsets.all(4.0),
                                  width: 200.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          );
        },
      ),
    );
  }
}
