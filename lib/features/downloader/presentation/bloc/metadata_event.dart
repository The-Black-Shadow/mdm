// >>> MetadataEvent =======================
// Events that trigger metadata fetching operations in the MetadataBLoC
part of 'metadata_bloc.dart';

sealed class MetadataEvent {
  const MetadataEvent();
}

final class FetchMetadataEvent extends MetadataEvent {
  final String url;
  const FetchMetadataEvent({required this.url});
}

final class RetryMetadataEvent extends MetadataEvent {
  const RetryMetadataEvent();
}
// <<< MetadataEvent =======================
