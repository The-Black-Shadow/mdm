import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' hide VideoUnplayableException;

import 'package:mdm/core/utils/app_exception.dart';
import 'package:mdm/core/utils/app_logger.dart';
import 'package:mdm/core/utils/result.dart';
import 'package:mdm/features/downloader/data/models/stream_info_model.dart';
import 'package:mdm/features/downloader/data/models/video_metadata_model.dart';

// >>> YoutubeRemoteSource =======================
// Wraps youtube_explode_dart to fetch video metadata and stream manifests
@lazySingleton
class YoutubeRemoteSource {
  Future<Result<VideoMetadataModel>> fetchVideoMetadata(String url) async {
    final yt = YoutubeExplode();
    try {
      AppLogger.d('Fetching video metadata for: $url');

      final video = await yt.videos.get(url);
      final manifest = await yt.videos.streamsClient.getManifest(video.id);

      AppLogger.d('Retrieved ${manifest.streams.length} streams for: ${video.title}');

      final videoOnlyStreams = manifest.videoOnly.map((s) {
        return StreamInfoModel(
          itag: s.tag.toString(),
          url: s.url.toString(),
          resolution: s.videoResolution.toString(),
          fps: s.framerate.framesPerSecond.toInt(),
          codec: s.codec.type,
          container: s.container.name,
          estimatedSizeBytes: s.size.totalBytes,
          bitrate: s.bitrate.bitsPerSecond,
          requiresMerge: true,
          type: 'video',
        );
      }).toList();

      final muxedStreams = manifest.muxed.map((s) {
        return StreamInfoModel(
          itag: s.tag.toString(),
          url: s.url.toString(),
          resolution: s.videoResolution.toString(),
          fps: s.framerate.framesPerSecond.toInt(),
          codec: s.codec.type,
          container: s.container.name,
          estimatedSizeBytes: s.size.totalBytes,
          bitrate: s.bitrate.bitsPerSecond,
          requiresMerge: false,
          type: 'muxed',
        );
      }).toList();

      final audioOnlyStreams = manifest.audioOnly.map((s) {
        return StreamInfoModel(
          itag: s.tag.toString(),
          url: s.url.toString(),
          resolution: null,
          fps: null,
          codec: s.codec.type,
          container: s.container.name,
          estimatedSizeBytes: s.size.totalBytes,
          bitrate: s.bitrate.bitsPerSecond,
          requiresMerge: false,
          type: 'audio',
        );
      }).toList();

      final metadata = VideoMetadataModel(
        videoId: video.id.value,
        url: video.url,
        title: video.title,
        channelName: video.author,
        durationMs: video.duration?.inMilliseconds ?? 0,
        viewCount: video.engagement.viewCount,
        uploadDate: video.uploadDate,
        description: video.description,
        thumbnailUrl: video.thumbnails.highResUrl,
        videoStreams: [...videoOnlyStreams, ...muxedStreams],
        audioStreams: audioOnlyStreams,
      );

      AppLogger.i('Successfully fetched metadata for: ${video.title}');
      return Result.success(metadata);
    } on VideoUnplayableException {
      AppLogger.w('Video unplayable: $url');
      return Result.failure(AppException.videoUnplayable());
    } on SocketException catch (e, st) {
      AppLogger.e('Network error fetching metadata', e, st);
      return Result.failure(AppException.networkUnavailable());
    } on FormatException catch (e, st) {
      AppLogger.e('Parsing error fetching metadata', e, st);
      return Result.failure(AppException.parsingFailure());
    } catch (e, st) {
      AppLogger.e('Unexpected error fetching metadata', e, st);
      return Result.failure(AppException.unknown(e.toString()));
    } finally {
      yt.close();
    }
  }
}
// <<< YoutubeRemoteSource =======================
