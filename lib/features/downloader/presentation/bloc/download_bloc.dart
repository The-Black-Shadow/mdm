// >>> DownloadBLoC =======================
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mdm/core/utils/app_logger.dart';
import 'package:mdm/features/downloader/domain/entities/download_task.dart';
import 'package:mdm/features/downloader/domain/usecases/cancel_download_usecase.dart';
import 'package:mdm/features/downloader/domain/usecases/pause_download_usecase.dart';
import 'package:mdm/features/downloader/domain/usecases/start_download_usecase.dart';
import 'package:mdm/features/downloader/data/services/download_queue_manager.dart';
import 'package:mdm/shared/enums/download_status.dart';

part 'download_event.dart';
part 'download_state.dart';

@injectable
class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  final StartDownloadUseCase startDownloadUseCase;
  final PauseDownloadUseCase pauseDownloadUseCase;
  final CancelDownloadUseCase cancelDownloadUseCase;
  
  StreamSubscription<DownloadTask>? _progressSubscription;
  final Map<String, DownloadTask> _tasks = {};

  @factoryMethod
  DownloadBloc({
    required this.startDownloadUseCase,
    required this.pauseDownloadUseCase,
    required this.cancelDownloadUseCase,
    required DownloadQueueManager queueManager,
  }) : super(const DownloadInitial()) {
    on<StartDownloadEvent>(_onStartDownload);
    on<PauseDownloadEvent>(_onPauseDownload);
    on<ResumeDownloadEvent>(_onResumeDownload);
    on<CancelDownloadEvent>(_onCancelDownload);
    on<DownloadProgressUpdateEvent>(_onDownloadProgressUpdate);

    // Listen to the download queue manager updates
    _progressSubscription = queueManager.taskUpdateStream.listen((task) {
      add(DownloadProgressUpdateEvent(task));
    });
  }

  @override
  Future<void> close() {
    _progressSubscription?.cancel();
    return super.close();
  }

  Future<void> _onStartDownload(
    StartDownloadEvent event,
    Emitter<DownloadState> emit,
  ) async {
    _tasks[event.task.id] = event.task;
    _emitUpdate(emit);
    
    AppLogger.i('DownloadBloc: Starting download for ${event.task.title}');
    await startDownloadUseCase(event.task);
  }

  Future<void> _onPauseDownload(
    PauseDownloadEvent event,
    Emitter<DownloadState> emit,
  ) async {
    AppLogger.i('DownloadBloc: Pausing download ${event.taskId}');
    await pauseDownloadUseCase(event.taskId);
    if (_tasks.containsKey(event.taskId)) {
      _tasks[event.taskId] = _tasks[event.taskId]!.copyWith(status: DownloadStatus.paused);
      _emitUpdate(emit);
    }
  }

  Future<void> _onResumeDownload(
    ResumeDownloadEvent event,
    Emitter<DownloadState> emit,
  ) async {
    if (_tasks.containsKey(event.taskId)) {
      AppLogger.i('DownloadBloc: Resuming download ${event.taskId}');
      await startDownloadUseCase(_tasks[event.taskId]!);
    }
  }

  Future<void> _onCancelDownload(
    CancelDownloadEvent event,
    Emitter<DownloadState> emit,
  ) async {
    AppLogger.i('DownloadBloc: Canceling download ${event.taskId}');
    await cancelDownloadUseCase(event.taskId);
    _tasks.remove(event.taskId);
    _emitUpdate(emit);
  }

  void _onDownloadProgressUpdate(
    DownloadProgressUpdateEvent event,
    Emitter<DownloadState> emit,
  ) {
    _tasks[event.task.id] = event.task;
    _emitUpdate(emit);
  }

  void _emitUpdate(Emitter<DownloadState> emit) {
    final active = <DownloadTask>[];
    final queue = <DownloadTask>[];
    final completed = <DownloadTask>[];

    for (final task in _tasks.values) {
      if (task.status == DownloadStatus.completed) {
        completed.add(task);
      } else if (task.status == DownloadStatus.waiting) {
        queue.add(task);
      } else {
        active.add(task);
      }
    }

    emit(DownloadUpdate(
      activeTasks: active,
      queue: queue,
      completed: completed,
    ));
  }
}
// <<< DownloadBLoC =======================
