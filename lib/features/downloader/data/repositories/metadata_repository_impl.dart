import 'package:injectable/injectable.dart';

import 'package:mdm/core/utils/result.dart';
import 'package:mdm/features/downloader/data/datasources/youtube_remote_source.dart';
import 'package:mdm/features/downloader/domain/entities/video_metadata.dart';
import 'package:mdm/features/downloader/domain/repositories/metadata_repository.dart';

// >>> MetadataRepositoryImpl =======================
// Concrete implementation that delegates to YoutubeRemoteSource
// and maps data models to domain entities
@LazySingleton(as: MetadataRepository)
class MetadataRepositoryImpl implements MetadataRepository {
  final YoutubeRemoteSource _remoteSource;

  MetadataRepositoryImpl(this._remoteSource);

  @override
  Future<Result<VideoMetadata>> fetchMetadata(String url) async {
    final result = await _remoteSource.fetchVideoMetadata(url);
    return result.when(
      success: (model) => Result.success(model.toDomain()),
      failure: (exception) => Result.failure(exception),
    );
  }
}
// <<< MetadataRepositoryImpl =======================
