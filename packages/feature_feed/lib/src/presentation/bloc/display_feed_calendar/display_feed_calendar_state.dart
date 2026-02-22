part of 'display_feed_calendar_bloc.dart';

enum DisplayFeedCalendarStatus { initial, loading, success, failure }

@freezed
class DisplayFeedCalendarState with _$DisplayFeedCalendarState {
  const DisplayFeedCalendarState({
    required this.focusedMonth,
    this.status = DisplayFeedCalendarStatus.initial,
    this.entries = const <FeedEntry>[],
    this.failure,
  });

  @override
  final DateTime focusedMonth;

  @override
  final DisplayFeedCalendarStatus status;

  @override
  final List<FeedEntry> entries;

  @override
  final FeedFailure? failure;
}
