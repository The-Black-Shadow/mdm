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
import '../../features/downloader/domain/repositories/download_repository.dart'
    as _i621;
import '../../features/downloader/domain/repositories/metadata_repository.dart'
    as _i370;
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
import '../network/dio_client.dart' as _i667;
import '../services/connectivity_service.dart' as _i47;
import '../services/notification_service.dart' as _i941;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.singleton<_i212.DownloadEngine>(() => _i212.DownloadEngine());
    gh.lazySingleton<_i667.DioClient>(() => _i667.DioClient());
    gh.lazySingleton<_i47.ConnectivityService>(
      () => _i47.ConnectivityService(),
    );
    gh.lazySingleton<_i941.NotificationService>(
      () => _i941.NotificationService(),
    );
    gh.lazySingleton<_i631.DownloadLocalSource>(
      () => _i631.DownloadLocalSource(),
    );
    gh.lazySingleton<_i640.YoutubeRemoteSource>(
      () => _i640.YoutubeRemoteSource(),
    );
    gh.singleton<_i402.DownloadQueueManager>(
      () => _i402.DownloadQueueManager(gh<_i212.DownloadEngine>()),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i621.DownloadRepository>(
      () => _i63.DownloadRepositoryImpl(
        gh<_i631.DownloadLocalSource>(),
        gh<_i402.DownloadQueueManager>(),
      ),
    );
    gh.lazySingleton<_i370.MetadataRepository>(
      () => _i270.MetadataRepositoryImpl(gh<_i640.YoutubeRemoteSource>()),
    );
    gh.factory<_i1034.FetchMetadataUseCase>(
      () => _i1034.FetchMetadataUseCase(gh<_i370.MetadataRepository>()),
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
