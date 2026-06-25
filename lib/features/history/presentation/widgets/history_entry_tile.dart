// >>> HistoryEntryTile =======================
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mdm/core/constants/route_constants.dart';
import 'package:mdm/core/extensions/int_extensions.dart';
import 'package:mdm/core/theme/app_spacing.dart';
import 'package:mdm/features/history/domain/entities/history_entry.dart';
import 'package:mdm/shared/components/thumbnail_widget.dart';

class HistoryEntryTile extends StatelessWidget {
  final HistoryEntry entry;
  final VoidCallback onDelete;
  final VoidCallback onToggleFavorite;

  const HistoryEntryTile({
    super.key,
    required this.entry,
    required this.onDelete,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final file = File(entry.filePath);
        if (file.existsSync()) {
          context.pushNamed(RouteConstants.player, extra: entry.filePath);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File not found')),
          );
        }
      },
      onLongPress: () {
        _showContextMenu(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 140,
              height: 80,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ThumbnailWidget(
                    url: entry.thumbnailUrl,
                    width: 140,
                    height: 80,
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        entry.resolution,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.channelName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                        ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        entry.fileSizeBytes.formatBytes,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[500],
                            ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          entry.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 16,
                          color: entry.isFavorite ? Colors.red : Colors.grey,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: onToggleFavorite,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.play_arrow),
                title: const Text('Play'),
                onTap: () {
                  Navigator.pop(context);
                  context.pushNamed(RouteConstants.player, extra: entry.filePath);
                },
              ),
              ListTile(
                leading: Icon(
                    entry.isFavorite ? Icons.favorite_border : Icons.favorite),
                title: Text(entry.isFavorite
                    ? 'Remove from Favorites'
                    : 'Add to Favorites'),
                onTap: () {
                  Navigator.pop(context);
                  onToggleFavorite();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete from History',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  onDelete();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
// <<< HistoryEntryTile =======================
