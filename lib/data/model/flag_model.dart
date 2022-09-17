import 'data.dart';
import 'package:hive/hive.dart';
import 'package:nice_shot/data/model/data.dart';


part 'flag_model.g.dart';

@HiveType(typeId: 1)
class FlagModel extends DataModel {
  @HiveField(4)
  bool? isLike;
  @HiveField(5)
  bool? isExtracted;
  @HiveField(6)
  Duration? flagPoint;
  @HiveField(7)
  Duration? startDuration;
  @HiveField(8)
  Duration? endDuration;

  FlagModel({
    super.id,
    super.videoDuration,
    super.path,
    super.title,
    this.flagPoint,
    this.isLike,
    this.isExtracted,
    this.startDuration,
    this.endDuration,
  });
}
