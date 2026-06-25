// >>> HistoryRepository =======================
import 'package:mdm/core/utils/result.dart';
import 'package:mdm/features/history/domain/entities/history_entry.dart';

abstract class HistoryRepository {
  Future<Result<List<HistoryEntry>>> getHistory();
  Future<Result<List<HistoryEntry>>> getFavorites();
  Future<Result<void>> addEntry(HistoryEntry entry);
  Future<Result<void>> removeEntry(String videoId);
  Future<Result<void>> clearHistory();
  Future<Result<void>> toggleFavorite(String videoId, bool isFavorite);
  Future<Result<List<HistoryEntry>>> searchHistory(String query);
}
// <<< HistoryRepository =======================
