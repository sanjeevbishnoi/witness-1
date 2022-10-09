import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:nice_shot/data/model/flag_model.dart';
import 'package:nice_shot/data/model/video_model.dart';

import '../../../../core/functions/functions.dart';
import '../../../../core/themes/app_theme.dart';
import '../../../../core/util/boxes.dart';
import '../../../../core/util/my_alert_dialog.dart';
import '../../../../core/util/my_box_decoration.dart';
import '../../../icons/icons.dart';
import '../../../widgets/slidable_action_widget.dart';
import '../../editor/pages/trimmer_page.dart';
import 'like_action.dart';

class FlagItemWidget extends StatelessWidget {
  final FlagModel flagModel;
  final VideoModel videoModel;
  final Box<VideoModel> items;
  final int flagIndex;
  final int videoIndex;

  const FlagItemWidget({
    Key? key,
    required this.flagModel,
    required this.videoModel,
    required this.items,
    required this.flagIndex,
    required this.videoIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    List flagPoint = flagModel.flagPoint!.split(":");
    Duration point = Duration(
      seconds: int.parse(flagPoint.last.toString().split(".").first),
      minutes: int.parse(flagPoint[1]),
      hours: int.parse(flagPoint.first),
    );
    List duration = videoModel.videoDuration!.split(":");
    final videoDuration = Duration(
      seconds: int.parse(duration.last.toString().split(".").first),
      minutes: int.parse(duration[1]),
      hours: int.parse(duration.first),
    );
    Duration start = point -
        Duration(
          seconds: point.inSeconds >= 10 ? 10 : point.inSeconds,
          minutes: 0,
        );
    Duration end = Duration(
      seconds: (point.inSeconds + 10) <= videoDuration.inSeconds
          ? point.inSeconds + 10
          : videoDuration.inSeconds,
      minutes: 0,
    );
    flagModel.startDuration = start;
    flagModel.endDuration = end;
    String startMinute = strDigits(
      flagModel.startDuration!.inMinutes.remainder(60),
    );
    String startSecond = strDigits(
      flagModel.startDuration!.inSeconds.remainder(60),
    );
    String endMinute = strDigits(
      flagModel.endDuration!.inMinutes.remainder(60),
    );
    String endSecond = strDigits(
      flagModel.endDuration!.inSeconds.remainder(60),
    );

    return Container(
      decoration: flagModel.isExtracted == true
          ? BoxDecoration(
              color: MyColors.backgroundColor,
              borderRadius: BorderRadius.circular(MySizes.radius),
              border: const Border.fromBorderSide(
                BorderSide(
                  color: Colors.green,
                  width: 0.5,
                ),
              ),
            )
          : myBoxDecoration,
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Text("${flagIndex + 1}"),
        title: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                flagModel.title ?? "No title",
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (flagModel.isExtracted == true)
              const Icon(
                Icons.check,
                color: Colors.green,
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "STR: $startMinute:$startSecond - END: $endMinute:$endSecond",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: MySizes.verticalSpace),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                LikeActionWidget(
                  icon: MyIcons.thumb_down,
                  isLike: flagModel.isLike,
                  value: false,
                  function: () {
                    items.putAt(
                      videoIndex,
                      videoModel
                        ..flags![flagIndex].isLike =
                            flagModel.isLike == null || flagModel.isLike == true
                                ? false
                                : null,
                    );
                  },
                ),
                const SizedBox(
                  width: MySizes.widgetSideSpace,
                ),
                LikeActionWidget(
                  icon: MyIcons.thumb_up,
                  isLike: flagModel.isLike,
                  value: true,
                  function: () {
                    items.putAt(
                      videoIndex,
                      videoModel
                        ..flags![flagIndex].isLike = flagModel.isLike == null ||
                                flagModel.isLike == false
                            ? true
                            : null,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return TrimmerPage(
                  file: File(videoModel.path!),
                  flag: flagModel,
                  data: videoModel,
                  items: items,
                  videoDuration: videoDuration,
                  videoIndex: videoIndex,
                  flagIndex: flagIndex,
                );
              },
            ),
          );
        },
        onLongPress: () {
          showModalBottomSheet(
            backgroundColor: Colors.white,
            elevation: 8,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10.0),
              ),
            ),
            builder: (context) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ActionWidget(
                    title: "Delete",
                    icon: Icons.delete_forever_rounded,
                    function: () async {
                      VideoModel video = videoModel..flags!.removeAt(flagIndex);
                      await items.deleteAt(videoIndex);
                      await Boxes.videoBox
                          .add(video)
                          .then((value) => Navigator.pop(context));
                    },
                  ),
                  ActionWidget(
                    title: "Edit title",
                    icon: Icons.edit,
                    function: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
            context: context,
          );
        },
      ),
    );
  }
}
