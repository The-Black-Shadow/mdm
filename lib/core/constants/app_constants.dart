// >>> AppConstants =======================
// All numeric and string constants used across the application
abstract class AppConstants {
  // App info
  static const String appName = 'MDM';
  static const String appVersion = '1.0.0';
  static const String packageName = 'mdm';

  // Download
  static const int maxConcurrentDownloads = 3;
  static const int downloadChunkSize = 1024 * 1024; // 1 MB
  static const int downloadBufferSize = 8192; // 8 KB
  static const int maxRetryAttempts = 3;
  static const int retryDelaySeconds = 2;

  // Timeouts (milliseconds)
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 60000;
  static const int sendTimeout = 30000;

  // YouTube
  static const int maxVideoTitleLength = 100;
  static const int videoIdLength = 11;

  // UI
  static const double defaultBorderRadius = 16.0;
  static const double cardBorderRadius = 12.0;
  static const double buttonBorderRadius = 8.0;
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double thumbnailAspectRatio = 16 / 9;
  static const double bottomSheetMaxHeight = 0.85;
  static const double progressBarHeight = 4.0;

  // Animation durations (milliseconds)
  static const int shortAnimationDuration = 200;
  static const int mediumAnimationDuration = 350;
  static const int longAnimationDuration = 500;

  // Storage keys
  static const String themeKey = 'app_theme_mode';
  static const String downloadPathKey = 'download_path';
  static const String notificationKey = 'notifications_enabled';
  static const String firstLaunchKey = 'is_first_launch';

  // File
  static const String defaultDownloadFolder = 'MDM';
  static const int minFreeStorageBytes = 50 * 1024 * 1024; // 50 MB
}
// <<< AppConstants =======================
