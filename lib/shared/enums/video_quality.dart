// >>> VideoQuality =======================
// Available video resolution options
enum VideoQuality {
  q2160p('2160p'),
  q1440p('1440p'),
  q1080p('1080p'),
  q720p('720p'),
  q480p('480p'),
  q360p('360p'),
  q240p('240p'),
  q144p('144p');

  final String label;

  const VideoQuality(this.label);
}
// <<< VideoQuality =======================
