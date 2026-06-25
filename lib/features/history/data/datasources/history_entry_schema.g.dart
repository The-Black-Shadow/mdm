// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_entry_schema.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoryEntrySchemaAdapter extends TypeAdapter<HistoryEntrySchema> {
  @override
  final typeId = 1;

  @override
  HistoryEntrySchema read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryEntrySchema(
      videoId: fields[0] as String,
      title: fields[1] as String,
      channelName: fields[2] as String,
      thumbnailUrl: fields[3] as String,
      filePath: fields[4] as String,
      fileSizeBytes: (fields[5] as num).toInt(),
      resolution: fields[6] as String,
      downloadedAt: fields[7] as DateTime,
      isFavorite: fields[8] == null ? false : fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HistoryEntrySchema obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.videoId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.channelName)
      ..writeByte(3)
      ..write(obj.thumbnailUrl)
      ..writeByte(4)
      ..write(obj.filePath)
      ..writeByte(5)
      ..write(obj.fileSizeBytes)
      ..writeByte(6)
      ..write(obj.resolution)
      ..writeByte(7)
      ..write(obj.downloadedAt)
      ..writeByte(8)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryEntrySchemaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
