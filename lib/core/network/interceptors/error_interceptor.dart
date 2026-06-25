import 'package:dio/dio.dart';

import 'package:mdm/core/utils/app_exception.dart';
import 'package:mdm/core/utils/app_logger.dart';

// >>> ErrorInterceptor =======================
// Maps DioExceptionType to typed AppException for consistent error handling
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final appException = _mapToAppException(err);
    AppLogger.w('ErrorInterceptor mapped ${err.type.name} → $appException');

    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: appException,
        stackTrace: err.stackTrace,
        message: appException.message,
      ),
    );
  }

  AppException _mapToAppException(DioException err) {
    return switch (err.type) {
      DioExceptionType.connectionTimeout =>
        AppException.networkUnavailable(),
      DioExceptionType.sendTimeout =>
        AppException.networkUnavailable(),
      DioExceptionType.receiveTimeout =>
        AppException.networkUnavailable(),
      DioExceptionType.connectionError =>
        AppException.networkUnavailable(),
      DioExceptionType.badResponse =>
        _mapBadResponse(err.response?.statusCode),
      DioExceptionType.cancel =>
        AppException.downloadInterrupted(),
      DioExceptionType.badCertificate =>
        AppException.unknown('SSL certificate error'),
      DioExceptionType.unknown =>
        AppException.unknown(err.message),
    };
  }

  AppException _mapBadResponse(int? statusCode) {
    if (statusCode == null) {
      return AppException.unknown('No response received');
    }
    return switch (statusCode) {
      400 => AppException.invalidUrl(),
      403 => AppException.videoUnplayable(),
      404 => AppException.invalidUrl(),
      429 => AppException.unknown('Too many requests. Please try again later.'),
      >= 500 => AppException.unknown('Server error. Please try again later.'),
      _ => AppException.unknown('Unexpected response: $statusCode'),
    };
  }
}
// <<< ErrorInterceptor =======================
