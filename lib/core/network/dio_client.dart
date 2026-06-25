import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:mdm/core/network/interceptors/error_interceptor.dart';
import 'package:mdm/core/network/interceptors/logging_interceptor.dart';

// >>> DioClient =======================
// Lazily-initialized HTTP client with logging and error handling
@lazySingleton
class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors in order: logging first, then error mapping
    _dio.interceptors.addAll([
      LoggingInterceptor(),
      ErrorInterceptor(),
    ]);
  }

  Dio get dio => _dio;
}
// <<< DioClient =======================
