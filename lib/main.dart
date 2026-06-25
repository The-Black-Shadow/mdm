import 'package:flutter/material.dart';
import 'package:mdm/core/di/hive_module.dart';
import 'package:mdm/core/di/injection.dart';
import 'package:mdm/core/router/app_router.dart';
import 'package:mdm/core/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdm/core/services/notification_service.dart';
import 'package:mdm/features/downloader/presentation/bloc/download_bloc.dart';

// >>> App Entry Point =======================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive (must be before DI since services may use Hive boxes)
  await HiveModule.init();

  // Initialize dependency injection
  await configureDependencies();

  // Initialize notifications
  await getIt<NotificationService>().init();

  runApp(const YTDownApp());
}
// <<< App Entry Point =======================

// >>> Root App Widget =======================
class YTDownApp extends StatelessWidget {
  const YTDownApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DownloadBloc>(),
      child: MaterialApp.router(
        title: 'YTDown',
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
