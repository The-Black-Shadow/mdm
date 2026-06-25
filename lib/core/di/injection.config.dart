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

import '../../features/downloader/data/datasources/youtube_remote_source.dart'
    as _i640;
import '../../features/downloader/data/repositories/metadata_repository_impl.dart'
    as _i270;
import '../../features/downloader/domain/repositories/metadata_repository.dart'
    as _i370;
import '../../features/downloader/domain/usecases/fetch_metadata_usecase.dart'
    as _i1034;
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
    gh.lazySingleton<_i667.DioClient>(() => _i667.DioClient());
    gh.lazySingleton<_i47.ConnectivityService>(
      () => _i47.ConnectivityService(),
    );
    gh.lazySingleton<_i941.NotificationService>(
      () => _i941.NotificationService(),
    );
    gh.lazySingleton<_i640.YoutubeRemoteSource>(
      () => _i640.YoutubeRemoteSource(),
    );
    gh.lazySingleton<_i370.MetadataRepository>(
      () => _i270.MetadataRepositoryImpl(gh<_i640.YoutubeRemoteSource>()),
    );
    gh.factory<_i1034.FetchMetadataUseCase>(
      () => _i1034.FetchMetadataUseCase(gh<_i370.MetadataRepository>()),
    );
    return this;
  }
}
