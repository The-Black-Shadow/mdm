import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

import 'package:mdm/core/utils/app_logger.dart';

// >>> NotificationService =======================
// Manages local notifications for download progress, completion, and warnings
@lazySingleton
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // Channel IDs
  static const String _downloadProgressChannelId = 'download_progress';
  static const String _downloadCompleteChannelId = 'download_complete';
  static const String _generalChannelId = 'general';

  // Notification IDs
  static const int _wifiWarningNotificationId = 9000;

  Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channels
    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _downloadProgressChannelId,
          'Download Progress',
          description: 'Shows real-time download progress',
          importance: Importance.low,
          showBadge: false,
          playSound: false,
        ),
      );

      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _downloadCompleteChannelId,
          'Download Complete',
          description: 'Notifies when a download finishes or fails',
          importance: Importance.high,
        ),
      );

      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _generalChannelId,
          'General',
          description: 'General app notifications and warnings',
          importance: Importance.defaultImportance,
        ),
      );
    }

    AppLogger.i('NotificationService initialized');
  }

  // Show download progress notification
  Future<void> showDownloadProgress({
    required int id,
    required String title,
    required int progress,
    required int maxProgress,
  }) async {
    await _plugin.show(
      id: id,
      title: title,
      body: '${((progress / maxProgress) * 100).toInt()}% downloaded',
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _downloadProgressChannelId,
          'Download Progress',
          channelDescription: 'Shows real-time download progress',
          importance: Importance.low,
          priority: Priority.low,
          onlyAlertOnce: true,
          showProgress: true,
          maxProgress: maxProgress,
          progress: progress,
          ongoing: true,
          autoCancel: false,
          playSound: false,
        ),
      ),
    );
  }

  // Show download complete notification
  Future<void> showDownloadComplete({
    required int id,
    required String title,
  }) async {
    await _plugin.show(
      id: id,
      title: 'Download Complete',
      body: title,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _downloadCompleteChannelId,
          'Download Complete',
          channelDescription: 'Notifies when a download finishes or fails',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  // Show download failed notification
  Future<void> showDownloadFailed({
    required int id,
    required String title,
    String? error,
  }) async {
    await _plugin.show(
      id: id,
      title: 'Download Failed',
      body: error != null ? '$title — $error' : title,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _downloadCompleteChannelId,
          'Download Complete',
          channelDescription: 'Notifies when a download finishes or fails',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  // Show Wi-Fi only warning notification
  Future<void> showWifiOnlyWarning() async {
    await _plugin.show(
      id: _wifiWarningNotificationId,
      title: 'Downloads Paused',
      body: 'Waiting for Wi-Fi connection. Change in Settings to use mobile data.',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _generalChannelId,
          'General',
          channelDescription: 'General app notifications and warnings',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          ongoing: true,
          autoCancel: false,
        ),
      ),
    );
  }

  // Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id: id);
  }

  // Cancel all notifications
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  void _onNotificationTapped(NotificationResponse response) {
    AppLogger.d('Notification tapped: ${response.id}');
  }
}
// <<< NotificationService =======================
