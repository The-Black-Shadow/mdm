import 'package:injectable/injectable.dart';

import 'package:mdm/core/utils/app_exception.dart';
import 'package:mdm/core/utils/app_logger.dart';
import 'package:mdm/core/utils/result.dart';
import 'package:mdm/core/utils/validators.dart';
import 'package:mdm/features/downloader/domain/entities/video_metadata.dart';
import 'package:mdm/features/downloader/domain/repositories/metadata_repository.dart';

// >>> FetchMetadataUseCase =======================
// Validates the YouTube URL, then delegates to MetadataRepository
@injectable
class FetchMetadataUseCase {
  final MetadataRepository _repository;

  FetchMetadataUseCase(this._repository);

  Future<Result<VideoMetadata>> call(String url) async {
    if (!Validators.isValidYouTubeUrl(url)) {
      AppLogger.w('Invalid YouTube URL provided: $url');
      return Result.failure(AppException.invalidUrl());
    }

    AppLogger.d('Fetching metadata for validated URL: $url');
    return _repository.fetchMetadata(url);
  }
}
// <<< FetchMetadataUseCase =======================
