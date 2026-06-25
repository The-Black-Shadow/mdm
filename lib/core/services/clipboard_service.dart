// >>> ClipboardService =======================
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:mdm/core/utils/app_logger.dart';

import 'package:mdm/features/history/domain/repositories/history_repository.dart';

@lazySingleton
class ClipboardService {
  final HistoryRepository _historyRepository;
  Timer? _timer;
  String _lastCheckedUrl = '';
  
  // Stream to emit found YouTube URLs
  final _urlController = StreamController<String>.broadcast();
  Stream<String> get onYoutubeUrlFound => _urlController.stream;

  ClipboardService(this._historyRepository);

  void startPolling() {
    if (_timer != null && _timer!.isActive) return;
    
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      try {
        final data = await Clipboard.getData(Clipboard.kTextPlain);
        if (data != null && data.text != null) {
          final text = data.text!.trim();
          
          if (text != _lastCheckedUrl) {
            _lastCheckedUrl = text;
            
            if (_isYoutubeUrl(text)) {
              final historyResult = await _historyRepository.getHistory();
              bool alreadyDownloaded = false;
              if (historyResult.isSuccess) {
                final history = historyResult.dataOrNull!;
                alreadyDownloaded = history.any((entry) => text.contains(entry.videoId));
              }
              
              if (!alreadyDownloaded) {
                AppLogger.d('Found new YouTube URL in clipboard: $text');
                _urlController.add(text);
              } else {
                AppLogger.d('Clipboard URL already in history: $text');
              }
            }
          }
        }
      } catch (e) {
        // Ignore clipboard access errors (e.g. permission denied)
      }
    });
  }

  void stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  bool _isYoutubeUrl(String text) {
    if (!text.contains('youtube.com') && !text.contains('youtu.be')) return false;
    final urlRegExp = RegExp(r'^https?://[^\s]+$');
    return urlRegExp.hasMatch(text);
  }
}
// <<< ClipboardService =======================
