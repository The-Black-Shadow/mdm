// >>> ActiveDownloadTile =======================
import 'package:flutter/material.dart';

import 'package:mdm/core/extensions/int_extensions.dart';
import 'package:mdm/core/theme/app_colors.dart';
import 'package:mdm/core/theme/app_spacing.dart';
import 'package:mdm/features/downloader/domain/entities/download_task.dart';
import 'package:mdm/shared/components/progress_bar_widget.dart';
import 'package:mdm/shared/components/thumbnail_widget.dart';
import 'package:mdm/shared/enums/download_status.dart';

class ActiveDownloadTile extends StatelessWidget {
  final DownloadTask task;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onCancel;

  const ActiveDownloadTile({
    super.key,
    required this.task,
    required this.onPause,
    required this.onResume,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 80,
              height: 45,
              child: ThumbnailWidget(
                url: task.thumbnailUrl,
                width: 80,
                height: 45,
                borderRadius: 8,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                
                // Progress Bar
                ProgressBarWidget(
                  progress: task.progress,
                ),
                
                const SizedBox(height: AppSpacing.xs),
                
                // Stats (Speed / ETA / Status)
                _buildStatsRow(theme),
              ],
            ),
          ),
          
          const SizedBox(width: AppSpacing.sm),
          
          // Action Buttons
          _buildActionButtons(theme),
        ],
      ),
    );
  }

  Widget _buildStatsRow(ThemeData theme) {
    final textStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      fontSize: 10,
    );

    String statusText;
    switch (task.status) {
      case DownloadStatus.paused:
        statusText = 'Paused';
        break;
      case DownloadStatus.failed:
        statusText = 'Failed';
        break;
      case DownloadStatus.merging:
        statusText = 'Merging Audio & Video...';
        break;
      default:
        statusText = '${(task.progress * 100).toStringAsFixed(1)}%';
        if (task.speedBytesPerSecond != null && task.speedBytesPerSecond! > 0) {
          statusText += ' • ${task.speedBytesPerSecond!.formatSpeed}';
        }
    }

    return Text(statusText, style: textStyle);
  }

  Widget _buildActionButtons(ThemeData theme) {
    final isPaused = task.status == DownloadStatus.paused;
    final isFailed = task.status == DownloadStatus.failed;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isPaused || isFailed)
          IconButton(
            icon: const Icon(Icons.play_arrow_rounded),
            color: AppColors.primary,
            iconSize: 24,
            onPressed: onResume,
          )
        else
          IconButton(
            icon: const Icon(Icons.pause_rounded),
            color: theme.iconTheme.color,
            iconSize: 24,
            onPressed: onPause,
          ),
        IconButton(
          icon: const Icon(Icons.close_rounded),
          color: theme.iconTheme.color,
          iconSize: 24,
          onPressed: onCancel,
        ),
      ],
    );
  }
}
// <<< ActiveDownloadTile =======================
