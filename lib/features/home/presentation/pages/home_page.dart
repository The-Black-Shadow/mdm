import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


import 'package:mdm/core/constants/app_constants.dart';
import 'package:mdm/core/constants/route_constants.dart';
import 'package:mdm/core/di/injection.dart';
import 'package:mdm/core/extensions/context_extensions.dart';
import 'package:mdm/core/extensions/int_extensions.dart';
import 'package:mdm/core/extensions/string_extensions.dart';
import 'package:mdm/core/theme/app_spacing.dart';
import 'package:mdm/core/widgets/app_empty_widget.dart';
import 'package:mdm/features/downloader/presentation/bloc/download_bloc.dart';
import 'package:mdm/features/downloads/presentation/widgets/active_download_tile.dart';
import 'package:mdm/features/history/presentation/widgets/history_entry_tile.dart';
import 'package:mdm/features/home/presentation/cubit/home_cubit.dart';
import 'package:mdm/features/home/presentation/cubit/home_state.dart';

// >>> HomePage =======================
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  final TextEditingController _urlController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _urlController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitUrl(String url) {
    if (url.trim().isEmpty) return;
    if (!url.isValidYouTubeUrl) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid YouTube URL')),
      );
      return;
    }
    context.pushNamed(RouteConstants.metadata, extra: url.trim());
    _urlController.clear();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName, style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.pushNamed(RouteConstants.search),
            tooltip: 'Search',
          ),
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return state.maybeWhen(
                loaded: (recent, active, count, size, clipboard) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: () => context.pushNamed(RouteConstants.downloads),
                        tooltip: 'Downloads',
                      ),
                      if (active.isNotEmpty)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: context.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              active.length.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  );
                },
                orElse: () => IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () => context.pushNamed(RouteConstants.downloads),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.pushNamed(RouteConstants.settings),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (msg) => Center(child: Text(msg)),
            loaded: (recent, active, totalCount, totalSize, clipboardUrl) {
              return RefreshIndicator(
                onRefresh: context.read<HomeCubit>().loadData,
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    // Clipboard Banner
                    if (clipboardUrl != null)
                      _buildClipboardBanner(context, clipboardUrl),

                    // URL Input Card
                    _buildUrlInputCard(context),
                    const SizedBox(height: AppSpacing.xl),

                    // Quick Stats
                    _buildQuickStats(context, totalCount, totalSize, active.length),
                    const SizedBox(height: AppSpacing.xl),

                    // Active Downloads
                    if (active.isNotEmpty) ...[
                      _buildSectionHeader(
                        context,
                        title: 'Active Downloads',
                        onSeeAll: () => context.pushNamed(RouteConstants.downloads),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ...active.map((task) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: ActiveDownloadTile(
                              task: task,
                              onPause: () => context.read<DownloadBloc>().add(PauseDownloadEvent(task.id)),
                              onResume: () => context.read<DownloadBloc>().add(ResumeDownloadEvent(task.id)),
                              onCancel: () => context.read<DownloadBloc>().add(CancelDownloadEvent(task.id)),
                            ),
                          )),
                      const SizedBox(height: AppSpacing.lg),
                    ],

                    // Recent Downloads
                    _buildSectionHeader(
                      context,
                      title: 'Recent Downloads',
                      onSeeAll: () => context.pushNamed(RouteConstants.history),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (recent.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                        child: AppEmptyWidget(message: 'No downloads yet'),
                      )
                    else
                      SizedBox(
                        height: 120, // Approximate height for horizontal tiles
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: recent.length,
                          separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: 280, // Fixed width for horizontal scroll
                              child: HistoryEntryTile(
                                entry: recent[index],
                                onDelete: () {},
                                onToggleFavorite: () {},
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildClipboardBanner(BuildContext context, String url) {
    return Card(
      color: context.colorScheme.primaryContainer,
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: ListTile(
        leading: Icon(Icons.content_paste, color: context.colorScheme.primary),
        title: const Text('Found YouTube URL in clipboard', style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(url, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.read<HomeCubit>().clearClipboardUrl(),
        ),
        onTap: () {
          context.read<HomeCubit>().clearClipboardUrl();
          _submitUrl(url);
        },
      ),
    ).animate().slideY(begin: -0.5, end: 0).fadeIn();
  }

  Widget _buildUrlInputCard(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.lg),
        side: BorderSide(color: context.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Download Video or Audio',
              style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: 'Paste YouTube link here...',
                      prefixIcon: const Icon(Icons.link),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.md),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    ),
                    onSubmitted: _submitUrl,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                FilledButton(
                  onPressed: () => _submitUrl(_urlController.text),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: AppSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.md),
                    ),
                  ),
                  child: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, int count, int size, int active) {
    return Row(
      children: [
        Expanded(child: _buildStatCard(context, 'Total', count.toString(), Icons.check_circle_outline)),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: _buildStatCard(context, 'Size', size.formatBytes, Icons.storage)),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: _buildStatCard(context, 'Active', active.toString(), Icons.show_chart)),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: context.colorScheme.primary),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          Text(title, style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, {required String title, required VoidCallback onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: onSeeAll,
          child: const Text('See All'),
        ),
      ],
    );
  }
}
// <<< HomePage =======================
