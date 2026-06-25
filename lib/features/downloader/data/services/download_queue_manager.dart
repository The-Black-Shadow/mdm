// >>> DownloadQueueManager =======================
import 'dart:async';
import 'dart:collection';

import 'package:injectable/injectable.dart';

import 'package:mdm/core/utils/app_logger.dart';
import 'package:mdm/features/downloader/data/services/download_engine.dart';
import 'package:mdm/features/downloader/domain/entities/download_task.dart';
import 'package:mdm/features/history/domain/entities/history_entry.dart';
import 'package:mdm/features/history/domain/repositories/history_repository.dart';
import 'package:mdm/shared/enums/download_status.dart';

@singleton
class DownloadQueueManager {
  final DownloadEngine _downloadEngine;
  final HistoryRepository _historyRepository;
  final int _maxConcurrentDownloads = 2;

  final Queue<DownloadTask> _queue = Queue<DownloadTask>();
  final Map<String, DownloadTask> _activeDownloads = {};

  late final StreamSubscription<DownloadTask> _progressSubscription;

  // Stream to expose queue updates and engine progress combined
  final StreamController<DownloadTask> _taskUpdateController =
      StreamController<DownloadTask>.broadcast();

  Stream<DownloadTask> get taskUpdateStream => _taskUpdateController.stream;

  DownloadQueueManager(this._downloadEngine, this._historyRepository) {
    _progressSubscription = _downloadEngine.progressStream.listen((task) {
      if (task.status == DownloadStatus.completed ||
          task.status == DownloadStatus.failed ||
          task.status == DownloadStatus.paused) {
        if (task.status == DownloadStatus.completed) {
          _addToHistory(task);
        }
        _activeDownloads.remove(task.id);
        _processQueue();
      } else {
        _activeDownloads[task.id] = task;
      }
      _taskUpdateController.add(task);
    });
  }

  void enqueue(DownloadTask task) {
    AppLogger.i('Enqueueing task: ${task.id}');
    final waitingTask = task.copyWith(status: DownloadStatus.waiting);
    _queue.add(waitingTask);
    _taskUpdateController.add(waitingTask);
    _processQueue();
  }

  void pause(String taskId) {
    if (_activeDownloads.containsKey(taskId)) {
      _downloadEngine.pause(taskId);
      final task = _activeDownloads.remove(taskId);
      if (task != null) {
        _taskUpdateController.add(task.copyWith(status: DownloadStatus.paused));
      }
      _processQueue();
    } else {
      // If it's in the queue, remove it and mark as paused
      final task = _queue.cast<DownloadTask?>().firstWhere(
            (t) => t?.id == taskId,
            orElse: () => null,
          );
      if (task != null) {
        _queue.removeWhere((t) => t.id == taskId);
        _taskUpdateController.add(task.copyWith(status: DownloadStatus.paused));
      }
    }
  }

  void cancel(String taskId) {
    if (_activeDownloads.containsKey(taskId)) {
      _downloadEngine.cancel(taskId);
      _activeDownloads.remove(taskId);
      _processQueue();
    } else {
      _queue.removeWhere((t) => t.id == taskId);
    }
  }

  void _processQueue() {
    while (_activeDownloads.length < _maxConcurrentDownloads &&
        _queue.isNotEmpty) {
      final task = _queue.removeFirst();
      _activeDownloads[task.id] = task;
      _downloadEngine.start(task);
    }
  }

  void _addToHistory(DownloadTask task) {
    // Determine resolution to show (or audio tag)
    final res = task.extractAudio ? 'Audio' : (task.selectedStream.resolution ?? 'Video');
    final entry = HistoryEntry(
      videoId: task.videoId,
      title: task.title,
      channelName: task.channelName,
      thumbnailUrl: task.thumbnailUrl,
      filePath: task.outputPath,
      fileSizeBytes: task.selectedStream.estimatedSizeBytes ?? 0,
      resolution: res,
      downloadedAt: DateTime.now(),
    );
    _historyRepository.addEntry(entry);
  }

  @disposeMethod
  void dispose() {
    _progressSubscription.cancel();
    _taskUpdateController.close();
  }
}
// <<< DownloadQueueManager =======================
