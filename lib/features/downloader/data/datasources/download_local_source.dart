// >>> DownloadLocalSource =======================
import 'package:hive_ce/hive_ce.dart';
import 'package:injectable/injectable.dart';
import 'package:mdm/core/di/hive_module.dart';
import 'package:mdm/core/utils/app_logger.dart';
import 'package:mdm/features/downloader/data/datasources/download_task_schema.dart';
import 'package:mdm/features/downloader/domain/entities/download_task.dart';
import 'package:mdm/features/downloader/domain/entities/stream_info.dart';
import 'package:mdm/shared/enums/download_status.dart';
import 'package:mdm/shared/enums/media_type.dart';

@lazySingleton
class DownloadLocalSource {
  Future<void> saveTask(DownloadTask task) async {
    try {
      final box = Hive.box<DownloadTaskSchema>(HiveModule.downloadTaskBox);
      final schema = _mapToSchema(task);
      await box.put(schema.id, schema);
      AppLogger.d('Task saved to local source: ${task.id}');
    } catch (e, stack) {
      AppLogger.e('Failed to save task to local source', e, stack);
      rethrow;
    }
  }

  Future<DownloadTask?> getTask(String id) async {
    try {
      final box = Hive.box<DownloadTaskSchema>(HiveModule.downloadTaskBox);
      final schema = box.get(id);
      if (schema != null) {
        return _mapToDomain(schema);
      }
      return null;
    } catch (e, stack) {
      AppLogger.e('Failed to get task from local source', e, stack);
      rethrow;
    }
  }

  Future<List<DownloadTask>> getAllTasks() async {
    try {
      final box = Hive.box<DownloadTaskSchema>(HiveModule.downloadTaskBox);
      final schemas = box.values.toList();
      return schemas.map(_mapToDomain).toList();
    } catch (e, stack) {
      AppLogger.e('Failed to get all tasks from local source', e, stack);
      rethrow;
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      final box = Hive.box<DownloadTaskSchema>(HiveModule.downloadTaskBox);
      await box.delete(id);
      AppLogger.d('Task deleted from local source: $id');
    } catch (e, stack) {
      AppLogger.e('Failed to delete task from local source', e, stack);
      rethrow;
    }
  }

  DownloadTaskSchema _mapToSchema(DownloadTask task) {
    return DownloadTaskSchema(
      id: task.id,
      videoId: task.videoId,
      title: task.title,
      thumbnailUrl: task.thumbnailUrl,
      videoUrl: task.videoUrl,
      audioUrl: task.audioUrl,
      outputPath: task.outputPath,
      statusIndex: task.status.index,
      progress: task.progress,
      errorMessage: task.errorMessage,
      streamItag: int.parse(task.selectedStream.itag),
      streamType: task.selectedStream.type.name,
      streamResolution: task.selectedStream.resolution,
      streamCodec: task.selectedStream.codec,
      streamContainer: task.selectedStream.container,
      streamBitrate: task.selectedStream.bitrate,
      streamRequiresMerge: task.selectedStream.requiresMerge,
      createdAt: task.createdAt,
      completedAt: task.completedAt,
      estimatedSizeBytes: task.selectedStream.estimatedSizeBytes,
      extractAudio: task.extractAudio,
      channelName: task.channelName,
    );
  }

  DownloadTask _mapToDomain(DownloadTaskSchema schema) {
    return DownloadTask(
      id: schema.id,
      videoId: schema.videoId,
      title: schema.title,
      thumbnailUrl: schema.thumbnailUrl,
      channelName: schema.channelName,
      videoUrl: schema.videoUrl,
      audioUrl: schema.audioUrl,
      outputPath: schema.outputPath,
      status: DownloadStatus.values[schema.statusIndex],
      progress: schema.progress,
      errorMessage: schema.errorMessage,
      selectedStream: StreamInfo(
        itag: schema.streamItag.toString(),
        url: '',
        type: MediaType.values.firstWhere(
            (e) => e.name == schema.streamType,
            orElse: () => MediaType.video),
        resolution: schema.streamResolution,
        codec: schema.streamCodec,
        container: schema.streamContainer,
        bitrate: schema.streamBitrate,
        requiresMerge: schema.streamRequiresMerge,
        estimatedSizeBytes: schema.estimatedSizeBytes,
      ),
      createdAt: schema.createdAt,
      completedAt: schema.completedAt,
      extractAudio: schema.extractAudio,
    );
  }
}
// <<< DownloadLocalSource =======================
