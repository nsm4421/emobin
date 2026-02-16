part of 'display_feed_list_bloc.dart';

@freezed
class DisplayFeedListEvent with _$DisplayFeedListEvent {
  const factory DisplayFeedListEvent.started() = _Started;

  const factory DisplayFeedListEvent.refreshRequested({
    @Default(true) bool showLoading,
  }) = _RefreshRequested;

  const factory DisplayFeedListEvent.entriesUpdated(List<FeedEntry> entries) =
      _EntriesUpdated;

  const factory DisplayFeedListEvent.streamErrorOccurred(
    Object error,
    StackTrace stackTrace,
  ) = _StreamErrorOccurred;
}
