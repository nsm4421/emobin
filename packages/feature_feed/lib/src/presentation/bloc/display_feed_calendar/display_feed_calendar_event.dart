part of 'display_feed_calendar_bloc.dart';

@freezed
class DisplayFeedCalendarEvent with _$DisplayFeedCalendarEvent {
  const factory DisplayFeedCalendarEvent.started({DateTime? focusedMonth}) =
      _Started;

  const factory DisplayFeedCalendarEvent.refreshRequested({
    @Default(true) bool showLoading,
  }) = _RefreshRequested;

  const factory DisplayFeedCalendarEvent.monthChanged({
    required DateTime focusedMonth,
    @Default(true) bool showLoading,
  }) = _MonthChanged;
}
