// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_task_schema.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadTaskSchemaAdapter extends TypeAdapter<DownloadTaskSchema> {
  @override
  final typeId = 0;

  @override
  DownloadTaskSchema read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadTaskSchema(
      id: fields[0] as String,
      videoId: fields[1] as String,
      title: fields[2] as String,
      thumbnailUrl: fields[3] as String,
      videoUrl: fields[4] as String,
      audioUrl: fields[5] as String?,
      outputPath: fields[6] as String,
      statusIndex: (fields[7] as num).toInt(),
      progress: fields[8] == null ? 0.0 : (fields[8] as num).toDouble(),
      errorMessage: fields[9] as String?,
      streamItag: (fields[10] as num).toInt(),
      streamType: fields[11] as String,
      streamResolution: fields[12] as String?,
      streamCodec: fields[13] as String,
      streamContainer: fields[14] as String,
      streamBitrate: (fields[15] as num?)?.toInt(),
      streamRequiresMerge: fields[16] as bool,
      createdAt: fields[17] as DateTime,
      completedAt: fields[18] as DateTime?,
      estimatedSizeBytes: (fields[19] as num?)?.toInt(),
      extractAudio: fields[20] == null ? false : fields[20] as bool,
      channelName: fields[21] == null
          ? 'Unknown Channel'
          : fields[21] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadTaskSchema obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.videoId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.thumbnailUrl)
      ..writeByte(4)
      ..write(obj.videoUrl)
      ..writeByte(5)
      ..write(obj.audioUrl)
      ..writeByte(6)
      ..write(obj.outputPath)
      ..writeByte(7)
      ..write(obj.statusIndex)
      ..writeByte(8)
      ..write(obj.progress)
      ..writeByte(9)
      ..write(obj.errorMessage)
      ..writeByte(10)
      ..write(obj.streamItag)
      ..writeByte(11)
      ..write(obj.streamType)
      ..writeByte(12)
      ..write(obj.streamResolution)
      ..writeByte(13)
      ..write(obj.streamCodec)
      ..writeByte(14)
      ..write(obj.streamContainer)
      ..writeByte(15)
      ..write(obj.streamBitrate)
      ..writeByte(16)
      ..write(obj.streamRequiresMerge)
      ..writeByte(17)
      ..write(obj.createdAt)
      ..writeByte(18)
      ..write(obj.completedAt)
      ..writeByte(19)
      ..write(obj.estimatedSizeBytes)
      ..writeByte(20)
      ..write(obj.extractAudio)
      ..writeByte(21)
      ..write(obj.channelName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadTaskSchemaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
