import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'package:mdm/core/constants/app_constants.dart';

// >>> FileHelper =======================
// Static utilities for file name sanitization and directory resolution
class FileHelper {
  FileHelper._();

  static final RegExp _invalidChars = RegExp(r'[<>:"/\\|?*\x00-\x1F]');
  static final RegExp _multipleSpaces = RegExp(r'\s+');

  static String sanitizeFileName(String name) {
    var sanitized = name.replaceAll(_invalidChars, '_');
    sanitized = sanitized.replaceAll(_multipleSpaces, ' ').trim();

    if (sanitized.length > AppConstants.maxVideoTitleLength) {
      sanitized = sanitized.substring(0, AppConstants.maxVideoTitleLength);
    }

    if (sanitized.isEmpty) sanitized = 'download';

    return sanitized;
  }

  static Future<Directory> getDownloadDirectory() async {
    Directory? directory;

    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download/'
          '${AppConstants.defaultDownloadFolder}');
    } else if (Platform.isIOS) {
      final appDir = await getApplicationDocumentsDirectory();
      directory = Directory(
        '${appDir.path}/${AppConstants.defaultDownloadFolder}',
      );
    } else {
      final downloadsDir = await getDownloadsDirectory();
      directory = Directory(
        '${downloadsDir?.path ?? '.'}/${AppConstants.defaultDownloadFolder}',
      );
    }

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    return directory;
  }

  static Future<Directory> getTempDirectory() async {
    final tempDir = await getTemporaryDirectory();
    final dir = Directory('${tempDir.path}/${AppConstants.packageName}');

    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    return dir;
  }

  static Future<Directory> getCacheDirectory() async {
    final cacheDir = await getApplicationCacheDirectory();
    final dir = Directory('${cacheDir.path}/${AppConstants.packageName}');

    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    return dir;
  }
}
// <<< FileHelper =======================
