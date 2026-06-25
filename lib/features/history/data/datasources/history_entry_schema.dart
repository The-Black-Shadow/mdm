// >>> HistoryEntrySchema =======================
// Hive persistence schema for download history entries (typeId: 1)
import 'package:hive_ce/hive_ce.dart';

part 'history_entry_schema.g.dart';

@HiveType(typeId: 1)
class HistoryEntrySchema extends HiveObject {
  @HiveField(0)
  final String videoId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String channelName;

  @HiveField(3)
  final String thumbnailUrl;

  @HiveField(4)
  final String filePath;

  @HiveField(5)
  final int fileSizeBytes;

  @HiveField(6)
  final String resolution;

  @HiveField(7)
  final DateTime downloadedAt;

  @HiveField(8)
  bool isFavorite;

  HistoryEntrySchema({
    required this.videoId,
    required this.title,
    required this.channelName,
    required this.thumbnailUrl,
    required this.filePath,
    required this.fileSizeBytes,
    required this.resolution,
    required this.downloadedAt,
    this.isFavorite = false,
  });
}
// <<< HistoryEntrySchema =======================
