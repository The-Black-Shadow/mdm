import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

// >>> PermissionHelper =======================
// Handles runtime permission requests with Android SDK version awareness
class PermissionHelper {
  PermissionHelper._();

  static Future<bool> requestStoragePermission() async {
    if (!Platform.isAndroid) return true;

    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    if (sdkInt >= 33) {
      // Android 13+ — granular media permissions
      final statuses = await [
        Permission.photos,
        Permission.videos,
        Permission.audio,
      ].request();

      return statuses.values.every(
        (status) => status.isGranted || status.isLimited,
      );
    } else if (sdkInt >= 30) {
      // Android 11-12 — manage external storage
      final status = await Permission.manageExternalStorage.request();
      return status.isGranted;
    } else {
      // Android 10 and below
      final status = await Permission.storage.request();
      return status.isGranted;
    }
  }

  static Future<bool> requestNotificationPermission() async {
    if (!Platform.isAndroid) return true;

    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;

    if (androidInfo.version.sdkInt >= 33) {
      final status = await Permission.notification.request();
      return status.isGranted;
    }

    return true;
  }

  static Future<bool> checkStoragePermission() async {
    if (!Platform.isAndroid) return true;

    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    if (sdkInt >= 33) {
      return await Permission.photos.isGranted &&
          await Permission.videos.isGranted;
    } else if (sdkInt >= 30) {
      return await Permission.manageExternalStorage.isGranted;
    } else {
      return await Permission.storage.isGranted;
    }
  }
}
// <<< PermissionHelper =======================
