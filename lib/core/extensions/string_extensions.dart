import 'package:mdm/core/utils/validators.dart';

// >>> StringExtensions =======================
// Convenience getters and methods on String for YouTube URLs and truncation
extension StringX on String {
  bool get isValidYouTubeUrl => Validators.isValidYouTubeUrl(this);

  String? get youtubeVideoId => Validators.extractVideoId(this);

  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    if (maxLength <= 3) return substring(0, maxLength);
    return '${substring(0, maxLength - 3)}...';
  }
}
// <<< StringExtensions =======================
