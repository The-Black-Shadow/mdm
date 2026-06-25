part of 'download_bloc.dart';

sealed class DownloadEvent {
  const DownloadEvent();
}

final class StartDownloadEvent extends DownloadEvent {
  final DownloadTask task;
  const StartDownloadEvent(this.task);
}

final class PauseDownloadEvent extends DownloadEvent {
  final String taskId;
  const PauseDownloadEvent(this.taskId);
}

final class ResumeDownloadEvent extends DownloadEvent {
  final String taskId;
  const ResumeDownloadEvent(this.taskId);
}

final class CancelDownloadEvent extends DownloadEvent {
  final String taskId;
  const CancelDownloadEvent(this.taskId);
}

final class DownloadProgressUpdateEvent extends DownloadEvent {
  final DownloadTask task;
  const DownloadProgressUpdateEvent(this.task);
}
