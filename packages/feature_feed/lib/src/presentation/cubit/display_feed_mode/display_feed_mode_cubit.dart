import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'display_feed_mode_state.dart';

part 'display_feed_mode_cubit.freezed.dart';

@lazySingleton
class DisplayFeedModeCubit extends Cubit<DisplayFeedModeState> {
  DisplayFeedModeCubit() : super(DisplayFeedModeState.list()) {
    _focusedMonthCache = _toMonth(DateTime.now());
  }

  late DateTime _focusedMonthCache;

  DateTime get focusedMonthCache => _focusedMonthCache;

  void toList() {
    emit(DisplayFeedModeState.list());
  }

  void toCalendar([DateTime? focusedMonth]) {
    _focusedMonthCache = _toMonth(focusedMonth ?? _focusedMonthCache);
    emit(DisplayFeedModeState.calendar(_focusedMonthCache));
  }

  DateTime _toMonth(DateTime dt) {
    return DateTime(dt.year, dt.month, 1);
  }
}
