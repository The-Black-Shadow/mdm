// >>> HistoryLocalSource =======================
import 'package:hive_ce/hive_ce.dart';
import 'package:injectable/injectable.dart';
import 'package:mdm/core/di/hive_module.dart';
import 'package:mdm/core/utils/app_logger.dart';
import 'package:mdm/features/history/data/datasources/history_entry_schema.dart';
import 'package:mdm/features/history/domain/entities/history_entry.dart';

@lazySingleton
class HistoryLocalSource {
  Future<void> addEntry(HistoryEntry entry) async {
    try {
      final box = Hive.box<HistoryEntrySchema>(HiveModule.historyBox);
      final schema = _mapToSchema(entry);
      await box.put(schema.videoId, schema);
      AppLogger.d('History entry saved: ${entry.videoId}');
    } catch (e, stack) {
      AppLogger.e('Failed to save history entry', e, stack);
      rethrow;
    }
  }

  Future<List<HistoryEntry>> getAllEntries() async {
    try {
      final box = Hive.box<HistoryEntrySchema>(HiveModule.historyBox);
      final schemas = box.values.toList()
        ..sort((a, b) => b.downloadedAt.compareTo(a.downloadedAt));
      return schemas.map(_mapToDomain).toList();
    } catch (e, stack) {
      AppLogger.e('Failed to get history entries', e, stack);
      rethrow;
    }
  }

  Future<void> removeEntry(String videoId) async {
    try {
      final box = Hive.box<HistoryEntrySchema>(HiveModule.historyBox);
      await box.delete(videoId);
      AppLogger.d('History entry deleted: $videoId');
    } catch (e, stack) {
      AppLogger.e('Failed to delete history entry', e, stack);
      rethrow;
    }
  }

  Future<void> clearAll() async {
    try {
      final box = Hive.box<HistoryEntrySchema>(HiveModule.historyBox);
      await box.clear();
      AppLogger.d('All history entries cleared');
    } catch (e, stack) {
      AppLogger.e('Failed to clear history', e, stack);
      rethrow;
    }
  }

  Future<void> toggleFavorite(String videoId, bool isFavorite) async {
    try {
      final box = Hive.box<HistoryEntrySchema>(HiveModule.historyBox);
      final entry = box.get(videoId);
      if (entry != null) {
        entry.isFavorite = isFavorite;
        await entry.save();
        AppLogger.d('Toggled favorite for $videoId to $isFavorite');
      }
    } catch (e, stack) {
      AppLogger.e('Failed to toggle favorite', e, stack);
      rethrow;
    }
  }

  HistoryEntrySchema _mapToSchema(HistoryEntry entry) {
    return HistoryEntrySchema(
      videoId: entry.videoId,
      title: entry.title,
      channelName: entry.channelName,
      thumbnailUrl: entry.thumbnailUrl,
      filePath: entry.filePath,
      fileSizeBytes: entry.fileSizeBytes,
      resolution: entry.resolution,
      downloadedAt: entry.downloadedAt,
      isFavorite: entry.isFavorite,
    );
  }

  HistoryEntry _mapToDomain(HistoryEntrySchema schema) {
    return HistoryEntry(
      videoId: schema.videoId,
      title: schema.title,
      channelName: schema.channelName,
      thumbnailUrl: schema.thumbnailUrl,
      filePath: schema.filePath,
      fileSizeBytes: schema.fileSizeBytes,
      resolution: schema.resolution,
      downloadedAt: schema.downloadedAt,
      isFavorite: schema.isFavorite,
    );
  }
}
// <<< HistoryLocalSource =======================
