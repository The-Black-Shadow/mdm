// >>> FavoritesPage =======================
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdm/core/di/injection.dart';
import 'package:mdm/core/theme/app_spacing.dart';
import 'package:mdm/features/history/presentation/cubit/favorites_cubit.dart';
import 'package:mdm/features/history/presentation/cubit/favorites_state.dart';
import 'package:mdm/features/history/presentation/widgets/history_entry_tile.dart';
import 'package:mdm/shared/components/app_empty_widget.dart';
import 'package:mdm/shared/components/app_loading_widget.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FavoritesCubit>()..loadFavorites(),
      child: const _FavoritesView(),
    );
  }
}

class _FavoritesView extends StatelessWidget {
  const _FavoritesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox(),
            loading: () => const AppLoadingWidget(),
            loaded: (entries) {
              if (entries.isEmpty) {
                return const AppEmptyWidget(message: 'No favorites yet');
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return HistoryEntryTile(
                    entry: entry,
                    onDelete: () {
                      // We don't delete from history in Favorites page, just unfavorite
                      context.read<FavoritesCubit>().removeFavorite(entry.videoId);
                    },
                    onToggleFavorite: () {
                      context.read<FavoritesCubit>().removeFavorite(entry.videoId);
                    },
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
}
// <<< FavoritesPage =======================
