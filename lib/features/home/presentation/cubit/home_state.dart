import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mdm/features/downloader/domain/entities/download_task.dart';
import 'package:mdm/features/history/domain/entities/history_entry.dart';

part 'home_state.freezed.dart';

// >>> HomeState =======================
@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.loading() = _Loading;
  const factory HomeState.loaded({
    required List<HistoryEntry> recentDownloads,
    required List<DownloadTask> activeDownloads,
    required int totalDownloads,
    required int totalSizeBytes,
    String? clipboardUrl,
  }) = _Loaded;
  const factory HomeState.error(String message) = _Error;
}
// <<< HomeState =======================
