// >>> HiveModule =======================
// Initializes Hive CE, registers all adapters, and opens storage boxes
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:mdm/features/downloader/data/datasources/download_task_schema.dart';
import 'package:mdm/features/history/data/datasources/history_entry_schema.dart';
import 'package:mdm/features/settings/data/repositories/app_settings_schema.dart';
import 'package:mdm/core/utils/app_logger.dart';

class HiveModule {
  static const String downloadTaskBox = 'download_tasks';
  static const String historyBox = 'history';
  static const String settingsBox = 'app_settings';

  static Future<void> init() async {
    AppLogger.i('HiveModule: Initializing Hive...');

    await Hive.initFlutter();

    // Register type adapters
    Hive.registerAdapter(DownloadTaskSchemaAdapter());
    Hive.registerAdapter(HistoryEntrySchemaAdapter());
    Hive.registerAdapter(AppSettingsSchemaAdapter());

    // Open storage boxes
    await Hive.openBox<DownloadTaskSchema>(downloadTaskBox);
    await Hive.openBox<HistoryEntrySchema>(historyBox);
    await Hive.openBox<AppSettingsSchema>(settingsBox);

    AppLogger.i('HiveModule: Hive initialized with ${Hive.isBoxOpen(downloadTaskBox) ? 3 : 0} boxes');
  }
}
// <<< HiveModule =======================
