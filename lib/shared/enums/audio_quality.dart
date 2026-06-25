// >>> AudioQuality =======================
// Available audio bitrate options
enum AudioQuality {
  high('320kbps', 320),
  medium('192kbps', 192),
  low('128kbps', 128),
  veryLow('64kbps', 64);

  final String label;
  final int bitrate;

  const AudioQuality(this.label, this.bitrate);
}
// <<< AudioQuality =======================
