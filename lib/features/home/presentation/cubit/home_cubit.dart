import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mdm/core/services/clipboard_service.dart';
import 'package:mdm/core/utils/app_logger.dart';
import 'package:mdm/features/downloader/domain/entities/download_task.dart';
import 'package:mdm/features/downloader/domain/repositories/download_repository.dart';
import 'package:mdm/features/history/domain/repositories/history_repository.dart';
import 'package:mdm/shared/enums/download_status.dart';

import 'home_state.dart';

// >>> HomeCubit =======================
@injectable
class HomeCubit extends Cubit<HomeState> {
  final HistoryRepository _historyRepository;
  final DownloadRepository _downloadRepository;
  final ClipboardService _clipboardService;

  StreamSubscription? _activeDownloadsSub;
  StreamSubscription? _clipboardSub;

  HomeCubit(
    this._historyRepository,
    this._downloadRepository,
    this._clipboardService,
  ) : super(const HomeState.initial()) {
    _init();
  }

  Future<void> _init() async {
    emit(const HomeState.loading());
    await loadData();

    // Listen to active downloads
    _activeDownloadsSub = _downloadRepository.watchAllTasks().listen((tasks) {
      if (isClosed) return;
      _updateActiveDownloads(tasks);
    });

    // Listen to clipboard
    _clipboardSub = _clipboardService.onYoutubeUrlFound.listen((url) {
      if (isClosed) return;
      state.maybeMap(
        loaded: (s) => emit(s.copyWith(clipboardUrl: url)),
        orElse: () {},
      );
    });
  }

  Future<void> loadData() async {
    try {
      final historyResult = await _historyRepository.getHistory();
      final tasksResult = await _downloadRepository.getAllTasks();

      if (historyResult.isSuccess && tasksResult.isSuccess) {
        final history = historyResult.dataOrNull!;
        final activeTasks = tasksResult.dataOrNull!
            .where((t) => t.status != DownloadStatus.completed)
            .toList();

        // Calculate stats
        final totalDownloads = history.length;
        final totalSize = history.fold<int>(0, (sum, entry) => sum + entry.fileSizeBytes);
        
        // Get recent 10
        history.sort((a, b) => b.downloadedAt.compareTo(a.downloadedAt));
        final recent = history.take(10).toList();

        // Preserve clipboardUrl if already loaded
        String? currentClipboard;
        state.maybeMap(
          loaded: (s) => currentClipboard = s.clipboardUrl,
          orElse: () {},
        );

        emit(HomeState.loaded(
          recentDownloads: recent,
          activeDownloads: activeTasks,
          totalDownloads: totalDownloads,
          totalSizeBytes: totalSize,
          clipboardUrl: currentClipboard,
        ));
      } else {
        emit(const HomeState.error('Failed to load home data'));
      }
    } catch (e, st) {
      AppLogger.e('HomeCubit load error', e, st);
      emit(HomeState.error('An error occurred'));
    }
  }

  void _updateActiveDownloads(List<DownloadTask> tasks) {
    state.maybeMap(
      loaded: (s) {
        final activeTasks = tasks.where((t) => t.status != DownloadStatus.completed).toList();
        emit(s.copyWith(activeDownloads: activeTasks));
      },
      orElse: () {},
    );
  }

  void clearClipboardUrl() {
    state.maybeMap(
      loaded: (s) {
        emit(s.copyWith(clipboardUrl: null));
      },
      orElse: () {},
    );
  }

  @override
  Future<void> close() {
    _activeDownloadsSub?.cancel();
    _clipboardSub?.cancel();
    return super.close();
  }
}
// <<< HomeCubit =======================
