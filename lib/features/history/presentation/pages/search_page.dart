// >>> SearchPage =======================
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdm/core/di/injection.dart';
import 'package:mdm/core/theme/app_spacing.dart';
import 'package:mdm/features/history/presentation/cubit/search_cubit.dart';
import 'package:mdm/features/history/presentation/cubit/search_state.dart';
import 'package:mdm/features/history/presentation/widgets/history_entry_tile.dart';
import 'package:mdm/shared/components/app_empty_widget.dart';
import 'package:mdm/shared/components/app_loading_widget.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SearchCubit>(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      context.read<SearchCubit>().performSearch(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search downloaded media...',
            border: InputBorder.none,
          ),
          onChanged: _onSearchChanged,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _onSearchChanged('');
                setState(() {});
              },
            ),
        ],
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(
              child: Text('Type to start searching'),
            ),
            loading: () => const AppLoadingWidget(),
            loaded: (results) {
              if (results.isEmpty) {
                return const AppEmptyWidget(message: 'No matching media found');
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final entry = results[index];
                  return HistoryEntryTile(
                    entry: entry,
                    onDelete: () {
                      // Delete is maybe too complex from search if we want it synced 
                      // across history without a global state, but we'll leave it as a no-op 
                      // for now or redirect to history.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Delete from History page instead')),
                      );
                    },
                    onToggleFavorite: () {
                       ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Toggle from History page instead')),
                      );
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
// <<< SearchPage =======================
