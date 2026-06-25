import 'dart:async';

import 'package:flutter/services.dart';

import 'package:mdm/core/utils/app_logger.dart';
import 'package:mdm/core/utils/validators.dart';

// >>> ClipboardService =======================
// Polls the clipboard periodically and emits detected YouTube URLs via a stream
class ClipboardService {
  Timer? _timer;
  String? _lastDetectedUrl;

  final StreamController<String?> _clipboardController =
      StreamController<String?>.broadcast();

  Stream<String?> get clipboardUrlStream => _clipboardController.stream;

  // Start polling the clipboard every 2 seconds
  void startPolling() {
    stopPolling();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) => _checkClipboard());
    AppLogger.d('ClipboardService: polling started');
  }

  // Stop polling the clipboard
  void stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _checkClipboard() async {
    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      final text = data?.text?.trim();

      if (text == null || text.isEmpty) return;
      if (text == _lastDetectedUrl) return;

      if (Validators.isValidYouTubeUrl(text)) {
        _lastDetectedUrl = text;
        _clipboardController.add(text);
        AppLogger.d('ClipboardService: detected YouTube URL → $text');
      }
    } catch (e) {
      // Clipboard access can fail when app is in background
      AppLogger.w('ClipboardService: clipboard read failed', e);
    }
  }

  // Clean up resources
  void dispose() {
    stopPolling();
    _clipboardController.close();
    AppLogger.d('ClipboardService: disposed');
  }
}
// <<< ClipboardService =======================
