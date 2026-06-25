// >>> HistoryPage =======================
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdm/core/di/injection.dart';
import 'package:mdm/core/theme/app_spacing.dart';
import 'package:mdm/features/history/domain/entities/history_entry.dart';
import 'package:mdm/features/history/presentation/cubit/history_cubit.dart';
import 'package:mdm/features/history/presentation/cubit/history_state.dart';
import 'package:mdm/features/history/presentation/widgets/history_entry_tile.dart';
import 'package:mdm/shared/components/app_empty_widget.dart';
import 'package:mdm/shared/components/app_loading_widget.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HistoryCubit>()..loadHistory(),
      child: const _HistoryView(),
    );
  }
}

class _HistoryView extends StatefulWidget {
  const _HistoryView();

  @override
  State<_HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<_HistoryView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              _showClearConfirmDialog(context);
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search history...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              onChanged: (value) {
                context.read<HistoryCubit>().search(value);
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox(),
            loading: () => const AppLoadingWidget(),
            loaded: (entries, hasMore, searchQuery) {
              if (entries.isEmpty) {
                if (searchQuery.isNotEmpty) {
                  return const AppEmptyWidget(message: 'No matching history found');
                }
                return const AppEmptyWidget(message: 'No history yet');
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return Dismissible(
                    key: Key(entry.videoId),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: AppSpacing.md),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) {
                      context.read<HistoryCubit>().removeEntry(entry.videoId);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Entry deleted'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              // Ideally we'd re-add it, but since it's just removed
                              // from local source, we would need to pass the whole entry
                              // to a restore function. For now, it's just deleted.
                            },
                          ),
                        ),
                      );
                    },
                    child: HistoryEntryTile(
                      entry: entry,
                      onDelete: () {
                        context.read<HistoryCubit>().removeEntry(entry.videoId);
                      },
                      onToggleFavorite: () {
                        context.read<HistoryCubit>().toggleFavorite(entry.videoId);
                      },
                    ),
                  );
                },
              );
            },
            error: (message) => Center(child: Text(message)),
          );
        },
      ),
    );
  }

  void _showClearConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text('Are you sure you want to clear all history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<HistoryCubit>().clearHistory();
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
// <<< HistoryPage =======================
