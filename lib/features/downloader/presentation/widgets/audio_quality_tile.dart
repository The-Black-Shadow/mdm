import 'package:flutter/material.dart';

import 'package:mdm/core/extensions/int_extensions.dart';
import 'package:mdm/core/theme/app_colors.dart';
import 'package:mdm/core/theme/app_spacing.dart';
import 'package:mdm/features/downloader/domain/entities/stream_info.dart';
import 'package:mdm/shared/components/quality_badge.dart';

// >>> AudioQualityTile =======================
// Displays an audio stream option with bitrate, codec, container,
// estimated size, and a download button
class AudioQualityTile extends StatelessWidget {
  final StreamInfo stream;
  final VoidCallback onDownload;

  const AudioQualityTile({
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
        _buildBadgeRow(),
        const SizedBox(height: AppSpacing.xs),
        _buildSizeRow(context),
      ],
    );
  }

  Widget _buildBadgeRow() {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      children: [
        if (stream.bitrate != null)
          QualityBadge(
            label: '${stream.bitrate} kbps',
            color: _bitrateColor(stream.bitrate!),
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

  Widget _buildSizeRow(BuildContext context) {
    final theme = Theme.of(context);

    if (stream.estimatedSizeBytes == null) return const SizedBox.shrink();

    return Text(
      stream.estimatedSizeBytes!.formatBytes,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
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

  Color _bitrateColor(int bitrate) {
    if (bitrate >= 256) return AppColors.primary;
    if (bitrate >= 192) return AppColors.info;
    if (bitrate >= 128) return AppColors.success;
    return AppColors.textSecondaryDark;
  }
}
// <<< AudioQualityTile =======================
