// >>> Validators =======================
// Static validation utilities for YouTube URLs and file names
abstract class Validators {
  static final RegExp _youtubeUrlPattern = RegExp(
    r'^(?:https?://)?(?:www\.|m\.)?'
    r'(?:'
    r'youtube\.com/watch\?.*v=([a-zA-Z0-9_-]{11})'
    r'|youtu\.be/([a-zA-Z0-9_-]{11})'
    r'|youtube\.com/shorts/([a-zA-Z0-9_-]{11})'
    r')',
  );

  static final RegExp _invalidFileNameChars = RegExp(r'[<>:"/\\|?*\x00-\x1F]');

  static bool isValidYouTubeUrl(String url) {
    return _youtubeUrlPattern.hasMatch(url.trim());
  }

  static String? extractVideoId(String url) {
    final match = _youtubeUrlPattern.firstMatch(url.trim());
    if (match == null) return null;
    return match.group(1) ?? match.group(2) ?? match.group(3);
  }

  static bool isValidFileName(String name) {
    if (name.isEmpty || name.length > 255) return false;
    if (_invalidFileNameChars.hasMatch(name)) return false;
    if (name.endsWith('.') || name.endsWith(' ')) return false;
    return true;
  }
}
// <<< Validators =======================
