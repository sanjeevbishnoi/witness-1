import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nice_shot/core/util/boxes.dart';
import 'package:nice_shot/data/model/flag_model.dart';
import 'package:nice_shot/data/model/video_model.dart';
import '../../../../core/themes/app_theme.dart';
import '../../../widgets/app_bar_widget.dart';
import '../widgets/flag_item_widget.dart';

class FlagsByVideoPage extends StatelessWidget {
  final List<FlagModel> flags;
  final String path;
  final VideoModel data;
  final int videoIndex;

  const FlagsByVideoPage({
    Key? key,
    required this.flags,
    required this.path,
    required this.data,
    required this.videoIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        title: 'flags',
      ),
      body: ValueListenableBuilder(
        valueListenable: Boxes.videoBox.listenable(),
        builder: (context, Box<VideoModel> items, _) => Padding(
          padding: const EdgeInsets.all(MySizes.widgetSidePadding),
          child: flags.isNotEmpty
              ? ListView.separated(
                  itemCount: flags.length,
                  itemBuilder: (context, index) {
                    return FlagItemWidget(
                      flagIndex: index,
                      videoIndex: videoIndex,
                      flagModel: flags[index],
                      items: items,
                      videoModel: data,
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    height: MySizes.verticalPadding,
                  ),
                )
              : const Center(
                  child: Text("No flags"),
                ),
        ),
      ),
    );
  }
}
