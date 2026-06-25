// >>> PermissionService =======================
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:mdm/core/utils/app_logger.dart';
import 'package:permission_handler/permission_handler.dart';

@lazySingleton
class PermissionService {
  Future<bool> requestStoragePermission() async {
    if (!Platform.isAndroid) return true;

    try {
      final plugin = DeviceInfoPlugin();
      final androidInfo = await plugin.androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 33) {
        // Android 13+
        final videos = await Permission.videos.request();
        final audio = await Permission.audio.request();
        return videos.isGranted && audio.isGranted;
      } else {
        // Android 12 and below
        final storage = await Permission.storage.request();
        return storage.isGranted;
      }
    } catch (e) {
      AppLogger.e('Error requesting storage permission', e);
      return false;
    }
  }

  Future<bool> requestNotificationPermission() async {
    if (!Platform.isAndroid) return true;
    final status = await Permission.notification.request();
    return status.isGranted;
  }
}
// <<< PermissionService =======================
