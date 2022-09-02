import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:nice_shot/core/themes/app_theme.dart';
import 'package:nice_shot/core/util/my_box_decoration.dart';
import 'package:nice_shot/presentation/features/video/widgets/slidable_action_widget.dart';

import '../../../../core/util/boxes.dart';
import '../../../../data/model/video_model.dart';

class ExtractedVideoPage extends StatelessWidget {
  const ExtractedVideoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    subtitle: Text(
                      DateFormat().add_yMEd().format(data.dateTime!),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    onTap: () {},
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
