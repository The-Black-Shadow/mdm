// >>> SearchState =======================
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mdm/features/history/domain/entities/history_entry.dart';

part 'search_state.freezed.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState.initial() = _Initial;
  const factory SearchState.loading() = _Loading;
  const factory SearchState.loaded(List<HistoryEntry> results) = _Loaded;
  const factory SearchState.error(String message) = _Error;
}
// <<< SearchState =======================
