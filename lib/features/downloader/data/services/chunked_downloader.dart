import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:mdm/core/constants/app_constants.dart';
import 'package:mdm/core/utils/app_logger.dart';

// >>> ChunkedDownloader =======================
// Downloads a file using parallel HTTP Range requests for maximum speed.
// Falls back to single-connection download if the server doesn't support ranges.
class ChunkedDownloader {
  final int maxConnections;
  final String userAgent;

  ChunkedDownloader({
    this.maxConnections = AppConstants.downloadMaxConnections,
    this.userAgent =
        'com.google.android.apps.youtube.vr.oculus/1.57.29 (Linux; U; Android 12; eureka-user Build/SQ3A.220605.009.A1) gzip',
  });

  /// Downloads [url] to [outputPath] using parallel chunked requests.
  ///
  /// [onProgress] reports aggregated (receivedBytes, totalBytes, speedBps).
  /// [cancelToken] can abort all chunk downloads at once.
  Future<void> download({
    required String url,
    required String outputPath,
    required CancelToken cancelToken,
    required void Function(int receivedBytes, int totalBytes, int speedBps)
        onProgress,
  }) async {
    final dio = Dio(BaseOptions(
      headers: {'User-Agent': userAgent},
      connectTimeout: Duration(milliseconds: AppConstants.connectionTimeout),
      receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
    ));

    try {
      // 1. HEAD request to get total size and check Range support
      final headResponse = await dio.head<void>(
        url,
        options: Options(
          followRedirects: true,
          maxRedirects: 5,
        ),
        cancelToken: cancelToken,
      );

      final contentLength = int.tryParse(
            headResponse.headers.value(HttpHeaders.contentLengthHeader) ?? '',
          ) ??
          -1;

      final acceptRanges =
          headResponse.headers.value(HttpHeaders.acceptRangesHeader);
      final supportsRange =
          acceptRanges != null && acceptRanges.toLowerCase() != 'none';

      if (!supportsRange || contentLength <= 0) {
        AppLogger.d(
            'Server does not support Range requests or unknown size ($contentLength). Falling back to single download.');
        await _singleDownload(
          dio: dio,
          url: url,
          outputPath: outputPath,
          cancelToken: cancelToken,
          onProgress: onProgress,
        );
        return;
      }

      AppLogger.d(
          'Starting chunked download: ${(contentLength / 1024 / 1024).toStringAsFixed(1)} MB with $maxConnections connections');

      // 2. Calculate chunk ranges
      final chunkSize = (contentLength / maxConnections).ceil();
      final chunks = <_ChunkRange>[];

      for (int i = 0; i < maxConnections; i++) {
        final start = i * chunkSize;
        final end = (i + 1) * chunkSize - 1;
        if (start >= contentLength) break;
        chunks.add(_ChunkRange(
          index: i,
          start: start,
          end: end < contentLength ? end : contentLength - 1,
          partPath: '$outputPath.part$i',
        ));
      }

      // 3. Track progress across all chunks
      final chunkReceived = List<int>.filled(chunks.length, 0);
      final stopwatch = Stopwatch()..start();
      int lastTotalReceived = 0;
      int lastSpeedCalcMs = 0;
      int currentSpeed = 0;

      void aggregateProgress() {
        final totalReceived = chunkReceived.fold<int>(0, (a, b) => a + b);

        final elapsedSinceCalc = stopwatch.elapsedMilliseconds - lastSpeedCalcMs;
        if (elapsedSinceCalc >= 500) {
          final bytesInInterval = totalReceived - lastTotalReceived;
          currentSpeed = (bytesInInterval / (elapsedSinceCalc / 1000)).round();
          lastTotalReceived = totalReceived;
          lastSpeedCalcMs = stopwatch.elapsedMilliseconds;
        }

        onProgress(totalReceived, contentLength, currentSpeed);
      }

      // 4. Download all chunks in parallel
      await Future.wait(
        chunks.map((chunk) => _downloadChunk(
              url: url,
              chunk: chunk,
              cancelToken: cancelToken,
              userAgent: userAgent,
              onChunkProgress: (received) {
                chunkReceived[chunk.index] = received;
                aggregateProgress();
              },
            )),
      );

      // 5. Merge chunk files into final output
      final outputFile = File(outputPath);
      final sink = outputFile.openWrite();

      try {
        for (final chunk in chunks) {
          final partFile = File(chunk.partPath);
          await sink.addStream(partFile.openRead());
        }
        await sink.flush();
      } finally {
        await sink.close();
      }

      // 6. Clean up part files
      for (final chunk in chunks) {
        try {
          final partFile = File(chunk.partPath);
          if (await partFile.exists()) await partFile.delete();
        } catch (_) {}
      }

      // Final progress report
      onProgress(contentLength, contentLength, currentSpeed);

      AppLogger.i(
          'Chunked download complete: ${(contentLength / 1024 / 1024).toStringAsFixed(1)} MB in ${stopwatch.elapsed.inSeconds}s');
    } finally {
      dio.close();
    }
  }

