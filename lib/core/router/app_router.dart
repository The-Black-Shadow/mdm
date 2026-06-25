import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:mdm/core/constants/route_constants.dart';
import 'package:mdm/core/di/injection.dart';
import 'package:mdm/features/downloader/domain/entities/video_metadata.dart';
import 'package:mdm/features/downloader/domain/usecases/fetch_metadata_usecase.dart';
import 'package:mdm/features/downloader/presentation/bloc/metadata_bloc.dart';
import 'package:mdm/features/downloader/presentation/pages/metadata_page.dart';
import 'package:mdm/features/downloader/presentation/pages/quality_selection_page.dart';
import 'package:mdm/features/downloads/presentation/pages/downloads_page.dart';
import 'package:mdm/features/history/presentation/pages/favorites_page.dart';
import 'package:mdm/features/history/presentation/pages/history_page.dart';
import 'package:mdm/features/history/presentation/pages/search_page.dart';

// >>> App Router =======================
// GoRouter configuration with all application routes
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteConstants.home,
    routes: [
      // Home route
      GoRoute(
        path: RouteConstants.home,
        name: 'home',
        builder: (context, state) => const _StubPage(name: 'Home'),
      ),

      // Metadata route — receives YouTube URL via extra
      GoRoute(
        path: RouteConstants.metadata,
        name: 'metadata',
        builder: (context, state) {
          final url = state.extra as String? ?? '';
          return BlocProvider(
            create: (_) => MetadataBloc(
              getIt<FetchMetadataUseCase>(),
            )..add(FetchMetadataEvent(url: url)),
            child: const MetadataPage(),
          );
        },
      ),

      // Quality selection route — receives metadata + audioOnly flag via extra
      GoRoute(
        path: RouteConstants.qualitySelection,
        name: 'qualitySelection',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final metadata = extra['metadata'] as VideoMetadata;
          final audioOnly = extra['audioOnly'] as bool? ?? false;
          return QualitySelectionPage(
            metadata: metadata,
            initialAudioOnly: audioOnly,
          );
        },
      ),

      // Downloads route
      GoRoute(
        path: RouteConstants.downloads,
        name: 'downloads',
        builder: (context, state) => const DownloadsPage(),
      ),

      // Player route
      GoRoute(
        path: RouteConstants.player,
        name: 'player',
        builder: (context, state) => const _StubPage(name: 'Player'),
      ),

      // History route
      GoRoute(
        path: RouteConstants.history,
        name: 'history',
        builder: (context, state) => const HistoryPage(),
      ),

      // Favorites route
      GoRoute(
        path: RouteConstants.favorites,
        name: 'favorites',
        builder: (context, state) => const FavoritesPage(),
      ),

      // Settings route
      GoRoute(
        path: RouteConstants.settings,
        name: 'settings',
        builder: (context, state) => const _StubPage(name: 'Settings'),
      ),

      // Search route
      GoRoute(
        path: RouteConstants.search,
        name: 'search',
        builder: (context, state) => const SearchPage(),
      ),
    ],
  );
}
// <<< App Router =======================

// >>> Stub Page =======================
// Temporary placeholder page shown until feature pages are built
class _StubPage extends StatelessWidget {
  final String name;

  const _StubPage({required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(name, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Coming soon',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

// <<< Stub Page =======================
