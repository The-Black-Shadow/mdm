// >>> DownloadQueueList =======================
import 'package:flutter/material.dart';

import 'package:mdm/core/theme/app_spacing.dart';
import 'package:mdm/features/downloader/domain/entities/download_task.dart';
import 'package:mdm/shared/components/thumbnail_widget.dart';

class DownloadQueueList extends StatelessWidget {
  final List<DownloadTask> tasks;
  final Function(String) onCancel;

  const DownloadQueueList({
    super.key,
    required this.tasks,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(
        child: Text(
          'Queue is empty',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      );
    }

    // TODO: Implement ReorderableListView in Phase 3 for drag-to-reorder
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      itemCount: tasks.length,
      separatorBuilder: (context, index) => const Divider(height: 1, indent: 16),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          leading: SizedBox(
            width: 80,
            height: 45,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ThumbnailWidget(
                url: task.thumbnailUrl,
                width: 80,
                height: 45,
                borderRadius: 8,
              ),
            ),
          ),
          title: Text(
            task.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            'Waiting...',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => onCancel(task.id),
          ),
        );
      },
    );
  }
}
// <<< DownloadQueueList =======================
