import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:nice_shot/core/themes/app_theme.dart';
import 'package:nice_shot/core/util/my_box_decoration.dart';
import 'package:nice_shot/presentation/features/video/pages/video_player_page.dart';
import 'package:nice_shot/presentation/widgets/slidable_action_widget.dart';
import 'package:nice_shot/presentation/widgets/snack_bar_widget.dart';

import '../../../../core/util/boxes.dart';
import '../../../../core/util/my_alert_dialog.dart';
import '../../../../data/model/video_model.dart';
import 'package:share/share.dart';

class ExtractedVideoPage extends StatelessWidget {
  const ExtractedVideoPage({Key? key}) : super(key: key);

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

              return Slidable(
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableActionWidget(
                      color: Colors.teal,
                      context: context,
                      function: () async {
                      await  Share.shareFiles([data.path!], text: data.title);
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
                child: Container(
                  padding: const EdgeInsets.all(MySizes.widgetSidePadding / 2),
                  decoration: myBoxDecoration,
                  child: ListTile(
                    leading: const Image(
                      image: AssetImage("assets/images/defaultVideoImage.png"),
                    ),
                    title: Text(
                      data.title ?? "No title",
                      style: const TextStyle(color: Colors.black),
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          DateFormat().add_yMEd().format(data.dateTime!),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const Spacer(),
                        InkWell(

                          onTap: () {},
                          child: const Icon(Icons.upload),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                       return VideoPlayerPage(videoModel:data);
                      },));
                    },
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
