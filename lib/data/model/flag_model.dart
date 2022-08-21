import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class FlagModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? path;
  @HiveField(3)
  String? time;
  @HiveField(4)
  bool? isLike;

  FlagModel({
     this.id,
     this.title,
     this.path,
     this.time,
     this.isLike,
  });
}
