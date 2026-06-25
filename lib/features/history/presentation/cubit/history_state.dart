// >>> HistoryState =======================
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mdm/features/history/domain/entities/history_entry.dart';

part 'history_state.freezed.dart';

@freezed
class HistoryState with _$HistoryState {
  const factory HistoryState.initial() = _Initial;
  const factory HistoryState.loading() = _Loading;
  const factory HistoryState.loaded({
    required List<HistoryEntry> entries,
    required bool hasMore,
    required String searchQuery,
  }) = _Loaded;
  const factory HistoryState.error(String message) = _Error;
}
// <<< HistoryState =======================
