part of 'home_record_status_cubit.dart';

@freezed
abstract class HomeRecordStatusState with _$HomeRecordStatusState {
  const factory HomeRecordStatusState({
    @Default(false) bool isLoading,
    @Default(FeedRecordStatus()) FeedRecordStatus recordStatus,
  }) = _HomeRecordStatusState;
}
