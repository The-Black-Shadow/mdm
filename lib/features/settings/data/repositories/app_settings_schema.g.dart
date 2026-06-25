// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_schema.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppSettingsSchemaAdapter extends TypeAdapter<AppSettingsSchema> {
  @override
  final typeId = 2;

  @override
  AppSettingsSchema read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettingsSchema(
      defaultVideoQuality: fields[0] == null ? '720p' : fields[0] as String,
      defaultAudioQuality: fields[1] == null ? '128kbps' : fields[1] as String,
      downloadFolderPath: fields[2] == null ? '' : fields[2] as String,
      simultaneousDownloads: fields[3] == null ? 2 : (fields[3] as num).toInt(),
      wifiOnly: fields[4] == null ? false : fields[4] as bool,
      autoMerge: fields[5] == null ? true : fields[5] as bool,
      showProgressNotification: fields[6] == null ? true : fields[6] as bool,
      notifyOnComplete: fields[7] == null ? true : fields[7] as bool,
      notifyOnFailure: fields[8] == null ? true : fields[8] as bool,
      themeMode: fields[9] == null ? 'system' : fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettingsSchema obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.defaultVideoQuality)
      ..writeByte(1)
      ..write(obj.defaultAudioQuality)
      ..writeByte(2)
      ..write(obj.downloadFolderPath)
      ..writeByte(3)
      ..write(obj.simultaneousDownloads)
      ..writeByte(4)
      ..write(obj.wifiOnly)
      ..writeByte(5)
      ..write(obj.autoMerge)
      ..writeByte(6)
      ..write(obj.showProgressNotification)
      ..writeByte(7)
      ..write(obj.notifyOnComplete)
      ..writeByte(8)
      ..write(obj.notifyOnFailure)
      ..writeByte(9)
      ..write(obj.themeMode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsSchemaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
