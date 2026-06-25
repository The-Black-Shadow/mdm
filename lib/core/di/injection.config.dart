// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/downloader/data/datasources/download_local_source.dart'
    as _i631;
import '../../features/downloader/data/datasources/youtube_remote_source.dart'
    as _i640;
import '../../features/downloader/data/repositories/download_repository_impl.dart'
    as _i63;
import '../../features/downloader/data/repositories/metadata_repository_impl.dart'
    as _i270;
import '../../features/downloader/data/services/download_engine.dart' as _i212;
import '../../features/downloader/data/services/download_queue_manager.dart'
    as _i402;
import '../../features/downloader/data/services/ffmpeg_service.dart' as _i1;
import '../../features/downloader/domain/repositories/download_repository.dart'
    as _i621;
import '../../features/downloader/domain/repositories/metadata_repository.dart'
    as _i370;
import '../../features/downloader/domain/services/media_processor.dart' as _i91;
import '../../features/downloader/domain/usecases/cancel_download_usecase.dart'
    as _i778;
import '../../features/downloader/domain/usecases/fetch_metadata_usecase.dart'
    as _i1034;
import '../../features/downloader/domain/usecases/pause_download_usecase.dart'
    as _i807;
import '../../features/downloader/domain/usecases/start_download_usecase.dart'
    as _i882;
import '../../features/downloader/presentation/bloc/download_bloc.dart'
    as _i784;
import '../../features/history/data/datasources/history_local_source.dart'
    as _i404;
import '../../features/history/data/repositories/history_repository_impl.dart'
    as _i751;
import '../../features/history/domain/repositories/history_repository.dart'
    as _i142;
import '../../features/history/presentation/cubit/favorites_cubit.dart'
    as _i602;
import '../../features/history/presentation/cubit/history_cubit.dart' as _i232;
import '../../features/history/presentation/cubit/search_cubit.dart' as _i576;
import '../network/dio_client.dart' as _i667;
import '../services/clipboard_service.dart' as _i235;
import '../services/connectivity_service.dart' as _i47;
import '../services/notification_service.dart' as _i941;
import '../services/permission_service.dart' as _i165;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i667.DioClient>(() => _i667.DioClient());
    gh.lazySingleton<_i47.ConnectivityService>(
      () => _i47.ConnectivityService(),
    );
    gh.lazySingleton<_i941.NotificationService>(
      () => _i941.NotificationService(),
    );
    gh.lazySingleton<_i165.PermissionService>(() => _i165.PermissionService());
    gh.lazySingleton<_i631.DownloadLocalSource>(
      () => _i631.DownloadLocalSource(),
    );
    gh.lazySingleton<_i640.YoutubeRemoteSource>(
      () => _i640.YoutubeRemoteSource(),
    );
    gh.lazySingleton<_i404.HistoryLocalSource>(
      () => _i404.HistoryLocalSource(),
    );
    gh.lazySingleton<_i91.MediaProcessor>(() => _i1.FfmpegService());
    gh.lazySingleton<_i370.MetadataRepository>(
      () => _i270.MetadataRepositoryImpl(gh<_i640.YoutubeRemoteSource>()),
    );
    gh.lazySingleton<_i142.HistoryRepository>(
      () => _i751.HistoryRepositoryImpl(gh<_i404.HistoryLocalSource>()),
    );
    gh.factory<_i1034.FetchMetadataUseCase>(
      () => _i1034.FetchMetadataUseCase(gh<_i370.MetadataRepository>()),
    );
    gh.lazySingleton<_i235.ClipboardService>(
      () => _i235.ClipboardService(gh<_i142.HistoryRepository>()),
    );
    gh.singleton<_i212.DownloadEngine>(
      () => _i212.DownloadEngine(
        gh<_i91.MediaProcessor>(),
        gh<_i941.NotificationService>(),
      ),
    );
    gh.factory<_i602.FavoritesCubit>(
      () => _i602.FavoritesCubit(gh<_i142.HistoryRepository>()),
    );
    gh.factory<_i232.HistoryCubit>(
      () => _i232.HistoryCubit(gh<_i142.HistoryRepository>()),
    );
    gh.factory<_i576.SearchCubit>(
      () => _i576.SearchCubit(gh<_i142.HistoryRepository>()),
    );
    gh.singleton<_i402.DownloadQueueManager>(
      () => _i402.DownloadQueueManager(
        gh<_i212.DownloadEngine>(),
        gh<_i142.HistoryRepository>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i621.DownloadRepository>(
      () => _i63.DownloadRepositoryImpl(
        gh<_i631.DownloadLocalSource>(),
        gh<_i402.DownloadQueueManager>(),
      ),
    );
    gh.factory<_i778.CancelDownloadUseCase>(
      () => _i778.CancelDownloadUseCase(gh<_i621.DownloadRepository>()),
    );
    gh.factory<_i807.PauseDownloadUseCase>(
      () => _i807.PauseDownloadUseCase(gh<_i621.DownloadRepository>()),
    );
    gh.factory<_i882.StartDownloadUseCase>(
      () => _i882.StartDownloadUseCase(gh<_i621.DownloadRepository>()),
    );
    gh.factory<_i784.DownloadBloc>(
      () => _i784.DownloadBloc(
        startDownloadUseCase: gh<_i882.StartDownloadUseCase>(),
        pauseDownloadUseCase: gh<_i807.PauseDownloadUseCase>(),
        cancelDownloadUseCase: gh<_i778.CancelDownloadUseCase>(),
        queueManager: gh<_i402.DownloadQueueManager>(),
      ),
    );
    return this;
  }
}
