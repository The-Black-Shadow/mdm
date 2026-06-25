// >>> MetadataState =======================
// States emitted by MetadataBLoC during the metadata fetch lifecycle
part of 'metadata_bloc.dart';

sealed class MetadataState {
  const MetadataState();
}

final class MetadataInitial extends MetadataState {
  const MetadataInitial();
}

final class MetadataLoading extends MetadataState {
  const MetadataLoading();
}

final class MetadataLoaded extends MetadataState {
  final VideoMetadata metadata;
  const MetadataLoaded({required this.metadata});
}

final class MetadataError extends MetadataState {
  final String message;
  final bool isNetworkError;
  const MetadataError({required this.message, this.isNetworkError = false});
}
// <<< MetadataState =======================
