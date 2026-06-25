import 'package:mdm/core/utils/result.dart';
import 'package:mdm/features/downloader/domain/entities/video_metadata.dart';

// >>> MetadataRepository =======================
// Abstract contract for fetching video metadata from any source
abstract class MetadataRepository {
  Future<Result<VideoMetadata>> fetchMetadata(String url);
}
// <<< MetadataRepository =======================
