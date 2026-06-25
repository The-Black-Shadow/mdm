// >>> HistoryEntry =======================
import 'package:freezed_annotation/freezed_annotation.dart';

part 'history_entry.freezed.dart';

@freezed
abstract class HistoryEntry with _$HistoryEntry {
  const factory HistoryEntry({
    required String videoId,
    required String title,
    required String channelName,
    required String thumbnailUrl,
    required String filePath,
    required int fileSizeBytes,
    required String resolution,
    required DateTime downloadedAt,
    @Default(false) bool isFavorite,
  }) = _HistoryEntry;
}
// <<< HistoryEntry =======================
