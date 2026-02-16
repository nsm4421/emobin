part of 'display_feed_list_bloc.dart';

enum DisplayFeedListStatus { initial, loading, success, failure }

@freezed
class DisplayFeedListState with _$DisplayFeedListState {
  const DisplayFeedListState({
    this.status = DisplayFeedListStatus.initial,
    this.entries = const <FeedEntry>[],
    this.failure,
  });

  @override
  final DisplayFeedListStatus status;

  @override
  final List<FeedEntry> entries;

  @override
  final FeedFailure? failure;
}
