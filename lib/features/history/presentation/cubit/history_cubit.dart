// >>> HistoryCubit =======================
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mdm/core/utils/app_logger.dart';
import 'package:mdm/features/history/domain/entities/history_entry.dart';
import 'package:mdm/features/history/domain/repositories/history_repository.dart';
import 'package:mdm/features/history/presentation/cubit/history_state.dart';

@injectable
class HistoryCubit extends Cubit<HistoryState> {
  final HistoryRepository _repository;
  
  List<HistoryEntry> _allEntries = [];
  String _currentQuery = '';
  
  HistoryCubit(this._repository) : super(const HistoryState.initial());

  Future<void> loadHistory() async {
    emit(const HistoryState.loading());
    final result = await _repository.getHistory();
    
    result.when(
      success: (entries) {
        _allEntries = entries;
        _emitLoaded();
      },
      failure: (e) {
        emit(HistoryState.error(e.message));
      },
    );
  }

  void search(String query) {
    _currentQuery = query;
    _emitLoaded();
  }

  Future<void> toggleFavorite(String videoId) async {
    // Find current state
    final index = _allEntries.indexWhere((e) => e.videoId == videoId);
    if (index == -1) return;
    
    final currentStatus = _allEntries[index].isFavorite;
    
    final result = await _repository.toggleFavorite(videoId, !currentStatus);
    if (result.isSuccess) {
      _allEntries[index] = _allEntries[index].copyWith(isFavorite: !currentStatus);
      _emitLoaded();
    }
  }

  Future<void> removeEntry(String videoId) async {
    final result = await _repository.removeEntry(videoId);
    if (result.isSuccess) {
      _allEntries.removeWhere((e) => e.videoId == videoId);
      _emitLoaded();
    }
  }

  Future<void> clearHistory() async {
    final result = await _repository.clearHistory();
    if (result.isSuccess) {
      _allEntries.clear();
      _emitLoaded();
    }
  }

  void _emitLoaded() {
    List<HistoryEntry> filtered = _allEntries;
    if (_currentQuery.trim().isNotEmpty) {
      final q = _currentQuery.toLowerCase();
      filtered = _allEntries.where((e) {
        return e.title.toLowerCase().contains(q) || 
               e.channelName.toLowerCase().contains(q);
      }).toList();
    }
    
    emit(HistoryState.loaded(
      entries: filtered,
      hasMore: false, // Pagination not implemented in simple list
      searchQuery: _currentQuery,
    ));
  }
}
// <<< HistoryCubit =======================
