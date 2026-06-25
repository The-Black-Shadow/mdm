import 'package:flutter/material.dart';

import 'package:mdm/core/extensions/int_extensions.dart';
import 'package:mdm/core/theme/app_colors.dart';
import 'package:mdm/core/theme/app_spacing.dart';
import 'package:mdm/features/downloader/domain/entities/stream_info.dart';
import 'package:mdm/shared/components/quality_badge.dart';

// >>> StreamQualityTile =======================
// Displays a video stream option with resolution, FPS, codec, container,
// estimated size, and a download button
class StreamQualityTile extends StatelessWidget {
  final StreamInfo stream;
  final VoidCallback onDownload;

  const StreamQualityTile({
    super.key,
    required this.stream,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onDownload,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Expanded(child: _buildStreamDetails(context)),
            _buildDownloadButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStreamDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Resolution + FPS + Codec badges
        _buildBadgeRow(),
        const SizedBox(height: AppSpacing.xs),

        // Container + Size + Merge info
        _buildInfoRow(context),
      ],
    );
  }

  Widget _buildBadgeRow() {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      children: [
        if (stream.resolution != null)
          QualityBadge(
            label: stream.resolution!,
            color: _resolutionColor(stream.resolution!),
          ),
        if (stream.fps != null && stream.fps! > 30)
          QualityBadge(
            label: '${stream.fps}fps',
            color: AppColors.warning,
          ),
        QualityBadge(
          label: stream.codec.toUpperCase(),
          color: AppColors.surfaceElevatedDark,
        ),
        QualityBadge(
          label: stream.container.toUpperCase(),
          color: AppColors.surfaceElevatedDark,
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Row(
      children: [
        if (stream.estimatedSizeBytes != null)
          Text(
            stream.estimatedSizeBytes!.formatBytes,
            style: textStyle,
          ),
        if (stream.requiresMerge) ...[
          const SizedBox(width: AppSpacing.sm),
          Tooltip(
            message: 'Requires video + audio merge.\n'
                'FFmpeg will process automatically.',
            child: Icon(
              Icons.info_outline,
              size: 14,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDownloadButton(BuildContext context) {
    return IconButton(
      onPressed: onDownload,
      icon: const Icon(Icons.download_rounded),
      color: AppColors.primary,
      tooltip: 'Download',
    );
  }

  Color _resolutionColor(String resolution) {
    return switch (resolution) {
      '2160p' || '1440p' => AppColors.primary,
      '1080p' => AppColors.info,
      '720p' => AppColors.success,
      _ => AppColors.textSecondaryDark,
    };
  }
}
// <<< StreamQualityTile =======================
