import 'package:hive/hive.dart';

class DurationAdapter extends TypeAdapter<Duration> {
  @override
  final int typeId = 2;

  @override
  Duration read(BinaryReader reader) {
    return const Duration();
  }

  @override
  void write(BinaryWriter writer, Duration obj) {}

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DurationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
