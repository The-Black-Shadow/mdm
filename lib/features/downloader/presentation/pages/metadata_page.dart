import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:mdm/core/constants/route_constants.dart';
import 'package:mdm/core/theme/app_colors.dart';
import 'package:mdm/core/theme/app_spacing.dart';
import 'package:mdm/core/widgets/app_error_widget.dart';
import 'package:mdm/features/downloader/domain/entities/video_metadata.dart';
import 'package:mdm/features/downloader/presentation/bloc/metadata_bloc.dart';
import 'package:mdm/features/downloader/presentation/widgets/metadata_shimmer.dart';
import 'package:mdm/features/downloader/presentation/widgets/video_info_header.dart';

// >>> MetadataPage =======================
// Displays fetched video metadata with thumbnail, info, expandable
// description, and sticky bottom bar for audio/quality selection
class MetadataPage extends StatelessWidget {
  const MetadataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<MetadataBloc, MetadataState>(
        builder: (context, state) {
          return switch (state) {
            MetadataInitial() => const MetadataShimmer(),
            MetadataLoading() => const MetadataShimmer(),
            MetadataLoaded(:final metadata) =>
              _MetadataContent(metadata: metadata),
            MetadataError(:final message, :final isNetworkError) =>
              _buildError(context, message, isNetworkError),
          };
        },
      ),
    );
  }

  Widget _buildError(
    BuildContext context,
    String message,
    bool isNetworkError,
  ) {
    return AppErrorWidget(
      message: message,
      onRetry: () {
        context.read<MetadataBloc>().add(const RetryMetadataEvent());
      },
    );
  }
}
// <<< MetadataPage =======================

// >>> MetadataContent =======================
// Loaded state content with video info and expandable description
class _MetadataContent extends StatelessWidget {
  final VideoMetadata metadata;

  const _MetadataContent({required this.metadata});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VideoInfoHeader(metadata: metadata),
                _ExpandableDescription(description: metadata.description),
              ],
            ),
          ),
        ),
        _StickyBottomBar(metadata: metadata),
      ],
    );
  }
}
// <<< MetadataContent =======================

// >>> ExpandableDescription =======================
// Collapsible description section, collapsed to 3 lines by default
class _ExpandableDescription extends StatefulWidget {
  final String? description;

  const _ExpandableDescription({this.description});

  @override
  State<_ExpandableDescription> createState() =>
      _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<_ExpandableDescription> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.description == null || widget.description!.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: AppSpacing.sm),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.description!,
                  maxLines: _expanded ? null : 3,
                  overflow: _expanded ? null : TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _expanded ? 'Show less' : 'Show more',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.base),
        ],
      ),
    );
  }
}
// <<< ExpandableDescription =======================

// >>> StickyBottomBar =======================
// Bottom bar with Audio Only and Select Quality buttons
class _StickyBottomBar extends StatelessWidget {
  final VideoMetadata metadata;

  const _StickyBottomBar({required this.metadata});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.base,
        right: AppSpacing.base,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Audio Only button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _navigateToQuality(context, audioOnly: true),
              icon: const Icon(Icons.audiotrack_rounded, size: 20),
              label: const Text('Audio Only'),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Select Quality button
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () => _navigateToQuality(context, audioOnly: false),
              icon: const Icon(Icons.high_quality_rounded, size: 20),
              label: const Text('Select Quality'),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToQuality(BuildContext context, {required bool audioOnly}) {
    context.push(
      RouteConstants.qualitySelection,
      extra: {
        'metadata': metadata,
        'audioOnly': audioOnly,
      },
    );
  }
}
// <<< StickyBottomBar =======================
