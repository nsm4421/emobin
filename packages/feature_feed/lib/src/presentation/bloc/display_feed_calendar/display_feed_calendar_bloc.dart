import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/usecase/feed_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/fetch_feed_by_year_month_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'display_feed_calendar_bloc.freezed.dart';

part 'display_feed_calendar_event.dart';

part 'display_feed_calendar_state.dart';

@injectable
class DisplayFeedCalendarBloc
    extends Bloc<DisplayFeedCalendarEvent, DisplayFeedCalendarState> {
  DisplayFeedCalendarBloc(FeedUseCase feedUseCase)
    : _useCase = feedUseCase.fetchLocalEntriesByYearMonth,
      super(DisplayFeedCalendarState(focusedMonth: _currentMonth())) {
    on<DisplayFeedCalendarEvent>(_onEvent);
  }

  final FetchLocalFeedEntriesByYearMonthUseCase _useCase;

  Future<void> _onEvent(
    DisplayFeedCalendarEvent event,
    Emitter<DisplayFeedCalendarState> emit,
  ) async {
    await event.when(
      started: (focusedMonth) async {
        final targetMonth = _normalizedMonth(
          focusedMonth ?? state.focusedMonth,
        );
        final isMonthChanged = targetMonth != state.focusedMonth;
        if (isMonthChanged) {
          emit(state.copyWith(focusedMonth: targetMonth));
        }
        await _refresh(
          emit,
          focusedMonth: targetMonth,
          showLoading: state.entries.isEmpty || isMonthChanged,
        );
      },
      refreshRequested: (showLoading) async {
        await _refresh(
          emit,
          focusedMonth: state.focusedMonth,
          showLoading: showLoading,
        );
      },
      monthChanged: (focusedMonth, showLoading) async {
        final targetMonth = _normalizedMonth(focusedMonth);
        if (targetMonth != state.focusedMonth) {
          emit(state.copyWith(focusedMonth: targetMonth));
        }
        await _refresh(
          emit,
          focusedMonth: targetMonth,
          showLoading: showLoading,
        );
      },
    );
  }

  Future<void> _refresh(
    Emitter<DisplayFeedCalendarState> emit, {
    required DateTime focusedMonth,
    required bool showLoading,
  }) async {
    if (showLoading) {
      emit(
        state.copyWith(
          status: DisplayFeedCalendarStatus.loading,
          failure: null,
          focusedMonth: focusedMonth,
        ),
      );
    }

    final result = await _useCase(
      year: focusedMonth.year,
      month: focusedMonth.month,
    );
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DisplayFeedCalendarStatus.failure,
          failure: failure,
          focusedMonth: focusedMonth,
        ),
      ),
      (entries) => emit(
        state.copyWith(
          status: DisplayFeedCalendarStatus.success,
          entries: entries,
          failure: null,
          focusedMonth: focusedMonth,
        ),
      ),
    );
  }

  static DateTime _currentMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  DateTime _normalizedMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month);
  }
}
