// >>> AppSettingsSchema =======================
// Hive persistence schema for app settings (typeId: 2)
import 'package:hive_ce/hive_ce.dart';

part 'app_settings_schema.g.dart';

@HiveType(typeId: 2)
class AppSettingsSchema extends HiveObject {
  @HiveField(0)
  String defaultVideoQuality;

  @HiveField(1)
  String defaultAudioQuality;

  @HiveField(2)
  String downloadFolderPath;

  @HiveField(3)
  int simultaneousDownloads;

  @HiveField(4)
  bool wifiOnly;

  @HiveField(5)
  bool autoMerge;

  @HiveField(6)
  bool showProgressNotification;

  @HiveField(7)
  bool notifyOnComplete;

  @HiveField(8)
  bool notifyOnFailure;

  @HiveField(9)
  String themeMode;

  AppSettingsSchema({
    this.defaultVideoQuality = '720p',
    this.defaultAudioQuality = '128kbps',
    this.downloadFolderPath = '',
    this.simultaneousDownloads = 2,
    this.wifiOnly = false,
    this.autoMerge = true,
    this.showProgressNotification = true,
    this.notifyOnComplete = true,
    this.notifyOnFailure = true,
    this.themeMode = 'system',
  });
}
// <<< AppSettingsSchema =======================
