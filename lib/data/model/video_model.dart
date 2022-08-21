import 'package:hive/hive.dart';

import 'flag_model.dart';

@HiveType(typeId: 0)
class VideoModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? path;
  @HiveField(3)
  DateTime? dateTime;
  @HiveField(4)
  String? timeVideo;
  @HiveField(5)
  List<dynamic> flags =[];

  VideoModel({
    this.id,
    this.path,
    this.title,
    this.dateTime,
    this.timeVideo,
    required this.flags,
  });
}
