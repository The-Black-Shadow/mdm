import 'package:flutter/material.dart';
import 'package:mdm/core/di/hive_module.dart';
import 'package:mdm/core/di/injection.dart';
import 'package:mdm/core/router/app_router.dart';
import 'package:mdm/core/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdm/core/services/notification_service.dart';
import 'package:mdm/core/services/permission_service.dart';
import 'package:mdm/core/services/clipboard_service.dart';
import 'package:mdm/features/downloader/presentation/bloc/download_bloc.dart';
import 'dart:async';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:mdm/core/constants/route_constants.dart';

// >>> App Entry Point =======================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive (must be before DI since services may use Hive boxes)
  await HiveModule.init();

  // Initialize dependency injection
  await configureDependencies();

  // Initialize notifications
  await getIt<NotificationService>().init();

  runApp(const MdmApp());
}
// <<< App Entry Point =======================

// >>> Root App Widget =======================
class MdmApp extends StatefulWidget {
  const MdmApp({super.key});

  @override
  State<MdmApp> createState() => _MdmAppState();
}

class _MdmAppState extends State<MdmApp> {
  late StreamSubscription _intentSubscription;
  late StreamSubscription _clipboardSubscription;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _initShareIntent();
    _initClipboardService();
  }

  void _initClipboardService() {
    final clipboardService = getIt<ClipboardService>();
    clipboardService.startPolling();
    _clipboardSubscription = clipboardService.onYoutubeUrlFound.listen((url) {
      // In Phase 7 we show a banner, but for now we can just show a snackbar or directly navigate
      // depending on user flow. But navigating automatically is annoying.
      // Let's just log it for Phase 6, or show a Snackbar that can be clicked.
      if (AppRouter.router.routerDelegate.navigatorKey.currentContext != null) {
        final context = AppRouter.router.routerDelegate.navigatorKey.currentContext!;
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('YouTube URL copied: $url'),
            action: SnackBarAction(
              label: 'Download',
              onPressed: () {
                AppRouter.router.pushNamed(RouteConstants.metadata, extra: url);
              },
            ),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    });
  }

  Future<void> _requestPermissions() async {
    final permissionService = getIt<PermissionService>();
    await permissionService.requestNotificationPermission();
    await permissionService.requestStoragePermission();
  }

  void _initShareIntent() {
    // Listen to media sharing incoming from outside the app while the app is in the memory.
    _intentSubscription = ReceiveSharingIntent.instance.getMediaStream().listen((List<SharedMediaFile> value) {
      if (value.isNotEmpty) {
        _handleSharedText(value.first.path);
      }
    }, onError: (err) {
      debugPrint("getIntentDataStream error: $err");
    });

    // Get the media sharing coming from outside the app while the app is closed.
    ReceiveSharingIntent.instance.getInitialMedia().then((List<SharedMediaFile> value) {
      if (value.isNotEmpty) {
        // A slight delay ensures router is ready
        Future.delayed(const Duration(milliseconds: 500), () {
          _handleSharedText(value.first.path);
        });
      }
    });
  }

  void _handleSharedText(String text) {
    // Very basic YouTube URL validation
    if (text.contains('youtube.com') || text.contains('youtu.be')) {
      // Extract URL in case there's extra text
      final urlRegExp = RegExp(r'https?://[^\s]+');
      final match = urlRegExp.firstMatch(text);
      if (match != null) {
        final url = match.group(0)!;
        AppRouter.router.pushNamed(RouteConstants.metadata, extra: url);
      }
    }
  }

  @override
  void dispose() {
    _intentSubscription.cancel();
    _clipboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DownloadBloc>(),
      child: MaterialApp.router(
        title: 'MDM',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.dark,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
// <<< Root App Widget =======================
