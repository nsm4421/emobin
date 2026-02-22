import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_record_status.freezed.dart';

@freezed
abstract class FeedRecordStatus with _$FeedRecordStatus {
  const factory FeedRecordStatus({
    @Default(false) bool todayDone,
    @Default(0) int streakDays,
    @Default(0) int thisWeekCount,
  }) = _FeedRecordStatus;
}