  /// Downloads a single chunk using Range header.
  Future<void> _downloadChunk({
    required String url,
    required _ChunkRange chunk,
    required CancelToken cancelToken,
    required String userAgent,
    required void Function(int received) onChunkProgress,
  }) async {
    final partFile = File(chunk.partPath);
    final expectedSize = chunk.end - chunk.start + 1;

    // Resume: skip if part file already has the right size
    if (await partFile.exists()) {
      final existingSize = await partFile.length();
      if (existingSize == expectedSize) {
        onChunkProgress(expectedSize);
        return;
      }
      // Partial — delete and re-download this chunk
      await partFile.delete();
    }

    final chunkDio = Dio(BaseOptions(
      headers: {'User-Agent': userAgent},
      connectTimeout: Duration(milliseconds: AppConstants.connectionTimeout),
      receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
    ));

    try {
      await chunkDio.download(
        url,
        chunk.partPath,
        cancelToken: cancelToken,
        options: Options(
          headers: {'Range': 'bytes=${chunk.start}-${chunk.end}'},
        ),
        onReceiveProgress: (received, _) {
          onChunkProgress(received);
        },
      );
    } finally {
      chunkDio.close();
    }
  }

  /// Fallback: single-connection download when Range is not supported.
  Future<void> _singleDownload({
    required Dio dio,
    required String url,
    required String outputPath,
    required CancelToken cancelToken,
    required void Function(int receivedBytes, int totalBytes, int speedBps)
        onProgress,
  }) async {
    final stopwatch = Stopwatch()..start();
    int previousReceived = 0;
    int lastSpeedCalcMs = 0;
    int currentSpeed = 0;

    await dio.download(
      url,
      outputPath,
      cancelToken: cancelToken,
      onReceiveProgress: (received, total) {
        final elapsedSinceCalc = stopwatch.elapsedMilliseconds - lastSpeedCalcMs;
        if (elapsedSinceCalc >= 1000) {
          currentSpeed =
              ((received - previousReceived) / (elapsedSinceCalc / 1000))
                  .round();
          previousReceived = received;
          lastSpeedCalcMs = stopwatch.elapsedMilliseconds;
        }
        onProgress(received, total > 0 ? total : -1, currentSpeed);
      },
    );
  }

  /// Clean up any leftover part files for a given output path.
  static Future<void> cleanupParts(String outputPath, int maxParts) async {
    for (int i = 0; i < maxParts; i++) {
      try {
        final partFile = File('$outputPath.part$i');
        if (await partFile.exists()) await partFile.delete();
      } catch (_) {}
    }
  }
}

/// Represents a byte range for a single chunk.
class _ChunkRange {
  final int index;
  final int start;
  final int end;
  final String partPath;

  const _ChunkRange({
    required this.index,
    required this.start,
    required this.end,
    required this.partPath,
  });
}
// <<< ChunkedDownloader =======================
