part of 'display_feed_mode_cubit.dart';

@freezed
class DisplayFeedModeState with _$DisplayFeedModeState {
  const factory DisplayFeedModeState.list() = _ListState;

  const factory DisplayFeedModeState.calendar(DateTime focusedMonth) =
      _CalendarState;
}
