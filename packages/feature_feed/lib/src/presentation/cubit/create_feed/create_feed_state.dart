part of 'create_feed_cubit.dart';

enum CreateFeedStatus { initial, submitting, success, failure }

@freezed
class CreateFeedState with _$CreateFeedState {
  const CreateFeedState({
    this.status = CreateFeedStatus.initial,
    this.createdEntry,
    this.failure,
  });

  @override
  final CreateFeedStatus status;

  @override
  final FeedEntry? createdEntry;

  @override
  final FeedFailure? failure;
}
