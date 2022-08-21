import 'package:hive_flutter/adapters.dart';
import 'package:nice_shot/data/model/flag_model.dart';
import 'package:nice_shot/data/model/video_model.dart';

class VideoModelAdapter extends TypeAdapter<VideoModel> {
  @override
  final int typeId = 0;

  @override
  VideoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoModel(
      id: fields[0] as String?,
      title: fields[1] as String?,
      path: fields[2] as String?,
      dateTime: fields[3] as DateTime?,
      timeVideo: fields[4] as String?,
      flags: fields[5] as List<dynamic>,
    );
  }

  @override
  void write(BinaryWriter writer, VideoModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.path)
      ..writeByte(3)
      ..write(obj.dateTime)
      ..writeByte(4)
      ..write(obj.timeVideo)
      ..writeByte(5)
      ..write(obj.flags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
