// >>> DownloadRepositoryImpl =======================
import 'package:injectable/injectable.dart';
import 'package:mdm/core/utils/app_exception.dart';
import 'package:mdm/core/utils/app_logger.dart';
import 'package:mdm/core/utils/result.dart';
import 'package:mdm/features/downloader/data/datasources/download_local_source.dart';
import 'package:mdm/features/downloader/data/services/download_queue_manager.dart';
import 'package:mdm/features/downloader/domain/entities/download_task.dart';
import 'package:mdm/features/downloader/domain/repositories/download_repository.dart';
import 'package:mdm/shared/enums/download_status.dart';

@LazySingleton(as: DownloadRepository)
class DownloadRepositoryImpl implements DownloadRepository {
  final DownloadLocalSource _localSource;
  final DownloadQueueManager _queueManager;

  DownloadRepositoryImpl(
    this._localSource,
    this._queueManager,
  );

  @override
  Future<Result<void>> startDownload(DownloadTask task) async {
    try {
      final downloadTask = task.copyWith(status: DownloadStatus.waiting);
      await _localSource.saveTask(downloadTask);
      _queueManager.enqueue(downloadTask);
      return Result.success(null);
    } catch (e, stackTrace) {
      AppLogger.e('Failed to start download', e, stackTrace);
      return Result.failure(
        AppException.unknown('Failed to start download: $e'),
      );
    }
  }

  @override
  Future<Result<void>> pauseDownload(String taskId) async {
    try {
      _queueManager.pause(taskId);
      final task = await _localSource.getTask(taskId);
      if (task != null) {
        await _localSource.saveTask(task.copyWith(status: DownloadStatus.paused));
      }
      return Result.success(null);
    } catch (e, stackTrace) {
      AppLogger.e('Failed to pause download', e, stackTrace);
      return Result.failure(
        AppException.unknown('Failed to pause download: $e'),
      );
    }
  }

  @override
  Future<Result<void>> cancelDownload(String taskId) async {
    try {
      _queueManager.cancel(taskId);
      await _localSource.deleteTask(taskId);
      return Result.success(null);
    } catch (e, stackTrace) {
      AppLogger.e('Failed to cancel download', e, stackTrace);
      return Result.failure(
        AppException.unknown('Failed to cancel download: $e'),
      );
    }
  }

  @override
  Future<Result<List<DownloadTask>>> getAllTasks() async {
    try {
      final tasks = await _localSource.getAllTasks();
      return Result.success(tasks);
    } catch (e, stackTrace) {
      AppLogger.e('Failed to get all tasks', e, stackTrace);
      return Result.failure(
        AppException.unknown('Failed to get all tasks: $e'),
      );
    }
  }

  @override
  Stream<List<DownloadTask>> watchAllTasks() {
    return _localSource.watchAllTasks();
  }
}
// <<< DownloadRepositoryImpl =======================
