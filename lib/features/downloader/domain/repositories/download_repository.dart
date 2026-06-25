// >>> DownloadRepository =======================
import 'package:mdm/core/utils/result.dart';
import 'package:mdm/features/downloader/domain/entities/download_task.dart';

abstract class DownloadRepository {
  Future<Result<void>> startDownload(DownloadTask task);
  Future<Result<void>> pauseDownload(String taskId);
  Future<Result<void>> cancelDownload(String taskId);
  Future<Result<List<DownloadTask>>> getAllTasks();
  Stream<List<DownloadTask>> watchAllTasks();
}
// <<< DownloadRepository =======================
