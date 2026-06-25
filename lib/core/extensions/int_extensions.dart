// >>> IntExtensions =======================
// Formats int values as human-readable byte sizes and transfer speeds
extension IntX on int {
  String get formatBytes {
    if (this < 1024) return '$this B';
    if (this < 1048576) return '${(this / 1024).toStringAsFixed(1)} KB';
    if (this < 1073741824) {
      return '${(this / 1048576).toStringAsFixed(1)} MB';
    }
    return '${(this / 1073741824).toStringAsFixed(2)} GB';
  }

  String get formatSpeed {
    if (this < 1024) return '$this B/s';
    if (this < 1048576) return '${(this / 1024).toStringAsFixed(1)} KB/s';
    if (this < 1073741824) {
      return '${(this / 1048576).toStringAsFixed(1)} MB/s';
    }
    return '${(this / 1073741824).toStringAsFixed(2)} GB/s';
  }
}
// <<< IntExtensions =======================
