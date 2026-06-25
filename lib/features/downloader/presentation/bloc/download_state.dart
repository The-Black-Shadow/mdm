part of 'download_bloc.dart';

sealed class DownloadState {
  final List<DownloadTask> activeTasks;
  final List<DownloadTask> queue;
  final List<DownloadTask> completed;

  const DownloadState({
    this.activeTasks = const [],
    this.queue = const [],
    this.completed = const [],
  });
}

final class DownloadInitial extends DownloadState {
  const DownloadInitial() : super();
}

final class DownloadUpdate extends DownloadState {
  const DownloadUpdate({
    required super.activeTasks,
    required super.queue,
    required super.completed,
  });
}
