// >>> HistoryRepositoryImpl =======================
import 'package:injectable/injectable.dart';
import 'package:mdm/core/utils/app_exception.dart';
import 'package:mdm/core/utils/app_logger.dart';
import 'package:mdm/core/utils/result.dart';
import 'package:mdm/features/history/data/datasources/history_local_source.dart';
import 'package:mdm/features/history/domain/entities/history_entry.dart';
import 'package:mdm/features/history/domain/repositories/history_repository.dart';

@LazySingleton(as: HistoryRepository)
class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryLocalSource _localSource;

  HistoryRepositoryImpl(this._localSource);

  @override
  Future<Result<void>> addEntry(HistoryEntry entry) async {
    try {
      await _localSource.addEntry(entry);
      return Result.success(null);
    } catch (e, stack) {
      AppLogger.e('Failed to add history entry', e, stack);
      return Result.failure(AppException.unknown(e.toString()));
    }
  }

  @override
  Future<Result<void>> clearHistory() async {
    try {
      await _localSource.clearAll();
      return Result.success(null);
    } catch (e, stack) {
      AppLogger.e('Failed to clear history', e, stack);
      return Result.failure(AppException.unknown(e.toString()));
    }
  }

  @override
  Future<Result<List<HistoryEntry>>> getFavorites() async {
    try {
      final entries = await _localSource.getAllEntries();
      final favorites = entries.where((e) => e.isFavorite).toList();
      return Result.success(favorites);
    } catch (e, stack) {
      AppLogger.e('Failed to get favorites', e, stack);
      return Result.failure(AppException.unknown(e.toString()));
    }
  }

  @override
  Future<Result<List<HistoryEntry>>> getHistory() async {
    try {
      final entries = await _localSource.getAllEntries();
      return Result.success(entries);
    } catch (e, stack) {
      AppLogger.e('Failed to get history', e, stack);
      return Result.failure(AppException.unknown(e.toString()));
    }
  }

  @override
  Future<Result<void>> removeEntry(String videoId) async {
    try {
      await _localSource.removeEntry(videoId);
      return Result.success(null);
    } catch (e, stack) {
      AppLogger.e('Failed to remove history entry', e, stack);
      return Result.failure(AppException.unknown(e.toString()));
    }
  }

  @override
  Future<Result<List<HistoryEntry>>> searchHistory(String query) async {
    try {
      final entries = await _localSource.getAllEntries();
      final lowerQuery = query.toLowerCase();
      final results = entries.where((e) {
        return e.title.toLowerCase().contains(lowerQuery) ||
            e.channelName.toLowerCase().contains(lowerQuery);
      }).toList();
      return Result.success(results);
    } catch (e, stack) {
      AppLogger.e('Failed to search history', e, stack);
      return Result.failure(AppException.unknown(e.toString()));
    }
  }

  @override
  Future<Result<void>> toggleFavorite(String videoId, bool isFavorite) async {
    try {
      await _localSource.toggleFavorite(videoId, isFavorite);
      return Result.success(null);
    } catch (e, stack) {
      AppLogger.e('Failed to toggle favorite', e, stack);
      return Result.failure(AppException.unknown(e.toString()));
    }
  }
}
// <<< HistoryRepositoryImpl =======================
