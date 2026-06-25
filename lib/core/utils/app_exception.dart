// >>> AppException =======================
// Sealed exception hierarchy for typed error handling across the app
sealed class AppException implements Exception {
  final String message;

  const AppException(this.message);

  factory AppException.invalidUrl() = InvalidUrlException;
  factory AppException.networkUnavailable() = NetworkUnavailableException;
  factory AppException.storagePermissionDenied() =
      StoragePermissionDeniedException;
  factory AppException.insufficientStorage(int required, int available) =
      InsufficientStorageException;
  factory AppException.downloadInterrupted() = DownloadInterruptedException;
  factory AppException.videoUnplayable() = VideoUnplayableException;
  factory AppException.mergeFailure() = MergeFailureException;
  factory AppException.parsingFailure() = ParsingFailureException;
  factory AppException.unknown([String? message]) = UnknownException;

  @override
  String toString() => 'AppException: $message';
}

class InvalidUrlException extends AppException {
  InvalidUrlException() : super('The provided URL is not a valid YouTube URL.');
}

class NetworkUnavailableException extends AppException {
  NetworkUnavailableException()
      : super('No internet connection is available.');
}

class StoragePermissionDeniedException extends AppException {
  StoragePermissionDeniedException()
      : super('Storage permission was denied.');
}

class InsufficientStorageException extends AppException {
  final int required;
  final int available;

  InsufficientStorageException(this.required, this.available)
      : super(
          'Insufficient storage. Required: $required bytes, '
          'available: $available bytes.',
        );
}

class DownloadInterruptedException extends AppException {
  DownloadInterruptedException()
      : super('The download was interrupted.');
}

class VideoUnplayableException extends AppException {
  VideoUnplayableException()
      : super('This video is unplayable or restricted.');
}

class MergeFailureException extends AppException {
  MergeFailureException()
      : super('Failed to merge audio and video streams.');
}

class ParsingFailureException extends AppException {
  ParsingFailureException()
      : super('Failed to parse video metadata.');
}

class UnknownException extends AppException {
  UnknownException([String? message])
      : super(message ?? 'An unknown error occurred.');
}
// <<< AppException =======================

// >>> ErrorMessages =======================
// Maps each AppException subtype to a user-friendly display string
abstract class ErrorMessages {
  static String fromException(AppException e) {
    return switch (e) {
      InvalidUrlException() =>
        'That doesn\'t look like a valid YouTube link. Please check and try again.',
      NetworkUnavailableException() =>
        'You appear to be offline. Please check your internet connection.',
      StoragePermissionDeniedException() =>
        'Storage permission is required to save downloads. '
            'Please grant it in Settings.',
      InsufficientStorageException(:final required, :final available) =>
        'Not enough storage space. Need ${_formatBytes(required)} '
            'but only ${_formatBytes(available)} available.',
      DownloadInterruptedException() =>
        'Download was interrupted. Please try again.',
      VideoUnplayableException() =>
        'This video can\'t be played. It may be private, '
            'age-restricted, or region-locked.',
      MergeFailureException() =>
        'Failed to combine audio and video. Please try downloading again.',
      ParsingFailureException() =>
        'Couldn\'t read video information. The link may be invalid or expired.',
      UnknownException() =>
        'Something went wrong. Please try again later.',
    };
  }

  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1073741824) {
      return '${(bytes / 1048576).toStringAsFixed(1)} MB';
    }
    return '${(bytes / 1073741824).toStringAsFixed(1)} GB';
  }
}
// <<< ErrorMessages =======================
