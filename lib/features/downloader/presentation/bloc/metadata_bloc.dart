// >>> MetadataBLoC =======================
// Orchestrates video metadata fetching with retry support
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdm/features/downloader/domain/entities/video_metadata.dart';
import 'package:mdm/features/downloader/domain/usecases/fetch_metadata_usecase.dart';
import 'package:mdm/core/utils/app_exception.dart';
import 'package:mdm/core/utils/app_logger.dart';

part 'metadata_event.dart';
part 'metadata_state.dart';

class MetadataBloc extends Bloc<MetadataEvent, MetadataState> {
  final FetchMetadataUseCase _fetchMetadataUseCase;
  String? _lastUrl;

  // ignore: prefer_initializing_formals
  MetadataBloc({required FetchMetadataUseCase fetchMetadataUseCase})
      : _fetchMetadataUseCase = fetchMetadataUseCase,
        super(const MetadataInitial()) {
    on<FetchMetadataEvent>(_onFetchMetadata);
    on<RetryMetadataEvent>(_onRetryMetadata);
  }

  Future<void> _onFetchMetadata(
    FetchMetadataEvent event,
    Emitter<MetadataState> emit,
  ) async {
    _lastUrl = event.url;
    AppLogger.i('MetadataBloc: Fetching metadata for URL: ${event.url}');
    emit(const MetadataLoading());

    try {
      final result = await _fetchMetadataUseCase(event.url);
      
      result.when(
        success: (metadata) {
          AppLogger.i('MetadataBloc: Metadata loaded for "${metadata.title}"');
          emit(MetadataLoaded(metadata: metadata));
        },
        failure: (exception) {
          final message = ErrorMessages.fromException(exception);
          final isNetwork = exception is NetworkUnavailableException;
          AppLogger.e('MetadataBloc: Fetch failed — $message', exception);
          emit(MetadataError(message: message, isNetworkError: isNetwork));
        },
      );
    } catch (e, stackTrace) {
      final message = ErrorMessages.fromException(AppException.unknown());
      AppLogger.e('MetadataBloc: Unexpected error', e, stackTrace);
      emit(MetadataError(message: message));
    }
  }

  Future<void> _onRetryMetadata(
    RetryMetadataEvent event,
    Emitter<MetadataState> emit,
  ) async {
    if (_lastUrl == null) {
      AppLogger.w('MetadataBloc: Retry requested but no previous URL stored');
      return;
    }
    AppLogger.i('MetadataBloc: Retrying metadata fetch for URL: $_lastUrl');
    add(FetchMetadataEvent(url: _lastUrl!));
  }
}
// <<< MetadataBLoC =======================
