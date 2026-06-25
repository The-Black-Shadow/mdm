import 'package:dio/dio.dart';

import 'package:mdm/core/utils/app_logger.dart';

// >>> LoggingInterceptor =======================
// Logs HTTP request/response details including method, URL, status, and duration
class LoggingInterceptor extends Interceptor {
  final Map<RequestOptions, DateTime> _requestTimestamps = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _requestTimestamps[options] = DateTime.now();
    AppLogger.d(
      '→ ${options.method.toUpperCase()} ${options.uri}',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final duration = _calculateDuration(response.requestOptions);
    AppLogger.i(
      '← ${response.statusCode} '
      '${response.requestOptions.method.toUpperCase()} '
      '${response.requestOptions.uri} '
      '(${duration}ms)',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final duration = _calculateDuration(err.requestOptions);
    AppLogger.e(
      '✖ ${err.type.name} '
      '${err.requestOptions.method.toUpperCase()} '
      '${err.requestOptions.uri} '
      '(${duration}ms)',
      err.error,
      err.stackTrace,
    );
    handler.next(err);
  }

  int _calculateDuration(RequestOptions options) {
    final startTime = _requestTimestamps.remove(options);
    if (startTime == null) return -1;
    return DateTime.now().difference(startTime).inMilliseconds;
  }
}
// <<< LoggingInterceptor =======================
