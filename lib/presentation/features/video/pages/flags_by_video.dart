import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nice_shot/presentation/features/trimmer/trimmer_page.dart';
import '../../../../core/themes/app_theme.dart';
import '../../../../core/util/my_box_decoration.dart';
import '../../../widgets/app_bar_widget.dart';
import '../widgets/slidable_action_widget.dart';

// ignore: must_be_immutable
class FlagsByVideoPage extends StatelessWidget {
  final List<dynamic> flags;
  final String path;

  FlagsByVideoPage({Key? key,required this.flags,required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        title: 'flags',
      ),
      body: Padding(
        padding: const EdgeInsets.all(MySizes.widgetSidePadding),
        child: flags.isNotEmpty
            ? ListView.separated(
                itemCount: flags.length,
                itemBuilder: (context, index) {
                  String time = flags[index].time!;
                  Duration duration = Duration(
                    minutes: int.parse(time.split(":").first),
                    seconds: int.parse(time.split(":").last),
                  );
                  String strDigits(int n) => n.toString().padLeft(2, '0');
                  Duration start = duration -
                      Duration(
                        seconds: duration >= const Duration(seconds: 5)
                            ? 5
                            : duration.inSeconds,
                        minutes: 0,
                      );
                  Duration end = duration +
                      Duration(
                          seconds: duration >= const Duration(seconds: 10)
                              ? 5
                              : duration.inSeconds,
                          minutes: 0);
                  var startMinute = strDigits(start.inMinutes.remainder(60));
                  var startSecond = strDigits(start.inSeconds.remainder(60));
                  var endMinute = strDigits(end.inMinutes.remainder(60));
                  var endSecond = strDigits(end.inSeconds.remainder(60));

                  return Slidable(
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableActionWidget(
                          color: Colors.blueAccent,
                          context: context,
                          function: () async {},
                          icon: Icons.edit,
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: myBoxDecoration,
                      child: ListTile(
                        leading: Text("${index + 1}"),
                        title: Text(
                          flags[index].title ?? "No title",
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              "STR: $startMinute:$startSecond - END: $endMinute:$endSecond",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const Spacer(),
                            const Icon(Icons.cut, color: MyColors.primaryColor),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return TrimmerPage(
                                  file: File(path),
                                  flag: flags[index],
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
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
    );
  }
}
