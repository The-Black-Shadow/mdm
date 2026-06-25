import 'package:mdm/core/utils/app_exception.dart';

// >>> Result =======================
// Sealed union for success/failure outcomes throughout the app
sealed class Result<T> {
  const Result();

  factory Result.success(T data) = Success<T>;
  factory Result.failure(AppException exception) = Failure<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get dataOrNull => switch (this) {
    Success(:final data) => data,
    Failure() => null,
  };

  AppException? get exceptionOrNull => switch (this) {
    Success() => null,
    Failure(:final exception) => exception,
  };

  R when<R>({
    required R Function(T data) success,
    required R Function(AppException exception) failure,
  }) {
    return switch (this) {
      Success(:final data) => success(data),
      Failure(:final exception) => failure(exception),
    };
  }
}

class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final AppException exception;

  const Failure(this.exception);
}
// <<< Result =======================
