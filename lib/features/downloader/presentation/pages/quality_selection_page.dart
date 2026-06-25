import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:mdm/core/extensions/duration_extensions.dart';
import 'package:mdm/core/theme/app_colors.dart';
import 'package:mdm/core/theme/app_spacing.dart';
import 'package:mdm/core/utils/app_logger.dart';
import 'package:mdm/features/downloader/domain/entities/stream_info.dart';
import 'package:mdm/features/downloader/domain/entities/video_metadata.dart';
import 'package:mdm/features/downloader/presentation/widgets/audio_quality_tile.dart';
import 'package:mdm/features/downloader/presentation/widgets/download_options_sheet.dart';
import 'package:mdm/features/downloader/presentation/widgets/stream_quality_tile.dart';
import 'package:mdm/shared/components/thumbnail_widget.dart';

// >>> QualitySelectionPage =======================
// Displays available streams grouped by Video and Audio tabs with a
// compact header showing thumbnail, title, and duration
class QualitySelectionPage extends StatelessWidget {
  final VideoMetadata metadata;
  final bool initialAudioOnly;

  const QualitySelectionPage({
    super.key,
    required this.metadata,
    this.initialAudioOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: initialAudioOnly ? 1 : 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Select Quality'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Video'),
              Tab(text: 'Audio Only'),
            ],
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
          ),
        ),
        body: Column(
          children: [
            _CompactHeader(metadata: metadata),
            const Divider(height: 1),
            Expanded(
              child: TabBarView(
                children: [
                  _VideoStreamList(
                    streams: metadata.videoStreams,
                    videoTitle: metadata.title,
                  ),
                  _AudioStreamList(
                    streams: metadata.audioStreams,
                    videoTitle: metadata.title,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// <<< QualitySelectionPage =======================

// >>> CompactHeader =======================
// Shows thumbnail, title, and duration at the top of the quality page
class _CompactHeader extends StatelessWidget {
  final VideoMetadata metadata;

  const _CompactHeader({required this.metadata});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          // Compact thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 80,
              height: 45,
              child: ThumbnailWidget(
                url: metadata.thumbnailUrl,
                width: 80,
                height: 45,
                borderRadius: 8,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Title + Duration
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  metadata.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  metadata.duration.formatted,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// <<< CompactHeader =======================

// >>> VideoStreamList =======================
// Lists video streams grouped by resolution descending
class _VideoStreamList extends StatelessWidget {
  final List<StreamInfo> streams;
  final String videoTitle;

  const _VideoStreamList({
    required this.streams,
    required this.videoTitle,
  });

  @override
  Widget build(BuildContext context) {
    if (streams.isEmpty) {
      return _buildEmptyState(context, 'No video streams available');
    }

    // Sort by resolution descending (parse number from resolution string)
    final sorted = List<StreamInfo>.from(streams)
      ..sort((a, b) => _parseResolution(b) - _parseResolution(a));

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      itemCount: sorted.length,
      separatorBuilder: (context, index) => const Divider(height: 1, indent: 16),
      itemBuilder: (context, index) {
        return StreamQualityTile(
          stream: sorted[index],
          onDownload: () => _showDownloadOptions(
            context,
            sorted[index],
          ),
        );
      },
    );
  }

  int _parseResolution(StreamInfo stream) {
    if (stream.resolution == null) return 0;
    final digits = stream.resolution!.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
  }

  void _showDownloadOptions(BuildContext context, StreamInfo stream) {
    DownloadOptionsSheet.show(
      context: context,
      videoTitle: videoTitle,
      selectedStream: stream,
      onStartDownload: ({
        required String fileName,
        required bool extractAudio,
      }) {
        AppLogger.i('Download started: $fileName, extract: $extractAudio');
        // TODO: Dispatch download event in Phase 3
      },
    );
  }
}
// <<< VideoStreamList =======================

// >>> AudioStreamList =======================
// Lists audio streams sorted by bitrate descending
class _AudioStreamList extends StatelessWidget {
  final List<StreamInfo> streams;
  final String videoTitle;

  const _AudioStreamList({
    required this.streams,
    required this.videoTitle,
  });

  @override
  Widget build(BuildContext context) {
    if (streams.isEmpty) {
      return _buildEmptyState(context, 'No audio streams available');
    }

    // Sort by bitrate descending
    final sorted = List<StreamInfo>.from(streams)
      ..sort((a, b) => (b.bitrate ?? 0) - (a.bitrate ?? 0));

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      itemCount: sorted.length,
      separatorBuilder: (context, index) => const Divider(height: 1, indent: 16),
      itemBuilder: (context, index) {
        return AudioQualityTile(
          stream: sorted[index],
          onDownload: () => _showDownloadOptions(
            context,
            sorted[index],
          ),
        );
      },
    );
  }

  void _showDownloadOptions(BuildContext context, StreamInfo stream) {
    DownloadOptionsSheet.show(
      context: context,
      videoTitle: videoTitle,
      selectedStream: stream,
      onStartDownload: ({
        required String fileName,
        required bool extractAudio,
      }) {
        AppLogger.i('Audio download started: $fileName');
        // TODO: Dispatch download event in Phase 3
      },
    );
  }
}
// <<< AudioStreamList =======================

// >>> EmptyState Helper =======================
Widget _buildEmptyState(BuildContext context, String message) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.videocam_off_outlined,
          size: 48,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    ),
  );
}
// <<< EmptyState Helper =======================
