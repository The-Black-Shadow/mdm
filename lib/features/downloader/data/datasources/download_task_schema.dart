// >>> DownloadTaskSchema =======================
// Hive persistence schema for download tasks (typeId: 0)
import 'package:hive_ce/hive_ce.dart';

part 'download_task_schema.g.dart';

@HiveType(typeId: 0)
class DownloadTaskSchema extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String videoId;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String thumbnailUrl;

  @HiveField(4)
  final String videoUrl;

  @HiveField(5)
  final String? audioUrl;

  @HiveField(6)
  final String outputPath;

  @HiveField(7)
  int statusIndex;

  @HiveField(8)
  double progress;

  @HiveField(9)
  String? errorMessage;

  @HiveField(10)
  final int streamItag;

  @HiveField(11)
  final String streamType;

  @HiveField(12)
  final String? streamResolution;

  @HiveField(13)
  final String streamCodec;

  @HiveField(14)
  final String streamContainer;

  @HiveField(15)
  final int? streamBitrate;

  @HiveField(16)
  final bool streamRequiresMerge;

  @HiveField(17)
  final DateTime createdAt;

  @HiveField(18)
  DateTime? completedAt;

  @HiveField(19)
  final int? estimatedSizeBytes;

  @HiveField(20)
  final bool extractAudio;

  @HiveField(21)
  final String channelName;

  DownloadTaskSchema({
    required this.id,
    required this.videoId,
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
    this.audioUrl,
    required this.outputPath,
    required this.statusIndex,
    this.progress = 0.0,
    this.errorMessage,
    required this.streamItag,
    required this.streamType,
    this.streamResolution,
    required this.streamCodec,
    required this.streamContainer,
    this.streamBitrate,
    required this.streamRequiresMerge,
    required this.createdAt,
    this.completedAt,
    this.estimatedSizeBytes,
    this.extractAudio = false,
    this.channelName = 'Unknown Channel',
  });
}
// <<< DownloadTaskSchema =======================
