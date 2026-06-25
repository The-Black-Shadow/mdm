import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:mdm/core/constants/route_constants.dart';

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
          return _StubPage(name: 'Metadata', subtitle: url);
        },
      ),

      // Quality selection route
      GoRoute(
        path: RouteConstants.qualitySelection,
        name: 'qualitySelection',
        builder: (context, state) =>
            const _StubPage(name: 'Quality Selection'),
      ),

      // Downloads route
      GoRoute(
        path: RouteConstants.downloads,
        name: 'downloads',
        builder: (context, state) => const _StubPage(name: 'Downloads'),
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
        builder: (context, state) => const _StubPage(name: 'History'),
      ),

      // Favorites route
      GoRoute(
        path: RouteConstants.favorites,
        name: 'favorites',
        builder: (context, state) => const _StubPage(name: 'Favorites'),
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
        builder: (context, state) => const _StubPage(name: 'Search'),
      ),
    ],
  );
}
// <<< App Router =======================

// >>> Stub Page =======================
// Temporary placeholder page shown until feature pages are built
class _StubPage extends StatelessWidget {
  final String name;
  final String? subtitle;

  const _StubPage({required this.name, this.subtitle});

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
            Text(
              name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            if (subtitle != null && subtitle!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
// <<< Stub Page =======================
