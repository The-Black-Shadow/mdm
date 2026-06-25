// >>> FavoritesState =======================
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mdm/features/history/domain/entities/history_entry.dart';

part 'favorites_state.freezed.dart';

@freezed
class FavoritesState with _$FavoritesState {
  const factory FavoritesState.initial() = _Initial;
  const factory FavoritesState.loading() = _Loading;
  const factory FavoritesState.loaded(List<HistoryEntry> entries) = _Loaded;
  const factory FavoritesState.error(String message) = _Error;
}
// <<< FavoritesState =======================
