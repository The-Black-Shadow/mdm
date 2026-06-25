import 'package:flutter/material.dart';

import 'package:mdm/core/extensions/duration_extensions.dart';
import 'package:mdm/core/theme/app_colors.dart';
import 'package:mdm/core/theme/app_spacing.dart';
import 'package:mdm/features/downloader/domain/entities/video_metadata.dart';
import 'package:mdm/shared/components/thumbnail_widget.dart';

// >>> VideoInfoHeader =======================
// Displays video thumbnail with gradient overlay, title, channel info,
// duration, view count, and upload date
class VideoInfoHeader extends StatelessWidget {
  final VideoMetadata metadata;

  const VideoInfoHeader({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildThumbnailSection(context),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: _buildInfoSection(context),
        ),
      ],
    );
  }

  Widget _buildThumbnailSection(BuildContext context) {
    return Stack(
      children: [
        // Full-width thumbnail
        AspectRatio(
          aspectRatio: 16 / 9,
          child: ThumbnailWidget(
            url: metadata.thumbnailUrl,
            borderRadius: 0,
          ),
        ),

        // Gradient overlay at bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 80,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),
        ),

        // Duration badge
        Positioned(
          bottom: AppSpacing.sm,
          right: AppSpacing.sm,
          child: _DurationBadge(duration: metadata.duration),
        ),
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          metadata.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.sm),

        // Channel name + stats row
        _buildChannelRow(context),
        const SizedBox(height: AppSpacing.sm),

        // Stats row
        _buildStatsRow(context),
      ],
    );
  }

  Widget _buildChannelRow(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // Channel avatar or icon
        if (metadata.channelAvatarUrl != null)
          CircleAvatar(
            radius: 14,
            backgroundImage: NetworkImage(metadata.channelAvatarUrl!),
          )
        else
          CircleAvatar(
            radius: 14,
            backgroundColor: AppColors.surfaceElevatedDark,
            child: Icon(
              Icons.person,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            metadata.channelName,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Wrap(
      spacing: AppSpacing.base,
      children: [
        if (metadata.viewCount != null)
          Text('${_formatViewCount(metadata.viewCount!)} views', style: textStyle),
        if (metadata.uploadDate != null)
          Text(_formatDate(metadata.uploadDate!), style: textStyle),
      ],
    );
  }

  String _formatViewCount(int count) {
    if (count >= 1000000000) {
      return '${(count / 1000000000).toStringAsFixed(1)}B';
    }
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    }
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 365) {
      return '${(diff.inDays / 365).floor()} years ago';
    }
    if (diff.inDays > 30) {
      return '${(diff.inDays / 30).floor()} months ago';
    }
    if (diff.inDays > 0) return '${diff.inDays} days ago';
    if (diff.inHours > 0) return '${diff.inHours} hours ago';
    return 'Just now';
  }
}
// <<< VideoInfoHeader =======================

// >>> DurationBadge =======================
class _DurationBadge extends StatelessWidget {
  final Duration duration;

  const _DurationBadge({required this.duration});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        duration.formatted,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
// <<< DurationBadge =======================
