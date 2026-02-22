part of 'feed_trash_cubit.dart';

enum FeedTrashStatus { initial, loading, success, failure }

@freezed
abstract class FeedTrashState with _$FeedTrashState {
  const factory FeedTrashState({
    @Default(FeedTrashStatus.initial) FeedTrashStatus status,
    @Default(<FeedEntry>[]) List<FeedEntry> entries,
    FeedFailure? failure,
    @Default(<String>{}) Set<String> busyEntryIds,
  }) = _FeedTrashState;
}
