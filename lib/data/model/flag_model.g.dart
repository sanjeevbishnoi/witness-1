import 'package:hive_flutter/adapters.dart';
import 'flag_model.dart';

class FlagModelAdapter extends TypeAdapter<FlagModel> {
  @override
  final int typeId = 1;

  @override
  FlagModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FlagModel(
      id: fields[0] as String?,
      title: fields[1] as String?,
      path: fields[2] as String?,
      time: fields[3] as String?,
      isLike: fields[4] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, FlagModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.path)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..write(obj.isLike);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlagModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
