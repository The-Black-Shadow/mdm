// >>> DownloadsPage =======================
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdm/core/theme/app_colors.dart';
import 'package:mdm/features/downloader/presentation/bloc/download_bloc.dart';
import 'package:mdm/features/downloads/presentation/widgets/active_download_tile.dart';
import 'package:mdm/features/downloads/presentation/widgets/download_queue_list.dart';

class DownloadsPage extends StatelessWidget {
  const DownloadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Downloads'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Queue'),
              Tab(text: 'Completed'),
            ],
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
          ),
        ),
        body: BlocBuilder<DownloadBloc, DownloadState>(
          builder: (context, state) {
            return TabBarView(
              children: [
                _buildActiveList(context, state),
                _buildQueueList(context, state),
                _buildCompletedList(context, state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildActiveList(BuildContext context, DownloadState state) {
    if (state.activeTasks.isEmpty) {
      return const Center(child: Text('No active downloads'));
    }

    return ListView.builder(
      itemCount: state.activeTasks.length,
      itemBuilder: (context, index) {
        final task = state.activeTasks[index];
        return ActiveDownloadTile(
          task: task,
          onPause: () => context.read<DownloadBloc>().add(PauseDownloadEvent(task.id)),
          onResume: () => context.read<DownloadBloc>().add(ResumeDownloadEvent(task.id)),
          onCancel: () => context.read<DownloadBloc>().add(CancelDownloadEvent(task.id)),
        );
      },
    );
  }

  Widget _buildQueueList(BuildContext context, DownloadState state) {
    return DownloadQueueList(
      tasks: state.queue,
      onCancel: (id) => context.read<DownloadBloc>().add(CancelDownloadEvent(id)),
    );
  }

  Widget _buildCompletedList(BuildContext context, DownloadState state) {
    if (state.completed.isEmpty) {
      return const Center(child: Text('No completed downloads yet'));
    }

    // Reuse history item tile or similar later. For now, simple list.
    return ListView.builder(
      itemCount: state.completed.length,
      itemBuilder: (context, index) {
        final task = state.completed[index];
        return ListTile(
          title: Text(task.title),
          subtitle: const Text('Completed'),
          trailing: const Icon(Icons.check_circle, color: AppColors.success),
        );
      },
    );
  }
}
// <<< DownloadsPage =======================
